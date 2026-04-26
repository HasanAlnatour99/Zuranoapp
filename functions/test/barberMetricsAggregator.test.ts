import { describe, expect, it } from "vitest";

import {
  accumulateBarberMetricsFromBookings,
  finalizeRates,
  type BookingMetricRow,
} from "../src/barberMetricsAggregator";

const DAY = 86400000;

function row(
  barberId: string,
  status: string,
  startMs: number,
  durationMin: number,
  serviceId = "svc1",
): BookingMetricRow {
  return {
    barberId,
    serviceId,
    statusRaw: status,
    startAtMs: startMs,
    endAtMs: startMs + durationMin * 60000,
  };
}

describe("accumulateBarberMetricsFromBookings", () => {
  const now = 1_700_000_000_000;
  const ratesWindowStartMs = now - 30 * DAY;
  const bounds = {
    ratesWindowStartMs,
    ratesCutoffMs: now,
    workloadStartMs: ratesWindowStartMs,
    workloadEndMs: now + 30 * DAY,
  };

  it("counts completed and service map inside rates window", () => {
    const m = accumulateBarberMetricsFromBookings(
      [
        row("b1", "completed", now - DAY, 30, "haircut"),
        row("b1", "completed", now - 2 * DAY, 45, "haircut"),
        row("b1", "completed", now - 3 * DAY, 30, "beard"),
      ],
      bounds,
    );
    const a = m.get("b1")!;
    expect(a.completedCount).toBe(3);
    expect(a.serviceCompletedCounts["haircut"]).toBe(2);
    expect(a.serviceCompletedCounts["beard"]).toBe(1);
  });

  it("sums workload minutes for pending/confirmed in workload window", () => {
    const m = accumulateBarberMetricsFromBookings(
      [
        row("b1", "pending", now + DAY, 60),
        row("b1", "confirmed", now + 2 * DAY, 30),
      ],
      bounds,
    );
    expect(m.get("b1")!.activeBookingMinutesInWindow).toBe(90);
  });

  it("ignores rows outside windows", () => {
    const m = accumulateBarberMetricsFromBookings(
      [
        row("b1", "completed", ratesWindowStartMs - DAY, 30),
        row("b1", "completed", now + 40 * DAY, 30),
      ],
      bounds,
    );
    expect(m.get("b1") ?? null).toBeNull();
  });

  it("finalizeRates matches denominator", () => {
    const agg = {
      completedCount: 6,
      cancelledCount: 2,
      noShowCount: 2,
      serviceCompletedCounts: {},
      activeBookingMinutesInWindow: 0,
    };
    const r = finalizeRates(agg);
    expect(r.completionRate).toBeCloseTo(0.6);
    expect(r.cancellationRate).toBeCloseTo(0.2);
    expect(r.noShowRate).toBeCloseTo(0.2);
  });
});
