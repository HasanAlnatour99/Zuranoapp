import { getFirestore } from "firebase-admin/firestore";
import { info, warn } from "firebase-functions/logger";
import { HttpsError, onCall, type CallableRequest } from "firebase-functions/v2/https";

import {
  assertValidStaffUsername,
  normalizeStaffUsername,
} from "./staffProvisioningShared";

/** Must match `users.role` values written by staff provisioning (see `staffProvisioningCallables`). */
const STAFF_ROLES_FOR_USERNAME_LOGIN = [
  "admin",
  "barber",
  "readonly",
  /** Legacy documents only */
  "employee",
] as const;

const db = getFirestore();

type ResolveStaffLoginEmailInput = {
  username: string;
};

/**
 * Resolves a staff username to the internal Firebase Auth email.
 * Unauthenticated; used only before password sign-in.
 */
export const resolveStaffLoginEmail = onCall(
  {
    region: "us-central1",
    enforceAppCheck: true,
  },
  async (request: CallableRequest) => {
    const data = request.data as ResolveStaffLoginEmailInput;
    const rawUsername = String(data.username || "");

    assertValidStaffUsername(rawUsername);
    const usernameLower = normalizeStaffUsername(rawUsername);
    const clientIp = request.rawRequest?.ip;
    if (clientIp) {
      info("resolveStaffLoginEmail_attempt", {
        clientIp,
        usernameLen: usernameLower.length,
      });
    } else {
      info("resolveStaffLoginEmail_attempt", { usernameLen: usernameLower.length });
    }

    const snap = await db
      .collection("users")
      .where("usernameLower", "==", usernameLower)
      .where("role", "in", STAFF_ROLES_FOR_USERNAME_LOGIN)
      .where("isActive", "==", true)
      .limit(1)
      .get();

    if (snap.empty) {
      warn("resolveStaffLoginEmail_not_found", { usernameLen: usernameLower.length });
      throw new HttpsError(
        "not-found",
        "No active staff account found for this username.",
      );
    }

    const user = snap.docs[0].data();

    if (!user.email) {
      throw new HttpsError(
        "failed-precondition",
        "Staff login email is missing.",
      );
    }

    return {
      email: user.email,
    };
  },
);
