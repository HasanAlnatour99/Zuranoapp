import { DateTime } from "luxon";

const DAY_MS = 86_400_000;

export function safeSalonTimeZone(raw: unknown): string {
  if (typeof raw !== "string") {
    return "UTC";
  }
  const z = raw.trim();
  if (!z.length) {
    return "UTC";
  }
  const t = DateTime.now().setZone(z);
  return t.isValid ? z : "UTC";
}

/**
 * Monday 00:00 (local) through next Monday 00:00 for the last two completed
 * local ISO weeks relative to [nowMs].
 */
export function previousTwoLocalWeekBounds(
  nowMs: number,
  zone: string,
): {
  lastWeek: { startMs: number; endExclusiveMs: number };
  prevWeek: { startMs: number; endExclusiveMs: number };
} {
  const z = DateTime.fromMillis(nowMs, { zone });
  const thisMonday = z.set({ weekday: 1 }).startOf("day");
  const lastWeekStart = thisMonday.minus({ weeks: 1 });
  const lastWeekEnd = thisMonday;
  const prevWeekStart = thisMonday.minus({ weeks: 2 });
  const prevWeekEnd = thisMonday.minus({ weeks: 1 });
  return {
    lastWeek: {
      startMs: lastWeekStart.toMillis(),
      endExclusiveMs: lastWeekEnd.toMillis(),
    },
    prevWeek: {
      startMs: prevWeekStart.toMillis(),
      endExclusiveMs: prevWeekEnd.toMillis(),
    },
  };
}

export function localMonthStartMillis(nowMs: number, zone: string): number {
  return DateTime.fromMillis(nowMs, { zone }).startOf("month").toMillis();
}

export function localDayStartMillis(nowMs: number, zone: string): number {
  return DateTime.fromMillis(nowMs, { zone }).startOf("day").toMillis();
}

export function localCalendarMonthParts(
  nowMs: number,
  zone: string,
): { year: number; month: number } {
  const z = DateTime.fromMillis(nowMs, { zone });
  return { year: z.year, month: z.month };
}

/** Earliest booking [startAt] to load for retention (single wide query). */
export function retentionQueryStartMs(
  monthStartMs: number,
  todayStartMs: number,
  prevWeekStartMs: number,
  priorLookbackDays: number,
  inactiveLookbackDays: number,
): number {
  return Math.min(
    monthStartMs - priorLookbackDays * DAY_MS,
    todayStartMs - inactiveLookbackDays * DAY_MS,
    prevWeekStartMs - DAY_MS,
  );
}
