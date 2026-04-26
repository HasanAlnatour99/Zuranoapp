const BookingStatuses = {
  pending: "pending",
  confirmed: "confirmed",
  completed: "completed",
  cancelled: "cancelled",
  noShow: "no_show",
} as const;

/** Legacy `scheduled` is treated as pending everywhere. */
function normalizeBookingStatus(raw: string): string {
  const s = raw.trim();
  if (!s || s === "scheduled") {
    return BookingStatuses.pending;
  }
  return s;
}

const ACTIVE_WORKLOAD = new Set<string>([
  BookingStatuses.pending,
  BookingStatuses.confirmed,
]);

export type BookingMetricRow = {
  barberId: string;
  serviceId: string;
  statusRaw: string;
  startAtMs: number;
  endAtMs: number;
};

export type AggregatedBarberMetrics = {
  completedCount: number;
  cancelledCount: number;
  noShowCount: number;
  serviceCompletedCounts: Record<string, number>;
  /** Pending + confirmed minutes where startAt is in [workloadStartMs, workloadEndMs]. */
  activeBookingMinutesInWindow: number;
};

/**
 * Pure aggregation for tests and the hourly job.
 *
 * - Terminal rates window: [ratesWindowStartMs, ratesCutoffMs] (inclusive startAt).
 * - Workload: pending/confirmed with startAt in [workloadStartMs, workloadEndMs].
 */
export function accumulateBarberMetricsFromBookings(
  rows: BookingMetricRow[],
  opts: {
    ratesWindowStartMs: number;
    ratesCutoffMs: number;
    workloadStartMs: number;
    workloadEndMs: number;
  },
): Map<string, AggregatedBarberMetrics> {
  const map = new Map<string, AggregatedBarberMetrics>();

  const ensure = (barberId: string): AggregatedBarberMetrics => {
    let a = map.get(barberId);
    if (!a) {
      a = {
        completedCount: 0,
        cancelledCount: 0,
        noShowCount: 0,
        serviceCompletedCounts: {},
        activeBookingMinutesInWindow: 0,
      };
      map.set(barberId, a);
    }
    return a;
  };

  for (const row of rows) {
    const barberId = row.barberId.trim();
    if (!barberId) {
      continue;
    }
    const status = normalizeBookingStatus(row.statusRaw);
    const start = row.startAtMs;
    const end = row.endAtMs;
    if (!(end > start)) {
      continue;
    }

    const inRates =
      start >= opts.ratesWindowStartMs && start <= opts.ratesCutoffMs;
    const inWorkload =
      start >= opts.workloadStartMs &&
      start <= opts.workloadEndMs &&
      ACTIVE_WORKLOAD.has(status);

    if (!inRates && !inWorkload) {
      continue;
    }

    const agg = ensure(barberId);

    if (inWorkload) {
      agg.activeBookingMinutesInWindow += Math.round((end - start) / 60000);
    }

    if (inRates) {
      switch (status) {
        case BookingStatuses.completed:
          agg.completedCount++;
          if (row.serviceId.trim().length > 0) {
            const sid = row.serviceId.trim();
            agg.serviceCompletedCounts[sid] =
              (agg.serviceCompletedCounts[sid] ?? 0) + 1;
          }
          break;
        case BookingStatuses.cancelled:
          agg.cancelledCount++;
          break;
        case BookingStatuses.noShow:
          agg.noShowCount++;
          break;
        default:
          break;
      }
    }
  }

  return map;
}

export function finalizeRates(agg: AggregatedBarberMetrics): {
  completionRate: number;
  cancellationRate: number;
  noShowRate: number;
} {
  const denom =
    agg.completedCount + agg.cancelledCount + agg.noShowCount;
  if (denom <= 0) {
    return {
      completionRate: 0,
      cancellationRate: 0,
      noShowRate: 0,
    };
  }
  return {
    completionRate: agg.completedCount / denom,
    cancellationRate: agg.cancelledCount / denom,
    noShowRate: agg.noShowCount / denom,
  };
}
