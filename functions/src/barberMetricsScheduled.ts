import {
  FieldPath,
  FieldValue,
  Timestamp,
  type QueryDocumentSnapshot,
} from "firebase-admin/firestore";
import { onSchedule } from "firebase-functions/v2/scheduler";

import {
  accumulateBarberMetricsFromBookings,
  finalizeRates,
  type BookingMetricRow,
} from "./barberMetricsAggregator";
import { db } from "./bookingShared";

const WINDOW_DAYS = 30;
const WORKLOAD_FORWARD_DAYS = 30;

/** Hourly rollup of last-window booking stats into `salons/{salonId}/barberMetrics/{employeeId}`. */
export const refreshBarberMetricsHourly = onSchedule(
  {
    schedule: "every 1 hours",
    region: "us-central1",
    timeZone: "UTC",
  },
  async () => {
    const now = Date.now();
    const ratesWindowStartMs = now - WINDOW_DAYS * 86400000;
    const ratesCutoffMs = now;
    const workloadStartMs = ratesWindowStartMs;
    const workloadEndMs = now + WORKLOAD_FORWARD_DAYS * 86400000;

    let salonCursor: QueryDocumentSnapshot | undefined;
    const salonPage = 20;

    for (;;) {
      let q = db.collection("salons").orderBy(FieldPath.documentId()).limit(
        salonPage,
      );
      if (salonCursor) {
        q = q.startAfter(salonCursor);
      }
      const salonSnap = await q.get();
      if (salonSnap.empty) {
        break;
      }

      for (const salonDoc of salonSnap.docs) {
        const salonId = salonDoc.id;
        await processSalon(salonId, {
          ratesWindowStartMs,
          ratesCutoffMs,
          workloadStartMs,
          workloadEndMs,
        }, now);
      }

      salonCursor = salonSnap.docs[salonSnap.docs.length - 1];
      if (salonSnap.size < salonPage) {
        break;
      }
    }
  },
);

async function processSalon(
  salonId: string,
  bounds: {
    ratesWindowStartMs: number;
    ratesCutoffMs: number;
    workloadStartMs: number;
    workloadEndMs: number;
  },
  nowMs: number,
): Promise<void> {
  const barberIds = await loadActiveBarberIds(salonId);
  const rows = await loadBookingRowsForSalon(
    salonId,
    bounds.ratesWindowStartMs,
    bounds.workloadEndMs,
  );

  const byBarber = accumulateBarberMetricsFromBookings(rows, bounds);

  const batch = db.batch();
  const periodEndAt = Timestamp.fromMillis(nowMs);
  const updatedAt = FieldValue.serverTimestamp();

  for (const employeeId of barberIds) {
    const agg = byBarber.get(employeeId) ?? {
      completedCount: 0,
      cancelledCount: 0,
      noShowCount: 0,
      serviceCompletedCounts: {},
      activeBookingMinutesInWindow: 0,
    };
    const rates = finalizeRates(agg);
    const ref = db.doc(`salons/${salonId}/barberMetrics/${employeeId}`);
    batch.set(
      ref,
      {
        employeeId,
        salonId,
        updatedAt,
        windowDays: WINDOW_DAYS,
        periodEndAt,
        completedCount: agg.completedCount,
        cancelledCount: agg.cancelledCount,
        noShowCount: agg.noShowCount,
        completionRate: rates.completionRate,
        cancellationRate: rates.cancellationRate,
        noShowRate: rates.noShowRate,
        serviceCompletedCounts: agg.serviceCompletedCounts,
        activeBookingMinutesInWindow: agg.activeBookingMinutesInWindow,
      },
      { merge: true },
    );
  }

  await batch.commit();
}

async function loadActiveBarberIds(salonId: string): Promise<string[]> {
  const snap = await db
    .collection(`salons/${salonId}/employees`)
    .where("role", "==", "barber")
    .where("isActive", "==", true)
    .get();
  return snap.docs.map((d) => d.id);
}

async function loadBookingRowsForSalon(
  salonId: string,
  fromMs: number,
  toMs: number,
): Promise<BookingMetricRow[]> {
  const from = Timestamp.fromMillis(fromMs);
  const to = Timestamp.fromMillis(toMs);
  const rows: BookingMetricRow[] = [];
  let cursor: QueryDocumentSnapshot | undefined;
  const page = 300;

  for (;;) {
    let q = db
      .collection(`salons/${salonId}/bookings`)
      .where("startAt", ">=", from)
      .where("startAt", "<=", to)
      .orderBy("startAt", "asc")
      .limit(page);
    if (cursor) {
      q = q.startAfter(cursor);
    }
    const snap = await q.get();
    if (snap.empty) {
      break;
    }
    for (const doc of snap.docs) {
      const d = doc.data();
      const barberId = typeof d.barberId === "string" ? d.barberId : "";
      const serviceId = typeof d.serviceId === "string" ? d.serviceId : "";
      const statusRaw = String(d.status ?? "");
      const st = d.startAt as Timestamp | undefined;
      const en = d.endAt as Timestamp | undefined;
      if (!st || !en || !barberId) {
        continue;
      }
      rows.push({
        barberId,
        serviceId,
        statusRaw,
        startAtMs: st.toMillis(),
        endAtMs: en.toMillis(),
      });
    }
    cursor = snap.docs[snap.docs.length - 1];
    if (snap.size < page) {
      break;
    }
  }

  return rows;
}
