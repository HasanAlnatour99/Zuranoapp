import { DocumentData, DocumentSnapshot } from "firebase-admin/firestore";
import { HttpsError } from "firebase-functions/v2/https";

export type FireUser = {
  salonId?: string;
  role?: string;
  isActive?: boolean;
};

export function assertSalonOwnerOrAdmin(
  caller: FireUser,
  salonId: string,
): void {
  const sid = salonId.trim();
  if (!sid) {
    throw new HttpsError("invalid-argument", "salonId is required.");
  }
  if (caller.isActive === false) {
    throw new HttpsError("permission-denied", "Inactive user.");
  }
  const role = String(caller.role ?? "").trim();
  if (role !== "owner" && role !== "admin") {
    throw new HttpsError("permission-denied", "Owner or admin only.");
  }
  if (String(caller.salonId ?? "").trim() !== sid) {
    throw new HttpsError("permission-denied", "Salon mismatch.");
  }
}

export function padYm(year: number, month: number): string {
  return `${year}${String(month).padStart(2, "0")}`;
}

export function payslipIdFor(employeeId: string, year: number, month: number): string {
  return `${employeeId.trim()}_${padYm(year, month)}`;
}

export function asNumber(v: unknown, fallback = 0): number {
  const n = Number(v);
  return Number.isFinite(n) ? n : fallback;
}

export function dataOrEmpty(snap: DocumentSnapshot): DocumentData {
  return snap.data() ?? {};
}
