/**
 * Pure weekly insight helpers (Firestore-free) for tests and scheduled jobs.
 */

export type WeeklySaleRow = {
  soldAtMs: number;
  total: number;
  status: string;
  employeeId: string;
  employeeName: string;
};

export type WeeklyBookingRow = {
  startAtMs: number;
  statusRaw: string;
};

export function normalizeBookingStatusForBusy(raw: string): string {
  const s = raw.trim();
  if (!s || s === "scheduled") {
    return "pending";
  }
  return s;
}

const BUSY_STATUSES = new Set(["pending", "confirmed", "completed"]);

export function isBusyBookingStatus(normalized: string): boolean {
  return BUSY_STATUSES.has(normalized);
}

export function filterSalesInWeek(
  rows: WeeklySaleRow[],
  startMs: number,
  endExclusiveMs: number,
): WeeklySaleRow[] {
  return rows.filter(
    (r) => r.soldAtMs >= startMs && r.soldAtMs < endExclusiveMs,
  );
}

export function completedSalesInWeek(rows: WeeklySaleRow[]): WeeklySaleRow[] {
  return rows.filter((r) => r.status.trim() === "completed");
}

export function sumCompletedRevenue(rows: WeeklySaleRow[]): number {
  return rows.reduce((a, r) => a + r.total, 0);
}

export type TopBarberByRevenue = {
  employeeId: string;
  employeeName: string;
  revenue: number;
} | null;

/** Tie-break: higher revenue wins; equal revenue → lexicographically smaller employeeId. */
export function topBarberByRevenue(
  completed: WeeklySaleRow[],
): TopBarberByRevenue {
  const byId = new Map<string, { name: string; revenue: number }>();
  for (const r of completed) {
    const id = r.employeeId.trim();
    if (!id) {
      continue;
    }
    const name = r.employeeName.trim() || id;
    const prev = byId.get(id);
    const revenue = (prev?.revenue ?? 0) + r.total;
    byId.set(id, { name: prev?.name ?? name, revenue });
  }
  if (byId.size === 0) {
    return null;
  }
  let bestId = "";
  let bestRevenue = -Infinity;
  for (const [id, v] of byId) {
    if (
      v.revenue > bestRevenue ||
      (v.revenue === bestRevenue && (bestId === "" || id < bestId))
    ) {
      bestId = id;
      bestRevenue = v.revenue;
    }
  }
  const best = byId.get(bestId)!;
  return {
    employeeId: bestId,
    employeeName: best.name,
    revenue: best.revenue,
  };
}

const WEEKDAY_UTC_SHORT = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

export function utcDateKey(ms: number): string {
  const d = new Date(ms);
  const y = d.getUTCFullYear();
  const m = String(d.getUTCMonth() + 1).padStart(2, "0");
  const day = String(d.getUTCDate()).padStart(2, "0");
  return `${y}-${m}-${day}`;
}

export type BusiestDayResult = {
  dateKey: string;
  count: number;
  weekdayShort: string;
} | null;

/** Tie-break on date key lexicographic (stable). */
export function busiestDayUtc(
  rows: WeeklyBookingRow[],
  startMs: number,
  endExclusiveMs: number,
): BusiestDayResult {
  const counts = new Map<string, number>();
  for (const r of rows) {
    if (r.startAtMs < startMs || r.startAtMs >= endExclusiveMs) {
      continue;
    }
    const st = normalizeBookingStatusForBusy(r.statusRaw);
    if (!isBusyBookingStatus(st)) {
      continue;
    }
    const key = utcDateKey(r.startAtMs);
    counts.set(key, (counts.get(key) ?? 0) + 1);
  }
  if (counts.size === 0) {
    return null;
  }
  let bestKey = "";
  let bestCount = -1;
  for (const [k, c] of counts) {
    if (c > bestCount || (c === bestCount && (bestKey === "" || k < bestKey))) {
      bestKey = k;
      bestCount = c;
    }
  }
  const [yy, mm, dd] = bestKey.split("-").map(Number);
  const noon = Date.UTC(yy, mm - 1, dd, 12, 0, 0);
  const weekdayShort = WEEKDAY_UTC_SHORT[new Date(noon).getUTCDay()];
  return { dateKey: bestKey, count: bestCount, weekdayShort };
}

const DAY_MS = 86_400_000;

/** Start of ISO week Monday00:00 UTC for the UTC calendar day of [d]. */
export function utcMondayStartMsForInstant(d: Date): number {
  const t = Date.UTC(d.getUTCFullYear(), d.getUTCMonth(), d.getUTCDate());
  const dow = d.getUTCDay();
  const offset = (dow + 6) % 7;
  return t - offset * DAY_MS;
}

/**
 * The completed UTC week immediately before the current week's Monday 00:00 UTC.
 * Safe to call on a Monday (scheduler): returns Mon..Sun just ended.
 */
export function previousCompletedUtcWeekBounds(nowMs: number): {
  startMs: number;
  endExclusiveMs: number;
} {
  const thisMonday = utcMondayStartMsForInstant(new Date(nowMs));
  return {
    startMs: thisMonday - 7 * DAY_MS,
    endExclusiveMs: thisMonday,
  };
}

/** e.g. `2026_W16` for labeling docs (ISO week of that Monday's Thursday). */
export function isoWeekKeyFromUtcMonday(mondayStartMs: number): string {
  const dt = new Date(mondayStartMs);
  const tdt = new Date(dt.valueOf());
  const dayn = (dt.getUTCDay() + 6) % 7;
  tdt.setUTCDate(tdt.getUTCDate() - dayn + 3);
  const firstThursday = tdt.getTime();
  tdt.setUTCMonth(0, 1);
  if (tdt.getUTCDay() !== 4) {
    tdt.setUTCDate(1 + ((4 - tdt.getUTCDay() + 7) % 7));
  }
  const week =
    1 + Math.round((firstThursday - tdt.valueOf()) / 604_800_000);
  const isoYear = new Date(firstThursday).getUTCFullYear();
  return `${isoYear}_W${String(week).padStart(2, "0")}`;
}
