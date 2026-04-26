import { FieldPath, Timestamp, type QueryDocumentSnapshot } from "firebase-admin/firestore";
import { onSchedule } from "firebase-functions/v2/scheduler";

import { BookingStatuses, db } from "./bookingShared";
import { bookingDeepLinkData, deliverTemplatedNotification } from "./notificationDispatch";
import {
  REMINDER_LEAD_MS,
  REMINDER_WINDOW_HALF_TICK_MS,
  type BookingReminderRow,
  filterBookingsForReminderTick,
  timestampToMs,
} from "./notificationReminderLogic";
import { getEmployeeAuthUid } from "./notificationSalonUsers";

async function queryBookingsInReminderWindow(
  salonId: string,
  low: Date,
  high: Date,
  status: string,
): Promise<BookingReminderRow[]> {
  const rows: BookingReminderRow[] = [];
  let cursor: QueryDocumentSnapshot | undefined;
  const page = 200;
  const lowTs = Timestamp.fromDate(low);
  const highTs = Timestamp.fromDate(high);

  for (;;) {
    let q = db
      .collection("salons")
      .doc(salonId)
      .collection("bookings")
      .where("status", "==", status)
      .where("startAt", ">=", lowTs)
      .where("startAt", "<=", highTs)
      .orderBy("startAt")
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
      const startMs = timestampToMs(d.startAt as Parameters<typeof timestampToMs>[0]);
      const customerId = typeof d.customerId === "string" ? d.customerId : "";
      const barberId = typeof d.barberId === "string" ? d.barberId : "";
      if (startMs == null || !customerId || !barberId) {
        continue;
      }
      rows.push({
        id: doc.id,
        salonId,
        status: typeof d.status === "string" ? d.status : "",
        startAtMs: startMs,
        customerId,
        barberId,
      });
    }
    cursor = snap.docs[snap.docs.length - 1];
    if (snap.size < page) {
      break;
    }
  }
  return rows;
}

export const sendUpcomingBookingReminders = onSchedule(
  {
    schedule: "every 15 minutes",
    region: "us-central1",
    timeZone: "UTC",
  },
  async () => {
    const nowMs = Date.now();
    const low = new Date(
      nowMs + REMINDER_LEAD_MS - REMINDER_WINDOW_HALF_TICK_MS,
    );
    const high = new Date(
      nowMs + REMINDER_LEAD_MS + REMINDER_WINDOW_HALF_TICK_MS,
    );

    let salonCursor: QueryDocumentSnapshot | undefined;
    const salonPage = 25;

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
        const pending = await queryBookingsInReminderWindow(
          salonId,
          low,
          high,
          BookingStatuses.pending,
        );
        const confirmed = await queryBookingsInReminderWindow(
          salonId,
          low,
          high,
          BookingStatuses.confirmed,
        );
        const combined = filterBookingsForReminderTick(
          [...pending, ...confirmed],
          nowMs,
        );

        for (const r of combined) {
          await deliverTemplatedNotification({
            userId: r.customerId,
            eventType: "booking_reminder",
            dedupeKey: `booking_reminder:${r.id}:${r.customerId}`,
            data: bookingDeepLinkData(r.salonId, r.id),
            actorRole: "system",
            salonId: r.salonId,
            bookingId: r.id,
            employeeId: r.barberId,
          });
          const barberUid = await getEmployeeAuthUid(r.salonId, r.barberId);
          if (barberUid) {
            await deliverTemplatedNotification({
              userId: barberUid,
              eventType: "booking_reminder",
              dedupeKey: `booking_reminder:${r.id}:${barberUid}`,
              data: bookingDeepLinkData(r.salonId, r.id),
              actorRole: "system",
              salonId: r.salonId,
              bookingId: r.id,
              employeeId: r.barberId,
            });
          }
        }
      }

      salonCursor = salonSnap.docs[salonSnap.docs.length - 1];
      if (salonSnap.size < salonPage) {
        break;
      }
    }
  },
);
