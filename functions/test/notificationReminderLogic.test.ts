import { describe, expect, it } from "vitest";

import {
  REMINDER_LEAD_MS,
  REMINDER_WINDOW_HALF_TICK_MS,
  bookingNeedsReminderNow,
  filterBookingsForReminderTick,
  type BookingReminderRow,
} from "../src/notificationReminderLogic";

describe("notificationReminderLogic", () => {
  it("bookingNeedsReminderNow is true when now aligns with startAt - lead", () => {
    const nowMs = 1_000_000_000_000;
    const startAtMs = nowMs + REMINDER_LEAD_MS;
    expect(bookingNeedsReminderNow(startAtMs, nowMs)).toBe(true);
  });

  it("filterBookingsForReminderTick keeps only eligible rows", () => {
    const nowMs = 5_000_000;
    const startAtMs = nowMs + REMINDER_LEAD_MS;
    const rows: BookingReminderRow[] = [
      {
        id: "a",
        salonId: "s",
        status: "pending",
        startAtMs,
        customerId: "c",
        barberId: "b",
      },
      {
        id: "b",
        salonId: "s",
        status: "cancelled",
        startAtMs,
        customerId: "c",
        barberId: "b",
      },
    ];
    const out = filterBookingsForReminderTick(rows, nowMs);
    expect(out.map((r) => r.id)).toEqual(["a"]);
  });

  it("half-tick window includes boundary slack", () => {
    const nowMs = 10_000_000;
    const startLow = nowMs + REMINDER_LEAD_MS - REMINDER_WINDOW_HALF_TICK_MS;
    const startHigh = nowMs + REMINDER_LEAD_MS + REMINDER_WINDOW_HALF_TICK_MS;
    expect(bookingNeedsReminderNow(startLow, nowMs)).toBe(true);
    expect(bookingNeedsReminderNow(startHigh, nowMs)).toBe(true);
  });
});
