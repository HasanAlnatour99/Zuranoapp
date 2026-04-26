import { describe, expect, it } from "vitest";

import {
  buildRetentionPayload,
  countCustomersWithNoVisitIn30Days,
  countDistinctCustomersCompletedThisMonth,
  countFirstTimeCustomersThisMonth,
  countNoShowsInRange,
  countRepeatCustomersThisMonth,
  countReturningCustomersThisMonth,
  retentionRateThisMonth,
  type RetentionBookingRow,
} from "../src/retentionInsightsAggregator";

const DAY = 86_400_000;

function row(
  customerId: string,
  startAtMs: number,
  status: string,
): RetentionBookingRow {
  return { customerId, startAtMs, status };
}

const monthStart = Date.UTC(2026, 3, 1, 0, 0, 0);
const nowMs = Date.UTC(2026, 3, 15, 12, 0, 0);
const todayStart = Date.UTC(2026, 3, 15, 0, 0, 0);
const priorStart = monthStart - 800 * DAY;

describe("repeat customers (2+ completed in month)", () => {
  it("counts only distinct customers with at least two completed visits", () => {
    const rows = [
      row("a", monthStart + DAY, "completed"),
      row("a", monthStart + 2 * DAY, "completed"),
      row("b", monthStart + DAY, "completed"),
    ];
    expect(countRepeatCustomersThisMonth(rows, monthStart, nowMs)).toBe(1);
  });
});

describe("first-time customers (1 visit this month, no prior in lookback)", () => {
  it("excludes anyone with a completed visit before month start", () => {
    const rows = [
      row("new", monthStart + DAY, "completed"),
      row("old", monthStart + 2 * DAY, "completed"),
      row("old", monthStart - 10 * DAY, "completed"),
    ];
    expect(
      countFirstTimeCustomersThisMonth(rows, monthStart, nowMs, priorStart),
    ).toBe(1);
  });
});

describe("inactive customers (no completed visit in 30 days)", () => {
  it("counts customers whose last completed visit is before rolling cutoff", () => {
    const cutoff = todayStart - 30 * DAY;
    const rows = [
      row("stale", cutoff - DAY, "completed"),
      row("fresh", todayStart - 5 * DAY, "completed"),
    ];
    expect(
      countCustomersWithNoVisitIn30Days(
        rows,
        todayStart,
        nowMs,
        todayStart - 400 * DAY,
      ),
    ).toBe(1);
  });
});

describe("no-show trend (week-over-week counts)", () => {
  it("counts no_shows per local week range", () => {
    const w0 = Date.UTC(2026, 3, 6, 0, 0, 0);
    const w1 = Date.UTC(2026, 3, 13, 0, 0, 0);
    const rows = [
      row("x", w0 + 1000, "no_show"),
      row("x", w0 + 2000, "completed"),
      row("y", w1 - 1000, "no_show"),
    ];
    expect(countNoShowsInRange(rows, w0, w1)).toBe(2);
  });

  it("exposes last minus previous as delta in payload", () => {
    const lastWeek = {
      startMs: Date.UTC(2026, 3, 6, 0, 0, 0),
      endExclusiveMs: Date.UTC(2026, 3, 13, 0, 0, 0),
    };
    const prevWeek = {
      startMs: Date.UTC(2026, 3, 30, 0, 0, 0),
      endExclusiveMs: Date.UTC(2026, 4, 6, 0, 0, 0),
    };
    const rows = [
      row("c", lastWeek.startMs + 1000, "no_show"),
      row("c", prevWeek.startMs + 1000, "no_show"),
      row("c", prevWeek.startMs + 2000, "no_show"),
    ];
    const p = buildRetentionPayload(rows, {
      timeZone: "UTC",
      calendarYear: 2026,
      calendarMonth: 4,
      monthStartMs: monthStart,
      nowMs,
      todayStartMs: todayStart,
      priorLookbackStartMs: priorStart,
      inactiveLookbackStartMs: todayStart - 400 * DAY,
      lastLocalWeek: lastWeek,
      prevLocalWeek: prevWeek,
    });
    expect(p.noShowCountLastLocalWeek).toBe(1);
    expect(p.noShowCountPreviousLocalWeek).toBe(2);
    expect(p.noShowDeltaLastVsPrevious).toBe(-1);
  });
});

describe("retention rate (returning / distinct completed this month)", () => {
  it("is 0 when no completed visits in month", () => {
    const rows = [
      row("x", monthStart -20 * DAY, "completed"),
    ];
    expect(
      retentionRateThisMonth(rows, monthStart, nowMs, priorStart),
    ).toBe(0);
  });

  it("is 1 when every customer this month had a prior completed visit", () => {
    const rows = [
      row("a", monthStart - 20 * DAY, "completed"),
      row("a", monthStart + DAY, "completed"),
      row("b", monthStart - 5 * DAY, "completed"),
      row("b", monthStart + 2 * DAY, "completed"),
    ];
    expect(countDistinctCustomersCompletedThisMonth(rows, monthStart, nowMs)).toBe(
      2,
    );
    expect(
      countReturningCustomersThisMonth(
        rows,
        monthStart,
        nowMs,
        priorStart,
      ),
    ).toBe(2);
    expect(retentionRateThisMonth(rows, monthStart, nowMs, priorStart)).toBe(1);
  });

  it("is 0.5 when half of month visitors are returning", () => {
    const rows = [
      row("old", monthStart - 20 * DAY, "completed"),
      row("old", monthStart + DAY, "completed"),
      row("new", monthStart + 2 * DAY, "completed"),
    ];
    expect(countDistinctCustomersCompletedThisMonth(rows, monthStart, nowMs)).toBe(
      2,
    );
    expect(
      countReturningCustomersThisMonth(rows, monthStart, nowMs, priorStart),
    ).toBe(1);
    expect(retentionRateThisMonth(rows, monthStart, nowMs, priorStart)).toBe(0.5);
  });
});

describe("buildRetentionPayload", () => {
  it("writes all structured numeric fields", () => {
    const lastWeek = {
      startMs: Date.UTC(2026, 3, 6, 0, 0, 0),
      endExclusiveMs: Date.UTC(2026, 3, 13, 0, 0, 0),
    };
    const prevWeek = {
      startMs: Date.UTC(2026, 3, 30, 0, 0, 0),
      endExclusiveMs: Date.UTC(2026, 4, 6, 0, 0, 0),
    };
    const rows = [
      row("a", monthStart + DAY, "completed"),
      row("a", monthStart + 2 * DAY, "completed"),
      row("b", monthStart + DAY, "completed"),
      row("c", lastWeek.startMs + 1000, "no_show"),
      row("c", prevWeek.startMs + 1000, "no_show"),
      row("c", prevWeek.startMs + 2000, "no_show"),
    ];
    const p = buildRetentionPayload(rows, {
      timeZone: "UTC",
      calendarYear: 2026,
      calendarMonth: 4,
      monthStartMs: monthStart,
      nowMs,
      todayStartMs: todayStart,
      priorLookbackStartMs: priorStart,
      inactiveLookbackStartMs: todayStart - 400 * DAY,
      lastLocalWeek: lastWeek,
      prevLocalWeek: prevWeek,
    });
    expect(p.repeatCustomersThisMonth).toBe(1);
    expect(p.firstTimeCustomersThisMonth).toBe(1);
    expect(p.distinctCustomersCompletedThisMonth).toBe(2);
    expect(p.returningCustomersThisMonth).toBe(0);
    expect(p.retentionRate).toBe(0);
    expect(p.noShowDeltaLastVsPrevious).toBe(-1);
  });
});
