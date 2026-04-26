import { createHash } from "crypto";

import { FieldValue, getFirestore } from "firebase-admin/firestore";
import { getMessaging } from "firebase-admin/messaging";

import {
  allowsCategoryForEvent,
  allowsPushForEvent,
  mergeNotificationPrefs,
} from "./notificationPrefs";
import { getLocalizedCopy, normalizeLocale, type SupportedLocale } from "./notificationCopy";
import type {
  NotificationChannel,
  NotificationEventType,
  SendNotificationInput,
} from "./notificationTypes";

const db = getFirestore();

export function dispatchDocumentId(dedupeKey: string): string {
  return createHash("sha256").update(dedupeKey).digest("hex").substring(0, 40);
}

/**
 * Atomically claims a send slot. Returns false if this dedupe was already processed.
 */
export async function tryClaimDispatch(params: {
  dedupeKey: string;
  eventType: NotificationEventType;
  userId: string;
  bookingId?: string;
  channel: NotificationChannel;
}): Promise<boolean> {
  const id = dispatchDocumentId(params.dedupeKey);
  const ref = db.collection("notificationDispatches").doc(id);
  return await db.runTransaction(async (txn) => {
    const snap = await txn.get(ref);
    if (snap.exists) {
      return false;
    }
    txn.set(ref, {
      eventType: params.eventType,
      userId: params.userId,
      bookingId: params.bookingId ?? null,
      dedupeKey: params.dedupeKey,
      channel: params.channel,
      sentAt: FieldValue.serverTimestamp(),
    });
    return true;
  });
}

async function loadUserPrefs(userId: string) {
  const snap = await db.collection("users").doc(userId).get();
  const raw = snap.exists ? snap.get("notificationPrefs") : undefined;
  return mergeNotificationPrefs(raw);
}

export async function getPrimaryLocaleForUser(userId: string): Promise<SupportedLocale> {
  const snap = await db
    .collection(`users/${userId}/devices`)
    .orderBy("lastSeenAt", "desc")
    .limit(1)
    .get();
  if (snap.empty) {
    return "en";
  }
  const loc = snap.docs[0].get("locale");
  return normalizeLocale(typeof loc === "string" ? loc : undefined);
}

async function persistInAppNotification(input: SendNotificationInput): Promise<void> {
  const ref = db.collection(`users/${input.userId}/notifications`).doc();
  await ref.set({
    type: input.eventType,
    title: input.title,
    body: input.body,
    data: input.data,
    status: "unread",
    createdAt: FieldValue.serverTimestamp(),
    readAt: null,
    actorRole: input.actorRole,
    salonId: input.salonId ?? null,
    bookingId: input.bookingId ?? null,
    employeeId: input.employeeId ?? null,
    payrollId: input.payrollId ?? null,
    violationId: input.violationId ?? null,
  });
}

async function collectFcmTokens(userId: string): Promise<string[]> {
  const snap = await db.collection(`users/${userId}/devices`).get();
  const tokens: string[] = [];
  for (const doc of snap.docs) {
    const push = doc.get("pushEnabled");
    const token = doc.get("token");
    if (push !== false && typeof token === "string" && token.length > 0) {
      tokens.push(token);
    }
  }
  return [...new Set(tokens)];
}

async function sendMulticast(
  tokens: string[],
  title: string,
  body: string,
  data: Record<string, string>,
): Promise<void> {
  if (tokens.length === 0) {
    return;
  }
  const messaging = getMessaging();
  const chunkSize = 500;
  for (let i = 0; i < tokens.length; i += chunkSize) {
    const chunk = tokens.slice(i, i + chunkSize);
    await messaging.sendEachForMulticast({
      tokens: chunk,
      notification: { title, body },
      data,
    });
  }
}

export async function deliverTemplatedNotification(
  input: Omit<SendNotificationInput, "title" | "body"> & {
    templateVars?: Record<string, string>;
  },
): Promise<void> {
  const prefs = await loadUserPrefs(input.userId);
  if (!allowsCategoryForEvent(prefs, input.eventType)) {
    return;
  }

  const locale = await getPrimaryLocaleForUser(input.userId);
  const { title, body } = getLocalizedCopy(
    input.eventType,
    locale,
    input.templateVars ?? {},
  );
  const resolved: SendNotificationInput = {
    ...input,
    title,
    body,
  };

  const inAppKey = `${input.dedupeKey}:in_app`;
  const claimedInApp = await tryClaimDispatch({
    dedupeKey: inAppKey,
    eventType: input.eventType,
    userId: input.userId,
    bookingId: input.bookingId,
    channel: "in_app",
  });
  if (claimedInApp) {
    await persistInAppNotification(resolved);
  }

  if (!allowsPushForEvent(prefs, input.eventType)) {
    return;
  }

  const pushKey = `${input.dedupeKey}:push`;
  const claimedPush = await tryClaimDispatch({
    dedupeKey: pushKey,
    eventType: input.eventType,
    userId: input.userId,
    bookingId: input.bookingId,
    channel: "push",
  });
  if (!claimedPush) {
    return;
  }

  const tokens = await collectFcmTokens(input.userId);
  const data: Record<string, string> = {
    ...input.data,
    type: input.eventType,
  };
  await sendMulticast(tokens, title, body, data);
}

export async function deliverNotificationWithCopy(
  input: SendNotificationInput,
): Promise<void> {
  const prefs = await loadUserPrefs(input.userId);
  if (!allowsCategoryForEvent(prefs, input.eventType)) {
    return;
  }

  const inAppKey = `${input.dedupeKey}:in_app`;
  const claimedInApp = await tryClaimDispatch({
    dedupeKey: inAppKey,
    eventType: input.eventType,
    userId: input.userId,
    bookingId: input.bookingId,
    channel: "in_app",
  });
  if (claimedInApp) {
    await persistInAppNotification(input);
  }

  if (!allowsPushForEvent(prefs, input.eventType)) {
    return;
  }

  const pushKey = `${input.dedupeKey}:push`;
  const claimedPush = await tryClaimDispatch({
    dedupeKey: pushKey,
    eventType: input.eventType,
    userId: input.userId,
    bookingId: input.bookingId,
    channel: "push",
  });
  if (!claimedPush) {
    return;
  }

  const tokens = await collectFcmTokens(input.userId);
  const data: Record<string, string> = {
    ...input.data,
    type: input.eventType,
  };
  await sendMulticast(tokens, input.title, input.body, data);
}

export function bookingDeepLinkData(
  salonId: string,
  bookingId: string,
): Record<string, string> {
  return {
    route: "booking",
    salonId,
    bookingId,
  };
}

export function payrollDeepLinkData(
  salonId: string,
  payrollId: string,
): Record<string, string> {
  return {
    route: "payroll",
    salonId,
    payrollId,
  };
}

export function violationDeepLinkData(
  salonId: string,
  violationId: string,
): Record<string, string> {
  return {
    route: "violation",
    salonId,
    violationId,
  };
}
