import { describe, expect, it } from "vitest";

import { HttpsError } from "firebase-functions/v2/https";

import {
  assertValidStaffRole,
  normalizeStaffEmail,
} from "../src/staffProvisioningShared";

describe("normalizeStaffEmail", () => {
  it("trims and lowercases", () => {
    expect(normalizeStaffEmail("  User@Example.COM \t")).toBe(
      "user@example.com",
    );
  });
});

describe("assertValidStaffRole", () => {
  it("accepts admin and barber", () => {
    expect(() => assertValidStaffRole("admin")).not.toThrow();
    expect(() => assertValidStaffRole("barber")).not.toThrow();
  });

  it("rejects owner and customer", () => {
    expect(() => assertValidStaffRole("owner")).toThrow(HttpsError);
    expect(() => assertValidStaffRole("customer")).toThrow(HttpsError);
  });
});
