import { describe, expect, it } from "vitest";

/** Mirrors Cloud Functions deterministic violation document id. */
function violationDocId(bookingId: string, violationType: string): string {
  return `${bookingId}__${violationType}`;
}

describe("violation dedupe id", () => {
  it("is stable per booking and type", () => {
    expect(violationDocId("bk_1", "barber_late")).toBe("bk_1__barber_late");
    expect(violationDocId("bk_1", "barber_no_show")).toBe("bk_1__barber_no_show");
  });
});
