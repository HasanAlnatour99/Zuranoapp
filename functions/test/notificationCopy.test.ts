import { describe, expect, it } from "vitest";

import { getLocalizedCopy } from "../src/notificationCopy";

describe("notificationCopy", () => {
  it("returns EN and AR strings for known event types", () => {
    const en = getLocalizedCopy("booking_reminder", "en");
    expect(en.title.length).toBeGreaterThan(0);
    expect(en.body.length).toBeGreaterThan(0);
    const ar = getLocalizedCopy("booking_reminder", "ar");
    expect(ar.title).not.toBe(en.title);
  });
});
