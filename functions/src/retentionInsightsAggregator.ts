/**
 * Pure customer retention metrics from booking rows (Firestore-free).
 * Callers supply salon-local window bounds as UTC millis from Luxon (or tests).
 */

export type RetentionBookingRow = {
  customerId: string;
  startAtMs: number;
  status: string;
};

const DAY_MS = 86_400_000;

export const PRIOR_VISIT_LOOKBACK_DAYS = 800;
export const INACTIVE_VISIT_LOOKBACK_DAYS = 420;

export function normalizeBookingStatus(raw: string): string {
  const s = raw.trim();
  if (!s || s === "scheduled") {
    return "pending";
  }
  return s;
}

export function isCompleted(status: string): boolean {
  return normalizeBookingStatus(status) === "completed";
}

export function isNoShow(status: string): boolean {
  return normalizeBookingStatus(status) === "no_show";
}

/**
 * Distinct customers with ≥1 completed visit in [monthStartMs, nowMs]
 * (salon-local month-to-date window, bounds as UTC instants).
 */
export function countDistinctCustomersCompletedThisMonth(
  rows: RetentionBookingRow[],
  monthStartMs: number,
  nowMs: number,
): number {
  const set = new Set<string>();
  for (const r of rows) {
    if (!isCompleted(r.status)) {
      continue;
    }
    if (r.startAtMs < monthStartMs || r.startAtMs > nowMs) {
      continue;
    }
    const cid = r.customerId.trim();
    if (!cid) {
      continue;
    }
    set.add(cid);
  }
  return set.size;
}

/**
 * Among customers with ≥1 completed visit this month, those who also had ≥1
 * completed visit in [priorLookbackStartMs, monthStartMs).
 */
export function countReturningCustomersThisMonth(
  rows: RetentionBookingRow[],
  monthStartMs: number,
  nowMs: number,
  priorLookbackStartMs: number,
): number {
  const inMonth = new Set<string>();
  const hadPrior = new Set<string>();

  for (const r of rows) {
    if (!isCompleted(r.status)) {
      continue;
    }
    const cid = r.customerId.trim();
    if (!cid) {
      continue;
    }
    const t = r.startAtMs;
    if (t >= monthStartMs && t <= nowMs) {
      inMonth.add(cid);
    } else if (t >= priorLookbackStartMs && t < monthStartMs) {
      hadPrior.add(cid);
    }
  }

  let n = 0;
  for (const cid of inMonth) {
    if (hadPrior.has(cid)) {
      n++;
    }
  }
  return n;
}

/**
 * Retention rate (month-to-date): returning / distinct with a completed visit
 * this month. 0 if no one completed this month.
 */
export function retentionRateThisMonth(
  rows: RetentionBookingRow[],
  monthStartMs: number,
  nowMs: number,
  priorLookbackStartMs: number,
): number {
  const denom = countDistinctCustomersCompletedThisMonth(
    rows,
    monthStartMs,
    nowMs,
  );
  if (denom === 0) {
    return 0;
  }
  const num = countReturningCustomersThisMonth(
    rows,
    monthStartMs,
    nowMs,
    priorLookbackStartMs,
  );
  return num / denom;
}

/** Distinct customers with ≥2 completed visits in [monthStartMs, nowMs]. */
export function countRepeatCustomersThisMonth(
  rows: RetentionBookingRow[],
  monthStartMs: number,
  nowMs: number,
): number {
  const counts = new Map<string, number>();
  for (const r of rows) {
    if (!isCompleted(r.status)) {
      continue;
    }
    if (r.startAtMs < monthStartMs || r.startAtMs > nowMs) {
      continue;
    }
    const cid = r.customerId.trim();
    if (!cid) {
      continue;
    }
    counts.set(cid, (counts.get(cid) ?? 0) + 1);
  }
  let n = 0;
  for (const c of counts.values()) {
    if (c >= 2) {
      n++;
    }
  }
  return n;
}

/**
 * Distinct customers with exactly one completed visit in the month window and
 * no completed visit in [priorLookbackStartMs, monthStartMs).
 */
export function countFirstTimeCustomersThisMonth(
  rows: RetentionBookingRow[],
  monthStartMs: number,
  nowMs: number,
  priorLookbackStartMs: number,
): number {
  const inMonth = new Map<string, number>();
  const hadPrior = new Set<string>();

  for (const r of rows) {
    if (!isCompleted(r.status)) {
      continue;
    }
    const cid = r.customerId.trim();
    if (!cid) {
      continue;
    }
    const t = r.startAtMs;
    if (t >= monthStartMs && t <= nowMs) {
      inMonth.set(cid, (inMonth.get(cid) ?? 0) + 1);
    } else if (t >= priorLookbackStartMs && t < monthStartMs) {
      hadPrior.add(cid);
    }
  }

  let n = 0;
  for (const [cid, c] of inMonth) {
    if (c === 1 && !hadPrior.has(cid)) {
      n++;
    }
  }
  return n;
}

/**
 * Customers whose last completed visit (within lookback) is strictly before
 * (todayStartMs - 30 days). Only considers customers with at least one
 * completed visit in the lookback window ending at nowMs.
 */
export function countCustomersWithNoVisitIn30Days(
  rows: RetentionBookingRow[],
  todayStartMs: number,
  nowMs: number,
  lookbackStartMs: number,
): number {
  const cutoff = todayStartMs - 30 * DAY_MS;
  const lastVisit = new Map<string, number>();

  for (const r of rows) {
    if (!isCompleted(r.status)) {
      continue;
    }
    if (r.startAtMs < lookbackStartMs || r.startAtMs > nowMs) {
      continue;
    }
    const cid = r.customerId.trim();
    if (!cid) {
      continue;
    }
    const prev = lastVisit.get(cid);
    if (prev === undefined || r.startAtMs > prev) {
      lastVisit.set(cid, r.startAtMs);
    }
  }

  let n = 0;
  for (const last of lastVisit.values()) {
    if (last < cutoff) {
      n++;
    }
  }
  return n;
}

export function countNoShowsInRange(
  rows: RetentionBookingRow[],
  startMs: number,
  endExclusiveMs: number,
): number {
  let n = 0;
  for (const r of rows) {
    if (r.startAtMs < startMs || r.startAtMs >= endExclusiveMs) {
      continue;
    }
    if (isNoShow(r.status)) {
      n++;
    }
  }
  return n;
}

export type RetentionPayload = {
  timeZone: string;
  calendarYear: number;
  calendarMonth: number;
  /** Distinct customers with 2+ completed visits in the month window. */
  repeatCustomersThisMonth: number;
  /** Distinct customers with exactly 1 completed this month and none in prior lookback. */
  firstTimeCustomersThisMonth: number;
  /** Distinct customers with ≥1 completed this month. */
  distinctCustomersCompletedThisMonth: number;
  /** Subset of [distinctCustomersCompletedThisMonth] with a prior completed visit in lookback. */
  returningCustomersThisMonth: number;
  /** returningCustomersThisMonth / distinctCustomersCompletedThisMonth (0–1). */
  retentionRate: number;
  customersWithNoVisit30Days: number;
  noShowCountLastLocalWeek: number;
  noShowCountPreviousLocalWeek: number;
  noShowDeltaLastVsPrevious: number;
};

export function buildRetentionPayload(
  rows: RetentionBookingRow[],
  opts: {
    timeZone: string;
    calendarYear: number;
    calendarMonth: number;
    monthStartMs: number;
    nowMs: number;
    todayStartMs: number;
    priorLookbackStartMs: number;
    inactiveLookbackStartMs: number;
    lastLocalWeek: { startMs: number; endExclusiveMs: number };
    prevLocalWeek: { startMs: number; endExclusiveMs: number };
  },
): RetentionPayload {
  const noShowLast = countNoShowsInRange(
    rows,
    opts.lastLocalWeek.startMs,
    opts.lastLocalWeek.endExclusiveMs,
  );
  const noShowPrev = countNoShowsInRange(
    rows,
    opts.prevLocalWeek.startMs,
    opts.prevLocalWeek.endExclusiveMs,
  );

  const distinctThisMonth = countDistinctCustomersCompletedThisMonth(
    rows,
    opts.monthStartMs,
    opts.nowMs,
  );
  const returningThisMonth = countReturningCustomersThisMonth(
    rows,
    opts.monthStartMs,
    opts.nowMs,
    opts.priorLookbackStartMs,
  );

  return {
    timeZone: opts.timeZone,
    calendarYear: opts.calendarYear,
    calendarMonth: opts.calendarMonth,
    repeatCustomersThisMonth: countRepeatCustomersThisMonth(
      rows,
      opts.monthStartMs,
      opts.nowMs,
    ),
    firstTimeCustomersThisMonth: countFirstTimeCustomersThisMonth(
      rows,
      opts.monthStartMs,
      opts.nowMs,
      opts.priorLookbackStartMs,
    ),
    distinctCustomersCompletedThisMonth: distinctThisMonth,
    returningCustomersThisMonth: returningThisMonth,
    retentionRate: retentionRateThisMonth(
      rows,
      opts.monthStartMs,
      opts.nowMs,
      opts.priorLookbackStartMs,
    ),
    customersWithNoVisit30Days: countCustomersWithNoVisitIn30Days(
      rows,
      opts.todayStartMs,
      opts.nowMs,
      opts.inactiveLookbackStartMs,
    ),
    noShowCountLastLocalWeek: noShowLast,
    noShowCountPreviousLocalWeek: noShowPrev,
    noShowDeltaLastVsPrevious: noShowLast - noShowPrev,
  };
}
