import { db } from "./bookingShared";

/** Firebase Auth uid linked on `salons/{salonId}/employees/{employeeId}` when set. */
export async function getEmployeeAuthUid(
  salonId: string,
  employeeId: string,
): Promise<string | null> {
  if (!employeeId) {
    return null;
  }
  const snap = await db
    .collection("salons")
    .doc(salonId)
    .collection("employees")
    .doc(employeeId)
    .get();
  if (!snap.exists) {
    return null;
  }
  const uid = snap.get("uid");
  return typeof uid === "string" && uid.length > 0 ? uid : null;
}

/** Owner + admin user document ids for a salon. */
export async function listOwnerAdminUserIds(salonId: string): Promise<string[]> {
  const snap = await db
    .collection("users")
    .where("salonId", "==", salonId)
    .where("role", "in", ["owner", "admin"])
    .get();
  return snap.docs.map((d) => d.id);
}
