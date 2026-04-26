/**
 * Integration tests for bookingCancel / bookingReschedule against the
 * Firestore + Auth + Functions emulators. Requires:
 *   npm run test:emulators
 * (JDK 21+ for the Firestore emulator.)
 */
import { initializeApp as initAdmin, getApps } from "firebase-admin/app";
import { getAuth as getAdminAuth } from "firebase-admin/auth";
import { FieldValue, getFirestore as getAdminFirestore, Timestamp } from "firebase-admin/firestore";
import { initializeApp as initClientApp, deleteApp, type FirebaseApp } from "firebase/app";
import { connectAuthEmulator, getAuth, signInWithCustomToken } from "firebase/auth";
import { connectFirestoreEmulator, getFirestore as getClientFirestore } from "firebase/firestore";
import {
  connectFunctionsEmulator,
  getFunctions,
  httpsCallable,
} from "firebase/functions";
import { afterAll, beforeAll, describe, expect, it } from "vitest";

const hasEmu = Boolean(process.env.FIRESTORE_EMULATOR_HOST);

function parseHostPort(
  raw: string | undefined,
  fallbackHost: string,
  fallbackPort: number,
): { host: string; port: number } {
  if (!raw) return { host: fallbackHost, port: fallbackPort };
  const [h, p] = raw.split(":");
  return { host: h || fallbackHost, port: Number(p) || fallbackPort };
}

/** Next UTC-aligned range (30-min slots) at least [hoursAhead] hours from now. */
function utcSlotRange(
  slotStepMinutes: 30 | 15,
  slotsDuration: number,
  hoursAhead = 2,
): { start: Date; end: Date } {
  const now = Date.now() + hoursAhead * 3_600_000;
  const d = new Date(now);
  const midnight = Date.UTC(
    d.getUTCFullYear(),
    d.getUTCMonth(),
    d.getUTCDate(),
  );
  const minutes = Math.floor((d.getTime() - midnight) / 60_000);
  const rounded = Math.ceil(minutes / slotStepMinutes) * slotStepMinutes;
  const startMs = midnight + rounded * 60_000;
  const start = new Date(startMs);
  const end = new Date(startMs + slotStepMinutes * 60_000 * slotsDuration);
  return { start, end };
}

describe.skipIf(!hasEmu)("bookingCallables integration", () => {
  const projectId = "demo-test";
  let app: FirebaseApp;

  const salonId = "int_salon_1";
  const ownerUid = "int_owner";
  const custUid = "int_customer";
  const barberUid = "int_barber";
  const employeeId = "int_emp";

  beforeAll(async () => {
    if (!getApps().length) {
      initAdmin({ projectId });
    }

    const fsEmu = parseHostPort(process.env.FIRESTORE_EMULATOR_HOST, "127.0.0.1", 8080);
    const authEmu = parseHostPort(
      process.env.FIREBASE_AUTH_EMULATOR_HOST,
      "127.0.0.1",
      9099,
    );
    const fnEmu = parseHostPort(
      process.env.FUNCTIONS_EMULATOR_HOST ?? process.env.FIREBASE_FUNCTIONS_EMULATOR_HOST,
      "127.0.0.1",
      5001,
    );

    app = initClientApp({ projectId });
    const db = getClientFirestore(app);
    connectFirestoreEmulator(db, fsEmu.host, fsEmu.port);
    const auth = getAuth(app);
    connectAuthEmulator(auth, `http://${authEmu.host}:${authEmu.port}`);
    const functions = getFunctions(app, "us-central1");
    connectFunctionsEmulator(functions, fnEmu.host, fnEmu.port);

    const adb = getAdminFirestore();
    await adb.doc(`users/${ownerUid}`).set({
      role: "owner",
      salonId,
    });
    await adb.doc(`users/${custUid}`).set({ role: "customer" });
    await adb.doc(`users/${barberUid}`).set({
      role: "barber",
      salonId,
      employeeId,
    });

    await adb.doc(`salons/${salonId}`).set({
      isActive: true,
      ownerUid,
    });
  });

  afterAll(async () => {
    await deleteApp(app);
  });

  async function authedCallable(name: string, uid: string) {
    const token = await getAdminAuth().createCustomToken(uid);
    await signInWithCustomToken(getAuth(app), token);
    return httpsCallable(getFunctions(app, "us-central1"), name);
  }

  async function seedPendingBooking(id: string) {
    const adb = getAdminFirestore();
    const { start, end } = utcSlotRange(30, 2, 2);
    await adb.doc(`salons/${salonId}/bookings/${id}`).set({
      id,
      salonId,
      customerId: custUid,
      barberId: employeeId,
      status: "pending",
      startAt: Timestamp.fromDate(start),
      endAt: Timestamp.fromDate(end),
      reportYear: start.getUTCFullYear(),
      reportMonth: start.getUTCMonth() + 1,
      reportPeriodKey:
        `${start.getUTCFullYear()}-${String(start.getUTCMonth() + 1).padStart(2, "0")}`,
      slotStepMinutes: 30,
      createdAt: FieldValue.serverTimestamp(),
      updatedAt: FieldValue.serverTimestamp(),
    });
    return { start, end };
  }

  it("bookingCancel succeeds and second call is idempotent", async () => {
    const bid = "cancel_dup";
    await seedPendingBooking(bid);
    const call = await authedCallable("bookingCancel", custUid);
    const r1 = await call({ salonId, bookingId: bid });
    expect((r1.data as { ok?: boolean }).ok).toBe(true);
    const r2 = await call({ salonId, bookingId: bid });
    const d2 = r2.data as { ok?: boolean; idempotent?: boolean };
    expect(d2.ok).toBe(true);
    expect(d2.idempotent).toBe(true);
  });

  it("bookingCancel fails when booking already completed", async () => {
    const bid = "cancel_done";
    const adb = getAdminFirestore();
    const { start, end } = utcSlotRange(30, 2, 3);
    await adb.doc(`salons/${salonId}/bookings/${bid}`).set({
      id: bid,
      salonId,
      customerId: custUid,
      barberId: employeeId,
      status: "completed",
      startAt: Timestamp.fromDate(start),
      endAt: Timestamp.fromDate(end),
      reportYear: start.getUTCFullYear(),
      reportMonth: start.getUTCMonth() + 1,
      reportPeriodKey: "2026-06",
    });
    const call = await authedCallable("bookingCancel", ownerUid);
    await expect(call({ salonId, bookingId: bid })).rejects.toMatchObject({
      code: "functions/failed-precondition",
    });
  });

  it("bookingReschedule returns new id and duplicate is idempotent", async () => {
    const bid = "resched_idem";
    const { start, end } = await seedPendingBooking(bid);
    const newStart = new Date(start.getTime() + 86_400_000);
    const newEnd = new Date(end.getTime() + 86_400_000);
    const call = await authedCallable("bookingReschedule", ownerUid);
    const r1 = await call({
      salonId,
      bookingId: bid,
      slotStepMinutes: 30,
      startAtMs: newStart.getTime(),
      endAtMs: newEnd.getTime(),
    });
    const d1 = r1.data as { ok?: boolean; newBookingId?: string };
    expect(d1.ok).toBe(true);
    expect(d1.newBookingId).toBeTruthy();
    const r2 = await call({
      salonId,
      bookingId: bid,
      slotStepMinutes: 30,
      startAtMs: newStart.getTime(),
      endAtMs: newEnd.getTime(),
    });
    const d2 = r2.data as {
      ok?: boolean;
      newBookingId?: string;
      idempotent?: boolean;
    };
    expect(d2.ok).toBe(true);
    expect(d2.idempotent).toBe(true);
    expect(d2.newBookingId).toBe(d1.newBookingId);
  });

  it("parallel bookingCancel calls on same booking both succeed", async () => {
    const bid = "cancel_parallel";
    await seedPendingBooking(bid);
    const call = await authedCallable("bookingCancel", custUid);
    const [a, b] = await Promise.all([
      call({ salonId, bookingId: bid }),
      call({ salonId, bookingId: bid }),
    ]);
    const ok = (a.data as { ok?: boolean }).ok &&
      (b.data as { ok?: boolean }).ok;
    expect(ok).toBe(true);
  });

  it("bookingReschedule fails on overlap", async () => {
    const adb = getAdminFirestore();
    const { start, end } = utcSlotRange(30, 4, 4);
    const duration = end.getTime() - start.getTime();
    const mid = new Date(start.getTime() + duration / 2);
    const b1 = "overlap_a";
    const b2 = "overlap_b";
    await adb.doc(`salons/${salonId}/bookings/${b1}`).set({
      id: b1,
      salonId,
      customerId: custUid,
      barberId: employeeId,
      status: "pending",
      startAt: Timestamp.fromDate(start),
      endAt: Timestamp.fromDate(end),
      reportYear: 2026,
      reportMonth: 6,
      reportPeriodKey: "2026-06",
      slotStepMinutes: 30,
    });
    const end2 = new Date(end.getTime() + duration / 2);
    await adb.doc(`salons/${salonId}/bookings/${b2}`).set({
      id: b2,
      salonId,
      customerId: custUid,
      barberId: employeeId,
      status: "pending",
      startAt: Timestamp.fromDate(mid),
      endAt: Timestamp.fromDate(end2),
      reportYear: 2026,
      reportMonth: 6,
      reportPeriodKey: "2026-06",
      slotStepMinutes: 30,
    });

    const call = await authedCallable("bookingReschedule", ownerUid);
    const slotMs = 30 * 60 * 1000;
    const clashStart = new Date(start.getTime() + slotMs);
    const clashEnd = new Date(start.getTime() + 3 * slotMs);
    await expect(
      call({
        salonId,
        bookingId: b2,
        slotStepMinutes: 30,
        startAtMs: clashStart.getTime(),
        endAtMs: clashEnd.getTime(),
      }),
    ).rejects.toMatchObject({ code: "functions/failed-precondition" });
  });
});
