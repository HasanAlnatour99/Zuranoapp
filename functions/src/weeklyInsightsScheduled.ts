import {
  FieldPath,
  FieldValue,
  Timestamp,
  type DocumentData,
  type QueryDocumentSnapshot,
} from "firebase-admin/firestore";
import { onSchedule } from "firebase-functions/v2/scheduler";

import { db } from "./bookingShared";
import {
  INACTIVE_VISIT_LOOKBACK_DAYS,
  PRIOR_VISIT_LOOKBACK_DAYS,
  buildRetentionPayload,
  type RetentionBookingRow,
} from "./retentionInsightsAggregator";
import {
  localCalendarMonthParts,
  localDayStartMillis,
  localMonthStartMillis,
  previousTwoLocalWeekBounds,
  retentionQueryStartMs,
  safeSalonTimeZone,
} from "./retentionTimeWindows";
import {
  busiestDayUtc,
  completedSalesInWeek,
  filterSalesInWeek,
  isoWeekKeyFromUtcMonday,
  previousCompletedUtcWeekBounds,
  sumCompletedRevenue,
  topBarberByRevenue,
  type WeeklyBookingRow,
  type WeeklySaleRow,
} from "./weeklyInsightsAggregator";

const INSIGHT_PERIOD = "weekly";

const INSIGHT_TYPES = {
  topBarberRevenue: "top_barber_revenue",
  weekTotalRevenue: "week_total_revenue",
  busiestDay: "busiest_day",
  customerRetention: "customer_retention",
} as const;

const SALON_PAGE = 20;
const DOC_PAGE = 300;

/** Weekly rollup into `salons/{salonId}/insights` (previous ISO week, UTC Monday boundary). */
export const refreshWeeklyInsights = onSchedule(
  {
    schedule: "every monday 05:00",
    region: "us-central1",
    timeZone: "UTC",
  },
  async () => {
    const now = Date.now();
    const { startMs, endExclusiveMs } = previousCompletedUtcWeekBounds(now);
    const weekMondayStart = startMs;
    const weekKey = isoWeekKeyFromUtcMonday(weekMondayStart);

    let salonCursor: QueryDocumentSnapshot | undefined;

    for (;;) {
      let q = db.collection("salons").orderBy(FieldPath.documentId()).limit(
        SALON_PAGE,
      );
      if (salonCursor) {
        q = q.startAfter(salonCursor);
      }
      const salonSnap = await q.get();
      if (salonSnap.empty) {
        break;
      }

      for (const salonDoc of salonSnap.docs) {
        await processSalonInsights(salonDoc.id, salonDoc.data(), {
          startMs,
          endExclusiveMs,
          weekKey,
          weekMondayStart,
        });
      }

      salonCursor = salonSnap.docs[salonSnap.docs.length - 1];
      if (salonSnap.size < SALON_PAGE) {
        break;
      }
    }
  },
);

async function processSalonInsights(
  salonId: string,
  salonData: DocumentData | undefined,
  bounds: {
    startMs: number;
    endExclusiveMs: number;
    weekKey: string;
    weekMondayStart: number;
  },
): Promise<void> {
  const saleRows = await loadSaleRows(salonId, bounds.startMs, bounds.endExclusiveMs);
  const bookingRows = await loadBookingRows(
    salonId,
    bounds.startMs,
    bounds.endExclusiveMs,
  );

  const inWeekSales = filterSalesInWeek(
    saleRows,
    bounds.startMs,
    bounds.endExclusiveMs,
  );
  const completed = completedSalesInWeek(inWeekSales);
  const totalRev = sumCompletedRevenue(completed);
  const topBarber = topBarberByRevenue(completed);
  const busiest = busiestDayUtc(
    bookingRows,
    bounds.startMs,
    bounds.endExclusiveMs,
  );

  const weekStartTs = Timestamp.fromMillis(bounds.weekMondayStart);
  const weekEndTs = Timestamp.fromMillis(bounds.endExclusiveMs - 1);

  const batch = db.batch();
  const updatedAt = FieldValue.serverTimestamp();

  const baseFields = {
    period: INSIGHT_PERIOD,
    weekKey: bounds.weekKey,
    weekStart: weekStartTs,
    weekEnd: weekEndTs,
    createdAt: updatedAt,
  };

  const topBarberRef = db.doc(
    `salons/${salonId}/insights/${bounds.weekKey}_${INSIGHT_TYPES.topBarberRevenue}`,
  );
  batch.set(topBarberRef, {
    ...baseFields,
    type: INSIGHT_TYPES.topBarberRevenue,
    title: "Top barber by revenue",
    message: topBarber
      ? `${topBarber.employeeName} led with ${topBarber.revenue.toFixed(2)} in completed sales.`
      : "No completed sales last week.",
    value: topBarber?.revenue ?? 0,
  });

  const totalRef = db.doc(
    `salons/${salonId}/insights/${bounds.weekKey}_${INSIGHT_TYPES.weekTotalRevenue}`,
  );
  batch.set(totalRef, {
    ...baseFields,
    type: INSIGHT_TYPES.weekTotalRevenue,
    title: "Total revenue this week",
    message: `Completed sales totaled ${totalRev.toFixed(2)}.`,
    value: totalRev,
  });

  const busyRef = db.doc(
    `salons/${salonId}/insights/${bounds.weekKey}_${INSIGHT_TYPES.busiestDay}`,
  );
  batch.set(busyRef, {
    ...baseFields,
    type: INSIGHT_TYPES.busiestDay,
    title: "Busiest day",
    message: busiest
      ? `${busiest.weekdayShort} (${busiest.dateKey} UTC) had ${busiest.count} active bookings.`
      : "No qualifying bookings last week.",
    value: busiest?.count ?? 0,
  });

  const nowMs = Date.now();
  const timeZone = safeSalonTimeZone(salonData?.timeZone);
  const { lastWeek, prevWeek } = previousTwoLocalWeekBounds(nowMs, timeZone);
  const monthStartMs = localMonthStartMillis(nowMs, timeZone);
  const todayStartMs = localDayStartMillis(nowMs, timeZone);
  const { year: calendarYear, month: calendarMonth } = localCalendarMonthParts(
    nowMs,
    timeZone,
  );
  const priorLookbackStartMs =
    monthStartMs - PRIOR_VISIT_LOOKBACK_DAYS * 86_400_000;
  const inactiveLookbackStartMs =
    todayStartMs - INACTIVE_VISIT_LOOKBACK_DAYS * 86_400_000;
  const queryFromMs = retentionQueryStartMs(
    monthStartMs,
    todayStartMs,
    prevWeek.startMs,
    PRIOR_VISIT_LOOKBACK_DAYS,
    INACTIVE_VISIT_LOOKBACK_DAYS,
  );

  const retentionRows = await loadRetentionBookingRows(
    salonId,
    queryFromMs,
    nowMs + 60_000,
  );
  const payload = buildRetentionPayload(retentionRows, {
    timeZone,
    calendarYear,
    calendarMonth,
    monthStartMs,
    nowMs,
    todayStartMs,
    priorLookbackStartMs,
    inactiveLookbackStartMs,
    lastLocalWeek: lastWeek,
    prevLocalWeek: prevWeek,
  });

  const retentionRef = db.doc(
    `salons/${salonId}/insights/${bounds.weekKey}_${INSIGHT_TYPES.customerRetention}`,
  );
  batch.set(retentionRef, {
    ...baseFields,
    type: INSIGHT_TYPES.customerRetention,
    title: "",
    message: "",
    value: 0,
    payload,
  });

  await batch.commit();
}

async function loadSaleRows(
  salonId: string,
  fromMs: number,
  toExclusiveMs: number,
): Promise<WeeklySaleRow[]> {
  const from = Timestamp.fromMillis(fromMs);
  const toEx = Timestamp.fromMillis(toExclusiveMs);
  const rows: WeeklySaleRow[] = [];
  let cursor: QueryDocumentSnapshot | undefined;

  for (;;) {
    let q = db
      .collection(`salons/${salonId}/sales`)
      .where("soldAt", ">=", from)
      .where("soldAt", "<", toEx)
      .orderBy("soldAt", "asc")
      .limit(DOC_PAGE);
    if (cursor) {
      q = q.startAfter(cursor);
    }
    const snap = await q.get();
    if (snap.empty) {
      break;
    }
    for (const doc of snap.docs) {
      const d = doc.data();
      const st = d.soldAt as Timestamp | undefined;
      if (!st) {
        continue;
      }
      rows.push({
        soldAtMs: st.toMillis(),
        total: typeof d.total === "number" ? d.total : Number(d.total) || 0,
        status: typeof d.status === "string" ? d.status : "",
        employeeId: typeof d.employeeId === "string" ? d.employeeId : "",
        employeeName: typeof d.employeeName === "string" ? d.employeeName : "",
      });
    }
    cursor = snap.docs[snap.docs.length - 1];
    if (snap.size < DOC_PAGE) {
      break;
    }
  }

  return rows;
}

async function loadBookingRows(
  salonId: string,
  fromMs: number,
  toExclusiveMs: number,
): Promise<WeeklyBookingRow[]> {
  const from = Timestamp.fromMillis(fromMs);
  const toEx = Timestamp.fromMillis(toExclusiveMs);
  const rows: WeeklyBookingRow[] = [];
  let cursor: QueryDocumentSnapshot | undefined;

  for (;;) {
    let q = db
      .collection(`salons/${salonId}/bookings`)
      .where("startAt", ">=", from)
      .where("startAt", "<", toEx)
      .orderBy("startAt", "asc")
      .limit(DOC_PAGE);
    if (cursor) {
      q = q.startAfter(cursor);
    }
    const snap = await q.get();
    if (snap.empty) {
      break;
    }
    for (const doc of snap.docs) {
      const d = doc.data();
      const st = d.startAt as Timestamp | undefined;
      if (!st) {
        continue;
      }
      rows.push({
        startAtMs: st.toMillis(),
        statusRaw: typeof d.status === "string" ? d.status : "",
      });
    }
    cursor = snap.docs[snap.docs.length - 1];
    if (snap.size < DOC_PAGE) {
      break;
    }
  }

  return rows;
}

async function loadRetentionBookingRows(
  salonId: string,
  fromMs: number,
  toExclusiveMs: number,
): Promise<RetentionBookingRow[]> {
  const from = Timestamp.fromMillis(fromMs);
  const toEx = Timestamp.fromMillis(toExclusiveMs);
  const rows: RetentionBookingRow[] = [];
  let cursor: QueryDocumentSnapshot | undefined;

  for (;;) {
    let q = db
      .collection(`salons/${salonId}/bookings`)
      .where("startAt", ">=", from)
      .where("startAt", "<", toEx)
      .orderBy("startAt", "asc")
      .limit(DOC_PAGE);
    if (cursor) {
      q = q.startAfter(cursor);
    }
    const snap = await q.get();
    if (snap.empty) {
      break;
    }
    for (const doc of snap.docs) {
      const d = doc.data();
      const st = d.startAt as Timestamp | undefined;
      if (!st) {
        continue;
      }
      const customerId =
        typeof d.customerId === "string" ? d.customerId : "";
      rows.push({
        customerId,
        startAtMs: st.toMillis(),
        status: typeof d.status === "string" ? d.status : "",
      });
    }
    cursor = snap.docs[snap.docs.length - 1];
    if (snap.size < DOC_PAGE) {
      break;
    }
  }

  return rows;
}
