import { FieldValue, type DocumentData } from "firebase-admin/firestore";
import { onDocumentWritten } from "firebase-functions/v2/firestore";
import { HttpsError, onCall, type CallableRequest } from "firebase-functions/v2/https";

import { db, requireString } from "./bookingShared";

const REGION = "us-central1" as const;

function roleLabel(role: string): string {
  const r = role.trim().toLowerCase();
  if (r === "barber") {
    return "Barber";
  }
  if (r === "admin") {
    return "Admin";
  }
  if (r === "readonly") {
    return "Team";
  }
  return "Specialist";
}

/** Maps private `employees/{id}` → customer-safe `publicSalons/{id}/team/{id}`. */
export function employeeToPublicTeamPayload(
  salonId: string,
  employeeId: string,
  e: DocumentData,
): Record<string, unknown> {
  const nameRaw = `${e.name ?? ""}`.trim();
  const name = nameRaw.length > 0 ? nameRaw : "Team member";
  const displayNameRaw = `${e.displayName ?? ""}`.trim();
  const displayName = displayNameRaw.length > 0 ? displayNameRaw : name;
  const avatar = `${e.profileImageUrl ?? ""}`.trim();
  const legacy = `${e.avatarUrl ?? ""}`.trim();
  const profileImageUrl = avatar || legacy || null;
  const isBookable = e.isBookable === true;
  const allowCustomerBooking = e.allowCustomerBooking === true || isBookable;
  const specialties = Array.isArray(e.specialties)
    ? e.specialties.map((x) => `${x}`.trim()).filter((s) => s.length > 0)
    : [];

  const sortOrder = typeof e.displayOrder === "number"
    ? e.displayOrder
    : typeof e.sortOrder === "number"
    ? e.sortOrder
    : 999;

  return {
    salonId,
    fullName: name,
    name,
    displayName,
    roleLabel: roleLabel(`${e.role ?? "barber"}`),
    profileImageUrl,
    specialties,
    isActive: e.isActive === true,
    isBookable,
    allowCustomerBooking,
    ratingAverage: typeof e.ratingAverage === "number"
      ? Math.min(5, Math.max(0, e.ratingAverage))
      : 0,
    ratingCount: typeof e.ratingCount === "number" ? Math.round(e.ratingCount) : 0,
    sortOrder,
    updatedAt: FieldValue.serverTimestamp(),
  };
}

async function assertSalonOwnerOrAdmin(
  request: CallableRequest,
  salonId: string,
): Promise<void> {
  if (!request.auth?.uid) {
    throw new HttpsError("unauthenticated", "Authentication required.");
  }
  const uid = request.auth.uid;
  const u = await db.collection("users").doc(uid).get();
  if (!u.exists) {
    throw new HttpsError("permission-denied", "User profile not found.");
  }
  const role = `${u.get("role") ?? ""}`.trim().toLowerCase();
  const sid = `${u.get("salonId") ?? ""}`.trim();
  if (sid !== salonId) {
    throw new HttpsError("permission-denied", "Wrong salon.");
  }
  if (role !== "owner" && role !== "admin") {
    throw new HttpsError(
      "permission-denied",
      "Only salon owner or admin can run this.",
    );
  }
}

export const onEmployeeWriteSyncPublicTeamMember = onDocumentWritten(
  {
    document: "salons/{salonId}/employees/{employeeId}",
    region: REGION,
  },
  async (event) => {
    const salonId = event.params.salonId as string;
    const employeeId = event.params.employeeId as string;
    const after = event.data?.after;
    const publicRef = db.doc(`publicSalons/${salonId}/team/${employeeId}`);

    if (!after?.exists) {
      await publicRef.delete().catch(() => undefined);
      return;
    }

    const payload = employeeToPublicTeamPayload(
      salonId,
      employeeId,
      after.data()!,
    );
    await publicRef.set(payload, { merge: true });
  },
);

export const backfillPublicTeamForSalon = onCall(
  { region: REGION, enforceAppCheck: true },
  async (request: CallableRequest) => {
    const data = request.data as Record<string, unknown>;
    const salonId = requireString(data, "salonId");
    await assertSalonOwnerOrAdmin(request, salonId);

    const empSnap = await db.collection(`salons/${salonId}/employees`).get();
    let synced = 0;
    for (const doc of empSnap.docs) {
      const payload = employeeToPublicTeamPayload(salonId, doc.id, doc.data());
      await db.doc(`publicSalons/${salonId}/team/${doc.id}`).set(payload, {
        merge: true,
      });
      synced++;
    }
    return { ok: true, synced };
  },
);
