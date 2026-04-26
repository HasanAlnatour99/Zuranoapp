import { describe, expect, it } from "vitest";
import { HttpsError } from "firebase-functions/v2/https";

import {
  assertValidStaffAuthEmail,
  assertValidStaffUsername,
  authSafeDisplayName,
  buildInternalStaffEmail,
  generateTemporaryPassword,
  normalizeStaffUsername,
  requireValidProvisioningPassword,
} from "../src/staffProvisioningShared";

describe("generateTemporaryPassword", () => {
  it("produces a reasonably long password with mixed character classes", () => {
    const p = generateTemporaryPassword();
    expect(p.length).toBeGreaterThanOrEqual(16);
    expect(/[a-z]/.test(p)).toBe(true);
    expect(/[A-Z]/.test(p)).toBe(true);
    expect(/[0-9]/.test(p)).toBe(true);
    expect(/[^a-zA-Z0-9]/.test(p)).toBe(true);
  });
});

describe("requireValidProvisioningPassword", () => {
  it("throws HttpsError invalid-argument when empty", () => {
    expect(() => requireValidProvisioningPassword("")).toThrowError(HttpsError);
  });

  it("throws when shorter than 8", () => {
    expect(() => requireValidProvisioningPassword("Abc1")).toThrowError(
      HttpsError,
    );
  });

  it("throws when missing character classes", () => {
    expect(() => requireValidProvisioningPassword("abcdef12")).toThrowError(
      HttpsError,
    );
  });

  it("accepts a valid owner-defined password", () => {
    expect(() =>
      requireValidProvisioningPassword("ValidPass1"),
    ).not.toThrow();
  });
});

describe("normalizeStaffUsername", () => {
  it("lowercases and trims", () => {
    expect(normalizeStaffUsername("  Alex.Cool_1 ")).toBe("alex.cool_1");
  });
});

describe("assertValidStaffUsername", () => {
  it("accepts valid usernames", () => {
    expect(() => assertValidStaffUsername("ab12_cd")).not.toThrow();
  });

  it("rejects too short", () => {
    expect(() => assertValidStaffUsername("abc")).toThrowError();
  });

  it("rejects invalid characters", () => {
    expect(() => assertValidStaffUsername("bad name")).toThrowError();
  });
});

describe("buildInternalStaffEmail", () => {
  it("embeds employee id and salon id", () => {
    expect(
      buildInternalStaffEmail({ employeeId: "emp_abc", salonId: "salon_x" }),
    ).toBe("emp_abc__salon_x@staff.zurano.app");
  });
});

describe("authSafeDisplayName", () => {
  it("returns undefined for missing input", () => {
    expect(authSafeDisplayName(undefined)).toBeUndefined();
    expect(authSafeDisplayName("")).toBeUndefined();
  });

  it("strips ASCII control characters", () => {
    expect(authSafeDisplayName("A\u0000B")).toBe("AB");
  });

  it("returns undefined when only controls", () => {
    expect(authSafeDisplayName("\u0000\t")).toBeUndefined();
  });
});

describe("assertValidStaffAuthEmail", () => {
  it("accepts a normal mailbox", () => {
    expect(assertValidStaffAuthEmail("  Barber@Salon.com ")).toBe(
      "barber@salon.com",
    );
  });

  it("rejects empty", () => {
    expect(() => assertValidStaffAuthEmail("")).toThrowError(HttpsError);
  });

  it("rejects internal staff domain", () => {
    expect(() =>
      assertValidStaffAuthEmail("x__y@staff.zurano.app"),
    ).toThrowError(HttpsError);
  });
});
