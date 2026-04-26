import { describe, expect, it } from "vitest";

import {
  localCalendarMonthParts,
  localMonthStartMillis,
  previousTwoLocalWeekBounds,
  retentionQueryStartMs,
  safeSalonTimeZone,
} from "../src/retentionTimeWindows";

describe("retentionTimeWindows", () => {
  it("safeSalonTimeZone falls back on invalid IANA", () => {
    expect(safeSalonTimeZone("")).toBe("UTC");
    expect(safeSalonTimeZone("Not/AZone")).toBe("UTC");
    expect(safeSalonTimeZone("America/New_York")).toBe("America/New_York");
  });

  it("previousTwoLocalWeekBounds returns ordered windows", () => {
    const nowMs = Date.UTC(2026, 3, 20, 12, 0, 0);
    const { lastWeek, prevWeek } = previousTwoLocalWeekBounds(nowMs, "UTC");
    expect(lastWeek.startMs).toBeLessThan(lastWeek.endExclusiveMs);
    expect(prevWeek.endExclusiveMs).toBe(lastWeek.startMs);
  });

  it("localMonthStartMillis matches calendar month in zone", () => {
    const ms = Date.UTC(2026, 3, 15, 12, 0, 0);
    expect(localMonthStartMillis(ms, "UTC")).toBe(Date.UTC(2026, 3, 1, 0, 0, 0));
    const parts = localCalendarMonthParts(ms, "UTC");
    expect(parts.year).toBe(2026);
    expect(parts.month).toBe(4);
  });

  it("retentionQueryStartMs is minimum of lookbacks", () => {
    const m = Date.UTC(2026, 3, 1);
    const t = Date.UTC(2026, 3, 15);
    const p = Date.UTC(2026, 3, 1);
    const q = retentionQueryStartMs(m, t, p, 10, 20);
    expect(q).toBe(Math.min(m - 10 * 86400000, t - 20 * 86400000, p - 86400000));
  });
});
