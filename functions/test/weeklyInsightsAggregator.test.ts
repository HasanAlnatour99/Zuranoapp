import { describe, expect, it } from "vitest";

import {
  busiestDayUtc,
  completedSalesInWeek,
  filterSalesInWeek,
  isoWeekKeyFromUtcMonday,
  previousCompletedUtcWeekBounds,
  sumCompletedRevenue,
  topBarberByRevenue,
  utcMondayStartMsForInstant,
  type WeeklyBookingRow,
  type WeeklySaleRow,
} from "../src/weeklyInsightsAggregator";

const DAY = 86_400_000;

function sale(
  soldAtMs: number,
  total: number,
  status: string,
  employeeId: string,
  employeeName: string,
): WeeklySaleRow {
  return {
    soldAtMs,
    total,
    status,
    employeeId,
    employeeName,
  };
}

function booking(startAtMs: number, statusRaw: string): WeeklyBookingRow {
  return { startAtMs, statusRaw };
}

describe("weeklyInsightsAggregator", () => {
  const weekStart = Date.UTC(2026, 3, 13, 0, 0, 0);
  const weekEndEx = weekStart + 7 * DAY;

  it("filters and sums completed sales in week", () => {
    const rows = [
      sale(weekStart +1000, 50, "completed", "e1", "Ann"),
      sale(weekStart + 2000, 30, "pending", "e1", "Ann"),
      sale(weekEndEx - 1000, 20, "completed", "e2", "Bob"),
      sale(weekEndEx, 99, "completed", "e2", "Bob"),
    ];
    const inWeek = filterSalesInWeek(rows, weekStart, weekEndEx);
    const completed = completedSalesInWeek(inWeek);
    expect(completed.length).toBe(2);
    expect(sumCompletedRevenue(completed)).toBe(70);
  });

  it("top barber tie-breaks by employeeId", () => {
    const completed = [
      sale(weekStart, 40, "completed", "b", "Barber B"),
      sale(weekStart + DAY, 40, "completed", "a", "Barber A"),
    ];
    const top = topBarberByRevenue(completed);
    expect(top?.employeeId).toBe("a");
    expect(top?.revenue).toBe(40);
  });

  it("busiest day counts pending, confirmed, completed only", () => {
    const rows = [
      booking(weekStart + 3600, "completed"),
      booking(weekStart + 7200, "confirmed"),
      booking(weekStart + 10_000, "cancelled"),
      booking(weekStart + DAY + 1000, "pending"),
      booking(weekStart + DAY + 2000, "pending"),
    ];
    const b = busiestDayUtc(rows, weekStart, weekEndEx);
    expect(b?.dateKey).toBe("2026-04-13");
    expect(b?.count).toBe(2);
  });

  it("previousCompletedUtcWeekBounds before current Monday", () => {
    const mondayApril20 = Date.UTC(2026, 3, 20, 12, 0, 0);
    const { startMs, endExclusiveMs } = previousCompletedUtcWeekBounds(
      mondayApril20,
    );
    expect(startMs).toBe(Date.UTC(2026, 3, 13, 0, 0, 0));
    expect(endExclusiveMs).toBe(Date.UTC(2026, 3, 20, 0, 0, 0));
  });

  it("utcMondayStartMsForInstant normalizes to Monday UTC", () => {
    const wed = new Date(Date.UTC(2026, 3, 15, 15, 0, 0));
    expect(utcMondayStartMsForInstant(wed)).toBe(Date.UTC(2026, 3, 13, 0, 0, 0));
  });

  it("isoWeekKeyFromUtcMonday returns stable key", () => {
    const mon = Date.UTC(2026, 3, 13, 0, 0, 0);
    expect(isoWeekKeyFromUtcMonday(mon)).toMatch(/^\d{4}_W\d{2}$/);
  });
});
