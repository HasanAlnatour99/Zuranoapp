/**
 * Auth model + top-level customers rules (emulator).
 * Run: npm run test:emulators  (from /functions)
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
  updateDoc,
} from "firebase/firestore";
import { afterAll, beforeAll, describe, it } from "vitest";

const rulesPath = resolve(__dirname, "../../firestore.rules");
const hasFirestoreEmu = Boolean(process.env.FIRESTORE_EMULATOR_HOST);

function firestoreEmulatorHostPort(): { host: string; port: number } {
  const raw = process.env.FIRESTORE_EMULATOR_HOST ?? "";
  const [host, portStr] = raw.split(":");
  return { host: host || "127.0.0.1", port: Number(portStr) || 8080 };
}

describe.skipIf(!hasFirestoreEmu)("firestore authz + customers", () => {
  let env: RulesTestEnvironment;

  beforeAll(async () => {
    const { host, port } = firestoreEmulatorHostPort();
    env = await initializeTestEnvironment({
      projectId: "demo-rules-authz",
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

  it("owner can delete top-level customer in own salon; barber cannot", async () => {
    await env.withSecurityRulesDisabled(async (ctx) => {
      const db = ctx.firestore();
      await setDoc(doc(db, "users", "owner_c"), {
        role: "owner",
        salonId: "salon_c",
        isActive: true,
      });
      await setDoc(doc(db, "users", "barber_c"), {
        role: "barber",
        salonId: "salon_c",
        employeeId: "emp_c",
        isActive: true,
      });
      await setDoc(doc(db, "customers", "cust_1"), {
        id: "cust_1",
        salonId: "salon_c",
        fullName: "A",
        isActive: true,
        visitCount: 0,
        totalSpent: 0,
        createdAt: Timestamp.now(),
      });
    });

    const barber = env.authenticatedContext("barber_c").firestore();
    await assertFails(deleteDoc(doc(barber, "customers", "cust_1")));

    const owner = env.authenticatedContext("owner_c").firestore();
    await assertSucceeds(deleteDoc(doc(owner, "customers", "cust_1")));
  });

  it("barber cannot create customer for another salon", async () => {
    await env.withSecurityRulesDisabled(async (ctx) => {
      const db = ctx.firestore();
      await setDoc(doc(db, "users", "barber_d"), {
        role: "barber",
        salonId: "salon_d",
        employeeId: "emp_d",
        isActive: true,
      });
    });

    const barber = env.authenticatedContext("barber_d").firestore();
    await assertFails(
      setDoc(doc(barber, "customers", "cust_bad"), {
        id: "cust_bad",
        salonId: "salon_other",
        fullName: "X",
        isActive: true,
        visitCount: 0,
        totalSpent: 0,
        createdAt: Timestamp.now(),
      }),
    );
  });

  it("user cannot change own role", async () => {
    await env.withSecurityRulesDisabled(async (ctx) => {
      const db = ctx.firestore();
      await setDoc(doc(db, "users", "cust_e"), {
        uid: "cust_e",
        role: "customer",
        email: "e@example.com",
        isActive: true,
      });
    });

    const db = env.authenticatedContext("cust_e").firestore();
    await assertFails(
      updateDoc(doc(db, "users", "cust_e"), {
        role: "owner",
        updatedAt: Timestamp.now(),
      }),
    );
  });

  it("customer can read own user doc", async () => {
    await env.withSecurityRulesDisabled(async (ctx) => {
      const db = ctx.firestore();
      await setDoc(doc(db, "users", "cust_f"), {
        uid: "cust_f",
        role: "customer",
        email: "f@example.com",
        isActive: true,
      });
    });

    const db = env.authenticatedContext("cust_f").firestore();
    await assertSucceeds(getDoc(doc(db, "users", "cust_f")));
  });
});
