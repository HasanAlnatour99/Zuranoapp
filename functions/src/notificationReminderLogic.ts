import type { Timestamp } from "firebase-admin/firestore";

/** Mirrors server booking status normalization without importing Firestore-bound modules. */
const BookingStatuses = {
  pending: "pending",
  confirmed: "confirmed",
  completed: "completed",
  cancelled: "cancelled",
  noShow: "no_show",
  rescheduled: "rescheduled",
} as const;

function normalizeBookingStatus(raw: string): string {
  const s = raw.trim();
  if (!s || s === "scheduled") {
    return BookingStatuses.pending;
  }
  return s;
}

export type BookingReminderRow = {
  id: string;
  salonId: string;
  status: string;
  startAtMs: number;
  customerId: string;
  barberId: string;
};

/** One reminder per booking per user: ~60 minutes before start. */
export const REMINDER_LEAD_MS = 60 * 60 * 1000;

/** Half of a 15-minute scheduler tick — bookings whose reminder window overlaps this slice are selected. */
export const REMINDER_WINDOW_HALF_TICK_MS = 7.5 * 60 * 1000;

export function isReminderEligibleStatus(statusRaw: string): boolean {
  const s = normalizeBookingStatus(statusRaw);
  return s === BookingStatuses.pending || s === BookingStatuses.confirmed;
}

/**
 * Returns true if this booking's start time falls in the reminder window around * `now + REMINDER_LEAD_MS` for the current cron instant.
 */
export function bookingNeedsReminderNow(
  startAtMs: number,
  nowMs: number,
): boolean {
  const target = startAtMs - REMINDER_LEAD_MS;
  const low = target - REMINDER_WINDOW_HALF_TICK_MS;
  const high = target + REMINDER_WINDOW_HALF_TICK_MS;
  return nowMs >= low && nowMs <= high;
}

export function filterBookingsForReminderTick(
  rows: BookingReminderRow[],
  nowMs: number,
): BookingReminderRow[] {
  return rows.filter(
    (r) =>
      isReminderEligibleStatus(r.status) &&
      bookingNeedsReminderNow(r.startAtMs, nowMs),
  );
}

export function timestampToMs(t: Timestamp | undefined): number | null {
  if (!t) {
    return null;
  }
  try {
    return t.toMillis();
  } catch {
    return null;
  }
}
