import { getFirestore, type DocumentData } from "firebase-admin/firestore";
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

const STAFF_ROLE_SET = new Set<string>(STAFF_ROLES_FOR_USERNAME_LOGIN);

const db = getFirestore();

type ResolveStaffLoginEmailInput = {
  username: string;
};

/**
 * Looks up an active staff user by normalized username (case-insensitive).
 * Primary: `users.usernameLower`. Fallback: `employees.usernameLower` then `users/{uid}`
 * so login still works if `users` is missing `usernameLower` but the employee row is correct.
 */
async function findActiveStaffUserByUsernameLower(
  usernameLower: string,
): Promise<DocumentData | null> {
  const userSnap = await db
    .collection("users")
    .where("usernameLower", "==", usernameLower)
    .where("role", "in", STAFF_ROLES_FOR_USERNAME_LOGIN)
    .where("isActive", "==", true)
    .limit(1)
    .get();

  if (!userSnap.empty) {
    return userSnap.docs[0].data();
  }

  // Legacy rows: canonical lowercase stored on `username` but `usernameLower` missing/wrong.
  const userByUsernameSnap = await db
    .collection("users")
    .where("username", "==", usernameLower)
    .where("isActive", "==", true)
    .limit(5)
    .get();
  for (const doc of userByUsernameSnap.docs) {
    const u = doc.data();
    const urole = String(u.role ?? "").trim().toLowerCase();
    if (STAFF_ROLE_SET.has(urole)) {
      return u;
    }
  }

  const empSnap = await db
    .collectionGroup("employees")
    .where("usernameLower", "==", usernameLower)
    .where("isActive", "==", true)
    .limit(5)
    .get();

  for (const doc of empSnap.docs) {
    const ed = doc.data();
    const uid = String(ed.uid ?? "").trim();
    if (!uid) {
      continue;
    }
    const empRole = String(ed.role ?? "").trim().toLowerCase();
    if (!STAFF_ROLE_SET.has(empRole)) {
      continue;
    }

    const uref = await db.collection("users").doc(uid).get();
    if (!uref.exists) {
      continue;
    }
    const u = uref.data()!;
    const urole = String(u.role ?? "").trim().toLowerCase();
    if (!STAFF_ROLE_SET.has(urole) || u.isActive !== true) {
      continue;
    }
    return u;
  }

  const empByUsernameSnap = await db
    .collectionGroup("employees")
    .where("username", "==", usernameLower)
    .where("isActive", "==", true)
    .limit(5)
    .get();

  for (const doc of empByUsernameSnap.docs) {
    const ed = doc.data();
    const uid = String(ed.uid ?? "").trim();
    if (!uid) {
      continue;
    }
    const empRole = String(ed.role ?? "").trim().toLowerCase();
    if (!STAFF_ROLE_SET.has(empRole)) {
      continue;
    }
    const uref = await db.collection("users").doc(uid).get();
    if (!uref.exists) {
      continue;
    }
    const u = uref.data()!;
    const urole = String(u.role ?? "").trim().toLowerCase();
    if (!STAFF_ROLE_SET.has(urole) || u.isActive !== true) {
      continue;
    }
    return u;
  }

  return null;
}

/**
 * Resolves a staff username to the internal Firebase Auth email.
 * Unauthenticated; used only before password sign-in.
 *
 * **App Check:** `enforceAppCheck` is off here so Android emulators (and other dev
 * setups without a registered App Check debug token) can still resolve usernames.
 * Tokens are still accepted when present. Other callables (e.g. staff provisioning)
 * keep enforcement. Prefer registering debug tokens in Firebase Console for full
 * protection during development if you re-enable this.
 */
export const resolveStaffLoginEmail = onCall(
  {
    region: "us-central1",
    enforceAppCheck: false,
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

    const user = await findActiveStaffUserByUsernameLower(usernameLower);

    if (!user) {
      warn("resolveStaffLoginEmail_not_found", { usernameLen: usernameLower.length });
      throw new HttpsError(
        "not-found",
        "No active staff account found for this username.",
      );
    }

    const emailRaw = user.email;
    const email =
      typeof emailRaw === "string" ? emailRaw.trim().toLowerCase() : "";
    if (!email.includes("@")) {
      throw new HttpsError(
        "failed-precondition",
        "Staff login email is missing.",
      );
    }

    return { email };
  },
);
