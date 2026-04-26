/**
 * Multi-tenant isolation, payroll owner-only writes, cross-salon denial.
 * Requires Firestore emulator: `npm run test:emulators` from /functions
 * or `firebase emulators:exec --only firestore ...`.
 */
import { readFileSync } from "node:fs";
import { resolve } from "node:path";
import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
  type RulesTestEnvironment,
} from "@firebase/rules-unit-testing";
import {
  deleteDoc,
  doc,
  getDoc,
  setDoc,
  Timestamp,
} from "firebase/firestore";
import { afterAll, beforeAll, describe, it } from "vitest";

const rulesPath = resolve(__dirname, "../../firestore.rules");
const hasFirestoreEmu = Boolean(process.env.FIRESTORE_EMULATOR_HOST);

function firestoreEmulatorHostPort(): { host: string; port: number } {
  const raw = process.env.FIRESTORE_EMULATOR_HOST ?? "";
  const [host, portStr] = raw.split(":");
  return { host: host || "127.0.0.1", port: Number(portStr) || 8080 };
}

describe.skipIf(!hasFirestoreEmu)("firestore tenant + payroll rules", () => {
  let env: RulesTestEnvironment;

  beforeAll(async () => {
    const { host, port } = firestoreEmulatorHostPort();
    env = await initializeTestEnvironment({
      projectId: "demo-rules-tenant",
      firestore: {
        rules: readFileSync(rulesPath, "utf8"),
        host,
        port,
      },
    });
  });

  afterAll(async () => {
    await env.cleanup();
  });

  it("barber cannot read bookings in another salon", async () => {
    await env.withSecurityRulesDisabled(async (ctx) => {
      const db = ctx.firestore();
      await setDoc(doc(db, "users", "barber_a"), {
        role: "barber",
        salonId: "salon_a",
        employeeId: "emp_a",
      });
      await setDoc(doc(db, "salons", "salon_a", "employees", "emp_a"), {
        id: "emp_a",
        salonId: "salon_a",
        role: "barber",
        uid: "barber_a",
      });
      await setDoc(doc(db, "salons", "salon_b"), {
        isActive: true,
        ownerUid: "owner_b",
      });
      const t0 = Timestamp.fromMillis(1_700_000_000_000);
      const t1 = Timestamp.fromMillis(1_700_000_360_000);
      await setDoc(doc(db, "salons", "salon_b", "bookings", "bk1"), {
        id: "bk1",
        salonId: "salon_b",
        customerId: "cust_x",
        barberId: "emp_other",
        status: "pending",
        startAt: t0,
        endAt: t1,
        reportYear: 2023,
        reportMonth: 11,
        reportPeriodKey: "2023-11",
      });
    });

    const db = env.authenticatedContext("barber_a").firestore();
    await assertFails(
      getDoc(doc(db, "salons", "salon_b", "bookings", "bk1")),
    );
  });

  it("payroll element: admin can read, cannot write; owner can write", async () => {
    await env.withSecurityRulesDisabled(async (ctx) => {
      const db = ctx.firestore();
      await setDoc(doc(db, "users", "owner_1"), {
        role: "owner",
        salonId: "salon_p",
      });
      await setDoc(doc(db, "users", "admin_1"), {
        role: "admin",
        salonId: "salon_p",
        permissions: { payroll: true },
      });
      await setDoc(doc(db, "salons", "salon_p"), {
        isActive: true,
        ownerUid: "owner_1",
      });
      await setDoc(doc(db, "salons", "salon_p", "employees", "admin_1"), {
        id: "admin_1",
        salonId: "salon_p",
        role: "admin",
        uid: "admin_1",
      });
    });

    const adminDb = env.authenticatedContext("admin_1").firestore();
    const ownerDb = env.authenticatedContext("owner_1").firestore();
    const path = doc(
      adminDb,
      "salons",
      "salon_p",
      "payroll_elements",
      "el1",
    );

    await assertSucceeds(getDoc(path));

    await assertFails(
      setDoc(path, {
        id: "el1",
        salonId: "salon_p",
        name: "Base",
        kind: "fixed",
        amount: 100,
        createdAt: Timestamp.now(),
      }),
    );

    await assertSucceeds(
      setDoc(doc(ownerDb, "salons", "salon_p", "payroll_elements", "el1"), {
        id: "el1",
        salonId: "salon_p",
        name: "Base",
        kind: "fixed",
        amount: 100,
        createdAt: Timestamp.now(),
      }),
    );
  });

  it("sale delete is owner-only (barber cannot delete)", async () => {
    await env.withSecurityRulesDisabled(async (ctx) => {
      const db = ctx.firestore();
      await setDoc(doc(db, "users", "owner_s"), {
        role: "owner",
        salonId: "salon_s",
      });
      await setDoc(doc(db, "users", "barber_s"), {
        role: "barber",
        salonId: "salon_s",
        employeeId: "emp_s",
      });
      await setDoc(doc(db, "salons", "salon_s"), {
        isActive: true,
        ownerUid: "owner_s",
      });
      await setDoc(doc(db, "salons", "salon_s", "employees", "emp_s"), {
        id: "emp_s",
        salonId: "salon_s",
        role: "barber",
        uid: "barber_s",
      });
      await setDoc(doc(db, "salons", "salon_s", "sales", "sale1"), {
        id: "sale1",
        salonId: "salon_s",
        employeeId: "emp_s",
        barberId: "emp_s",
        employeeName: "S",
        lineItems: [],
        serviceNames: [],
        subtotal: 10,
        tax: 0,
        discount: 0,
        total: 10,
        paymentMethod: "cash",
        status: "completed",
        soldAt: Timestamp.now(),
        reportYear: 2024,
        reportMonth: 1,
      });
    });

    const barberDb = env.authenticatedContext("barber_s").firestore();
    await assertFails(
      deleteDoc(doc(barberDb, "salons", "salon_s", "sales", "sale1")),
    );

    const ownerDb = env.authenticatedContext("owner_s").firestore();
    await assertSucceeds(
      deleteDoc(doc(ownerDb, "salons", "salon_s", "sales", "sale1")),
    );
  });

  it("expense delete succeeds (owner/admin path)", async () => {
    await env.withSecurityRulesDisabled(async (ctx) => {
      const db = ctx.firestore();
      await setDoc(doc(db, "users", "owner_e"), {
        role: "owner",
        salonId: "salon_e",
      });
      await setDoc(doc(db, "salons", "salon_e"), {
        isActive: true,
        ownerUid: "owner_e",
      });
      await setDoc(doc(db, "salons", "salon_e", "expenses", "ex1"), {
        id: "ex1",
        salonId: "salon_e",
        title: "Rent",
        category: "fixed",
        amount: 500,
        incurredAt: Timestamp.now(),
        createdByUid: "owner_e",
        createdByName: "Owner",
        reportYear: 2024,
        reportMonth: 1,
      });
    });

    const db = env.authenticatedContext("owner_e").firestore();
    await assertSucceeds(
      deleteDoc(doc(db, "salons", "salon_e", "expenses", "ex1")),
    );
  });
});
