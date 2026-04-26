import { Timestamp } from "firebase-admin/firestore";
import { HttpsError, onCall } from "firebase-functions/v2/https";

import {
  assertCanReadSalonAvailability,
  db,
  normalizeBookingStatus,
  requireNumber,
  requireString,
} from "./bookingShared";

/**
 * Returns overlap-safe booking intervals for a salon day (no customer PII).
 * Used by the client recommendation engine instead of reading raw booking docs.
 */
export const bookingDayBusyMask = onCall(
  { region: "us-central1" },
  async (request) => {
    if (!request.auth?.uid) {
      throw new HttpsError("unauthenticated", "Sign in required.");
    }
    const uid = request.auth.uid;
    const data = request.data as Record<string, unknown>;
    const salonId = requireString(data, "salonId");
    const startFromMs = requireNumber(data, "startFromMs");
    const startToMs = requireNumber(data, "startToMs");
    if (startToMs < startFromMs) {
      throw new HttpsError(
        "invalid-argument",
        "startToMs must be >= startFromMs.",
      );
    }

    await assertCanReadSalonAvailability(salonId, uid);

    const startFrom = Timestamp.fromMillis(startFromMs);
    const startTo = Timestamp.fromMillis(startToMs);

    const snap = await db
      .collection(`salons/${salonId}/bookings`)
      .where("startAt", ">=", startFrom)
      .where("startAt", "<=", startTo)
      .orderBy("startAt", "asc")
      .limit(500)
      .get();

    const intervals = snap.docs
      .map((doc) => {
        const d = doc.data();
        const barberId = typeof d.barberId === "string" ? d.barberId : "";
        const st = d.startAt as Timestamp | undefined;
        const en = d.endAt as Timestamp | undefined;
        if (!st || !en || !barberId) {
          return null;
        }
        return {
          barberId,
          startAtMs: st.toMillis(),
          endAtMs: en.toMillis(),
          status: normalizeBookingStatus(String(d.status ?? "")),
        };
      })
      .filter((x): x is NonNullable<typeof x> => x !== null);

    return { intervals };
  },
);
