import { randomBytes } from "crypto";

import { HttpsError } from "firebase-functions/v2/https";

export const STAFF_ROLES = new Set<string>(["admin", "barber", "readonly"]);

/** Meets typical Firebase password policies (mixed classes + length). */
export function generateTemporaryPassword(): string {
  const suffix = randomBytes(9).toString("base64url");
  return `Tmp1!${suffix}`;
}

const UPPER = /[A-Z]/u;
const LOWER = /[a-z]/u;
const DIGIT = /[0-9]/u;

/**
 * Validates a salon-provisioned password. Throws HttpsError invalid-argument
 * with product-facing English messages.
 */
export function requireValidProvisioningPassword(raw: string): void {
  const p = raw.trim();
  if (!p) {
    throw new HttpsError("invalid-argument", "Password is required.");
  }
  if (p.length < 8) {
    throw new HttpsError(
      "invalid-argument",
      "Password must be at least 8 characters.",
    );
  }
  if (!UPPER.test(p) || !LOWER.test(p) || !DIGIT.test(p)) {
    throw new HttpsError(
      "invalid-argument",
      "Password must include uppercase, lowercase, and a number.",
    );
  }
}

export function normalizeStaffEmail(raw: string): string {
  return raw.trim().toLowerCase();
}

/**
 * Strips C0/C1 controls and caps length for Admin SDK `createUser({ displayName })`.
 * Returns `undefined` when input is missing or nothing usable remains after sanitize.
 */
export function authSafeDisplayName(name?: string): string | undefined {
  if (!name) {
    return undefined;
  }
  const out = name
    .normalize("NFC")
    .replace(/[\u0000-\u001F\u007F-\u009F]/g, "")
    .trim()
    .slice(0, 256);
  return out.length > 0 ? out : undefined;
}

/** Same shape as client-side staff email checks (RFC-like, no spaces). */
const STAFF_AUTH_EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]+$/u;

/**
 * Validates the barber's real sign-in email for Auth.createUser.
 * Rejects empty/invalid format and internal staff mailboxes.
 */
export function assertValidStaffAuthEmail(raw: string): string {
  const e = normalizeStaffEmail(raw);
  if (!STAFF_AUTH_EMAIL_RE.test(e)) {
    throw new HttpsError("invalid-argument", "Invalid email format.", {
      field: "email",
      reason: "invalid_format",
    });
  }
  const at = e.lastIndexOf("@");
  const domain = at >= 0 ? e.slice(at + 1) : "";
  if (domain === STAFF_EMAIL_DOMAIN) {
    throw new HttpsError(
      "invalid-argument",
      "Enter the barber's own email address.",
      { field: "email", reason: "internal_domain_not_allowed" },
    );
  }
  return e;
}

/** Lowercase internal auth mailbox for salon staff (Firebase email/password). */
export const STAFF_EMAIL_DOMAIN = "staff.zurano.app";
export const STAFF_INTERNAL_EMAIL_DOMAIN = STAFF_EMAIL_DOMAIN;

export function buildInternalStaffEmail(args: {
  employeeId: string;
  salonId: string;
}): string {
  return `${args.employeeId}__${args.salonId}@${STAFF_EMAIL_DOMAIN}`;
}

export function normalizeStaffUsername(raw: string): string {
  return raw.trim().toLowerCase();
}

const STAFF_USERNAME_RE = /^[a-z0-9_.]{4,20}$/u;

/**
 * Validates salon username (normalized). Throws [HttpsError] invalid-argument.
 */
export function assertValidStaffUsername(raw: string): void {
  const u = normalizeStaffUsername(raw);
  if (!STAFF_USERNAME_RE.test(u)) {
    throw new HttpsError(
      "invalid-argument",
      "Username must be 4–20 characters: lowercase letters, numbers, underscore, or dot.",
    );
  }
}

export function assertValidStaffRole(role: string): void {
  const r = role.trim();
  if (!STAFF_ROLES.has(r)) {
    throw new HttpsError(
      "invalid-argument",
      "role must be admin, barber, or readonly.",
    );
  }
}
