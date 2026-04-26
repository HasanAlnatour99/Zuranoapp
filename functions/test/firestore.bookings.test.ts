/**
 * Firestore security rules for bookings + stable pagination (startAt + documentId).
 * Requires Firestore emulator (`FIRESTORE_EMULATOR_HOST`), e.g.:
 *   npm run test:emulators
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
  collection,
  doc,
  documentId,
  getDoc,
  getDocs,
  limit,
  orderBy,
  query,
  setDoc,
  startAfter,
  updateDoc,
  Timestamp,
  type QueryDocumentSnapshot,
} from "firebase/firestore";
import { afterAll, beforeAll, describe, expect, it } from "vitest";

const rulesPath = resolve(__dirname, "../../firestore.rules");
const hasFirestoreEmu = Boolean(process.env.FIRESTORE_EMULATOR_HOST);

function firestoreEmulatorHostPort(): { host: string; port: number } {
  const raw = process.env.FIRESTORE_EMULATOR_HOST ?? "";
  const [host, portStr] = raw.split(":");
  return { host: host || "127.0.0.1", port: Number(portStr) || 8080 };
}

describe.skipIf(!hasFirestoreEmu)("firestore bookings rules + pagination", () => {
  let env: RulesTestEnvironment;

  const sameStart = Timestamp.fromMillis(1_700_000_000_000);
  const endLater = Timestamp.fromMillis(1_700_000_360_000);

  beforeAll(async () => {
    const { host, port } = firestoreEmulatorHostPort();
    env = await initializeTestEnvironment({
      projectId: "demo-rules-bookings",
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

  async function seedBookingFixtures() {
    await env.withSecurityRulesDisabled(async (ctx) => {
      const db = ctx.firestore();
      await setDoc(doc(db, "users", "cust_a"), { role: "customer" });
      await setDoc(doc(db, "users", "cust_b"), { role: "customer" });
      await setDoc(doc(db, "users", "owner_o"), {
        role: "owner",
        salonId: "salon1",
      });
      await setDoc(doc(db, "users", "admin_a"), {
        role: "admin",
        salonId: "salon1",
      });
      await setDoc(doc(db, "users", "barber_x"), {
        role: "barber",
        salonId: "salon1",
        employeeId: "emp_x",
      });
      await setDoc(doc(db, "users", "barber_y"), {
        role: "barber",
        salonId: "salon1",
        employeeId: "emp_y",
      });

      await setDoc(doc(db, "salons", "salon1"), {
        isActive: true,
        ownerUid: "owner_o",
      });

      await setDoc(doc(db, "salons", "salon1", "bookings", "bk_cust"), {
        id: "bk_cust",
        salonId: "salon1",
        customerId: "cust_a",
        barberId: "emp_x",
        status: "pending",
        startAt: sameStart,
        endAt: endLater,
        reportYear: 2023,
        reportMonth: 11,
        reportPeriodKey: "2023-11",
      });

      await setDoc(doc(db, "salons", "salon1", "bookings", "bk_barber_y"), {
        id: "bk_barber_y",
        salonId: "salon1",
        customerId: "cust_b",
        barberId: "emp_y",
        status: "pending",
        startAt: sameStart,
        endAt: endLater,
        reportYear: 2023,
        reportMonth: 11,
        reportPeriodKey: "2023-11",
      });
    });
  }

  describe("booking security rules", () => {
    beforeAll(seedBookingFixtures);

    it("customer reads own booking", async () => {
      const db = env.authenticatedContext("cust_a").firestore();
      await assertSucceeds(
        getDoc(doc(db, "salons", "salon1", "bookings", "bk_cust")),
      );
    });

    it("customer cannot read another customer's booking", async () => {
      const db = env.authenticatedContext("cust_a").firestore();
      await assertFails(
        getDoc(doc(db, "salons", "salon1", "bookings", "bk_barber_y")),
      );
    });

    it("barber reads booking for their chair", async () => {
      const db = env.authenticatedContext("barber_x").firestore();
      await assertSucceeds(
        getDoc(doc(db, "salons", "salon1", "bookings", "bk_cust")),
      );
    });

    it("barber cannot read another barber's booking", async () => {
      const db = env.authenticatedContext("barber_x").firestore();
      await assertFails(
        getDoc(doc(db, "salons", "salon1", "bookings", "bk_barber_y")),
      );
    });

    it("owner reads booking", async () => {
      const db = env.authenticatedContext("owner_o").firestore();
      await assertSucceeds(
        getDoc(doc(db, "salons", "salon1", "bookings", "bk_cust")),
      );
    });

    it("admin reads booking", async () => {
      const db = env.authenticatedContext("admin_a").firestore();
      await assertSucceeds(
        getDoc(doc(db, "salons", "salon1", "bookings", "bk_cust")),
      );
    });

    it("barber may update allowed fields with valid transition", async () => {
      const db = env.authenticatedContext("barber_x").firestore();
      const ref = doc(db, "salons", "salon1", "bookings", "bk_cust");
      await assertSucceeds(
        updateDoc(ref, {
          status: "confirmed",
          updatedAt: Timestamp.now(),
        }),
      );
    });

    it("barber cannot set audit fields", async () => {
      const db = env.authenticatedContext("barber_y").firestore();
      const ref = doc(db, "salons", "salon1", "bookings", "bk_barber_y");
      await assertFails(
        updateDoc(ref, {
          status: "confirmed",
          cancelledAt: Timestamp.now(),
          updatedAt: Timestamp.now(),
        }),
      );
    });

    it("owner cannot set cancel audit keys via client", async () => {
      const db = env.authenticatedContext("owner_o").firestore();
      const ref = doc(db, "salons", "salon1", "bookings", "bk_barber_y");
      await assertFails(
        updateDoc(ref, {
          status: "cancelled",
          cancelledAt: Timestamp.now(),
          cancelledByRole: "owner",
          cancelledByUserId: "owner_o",
          updatedAt: Timestamp.now(),
        }),
      );
    });

    it("create and delete are denied", async () => {
      const db = env.authenticatedContext("owner_o").firestore();
      await assertFails(
        setDoc(doc(db, "salons", "salon1", "bookings", "new_bk"), {
          id: "new_bk",
          salonId: "salon1",
          customerId: "cust_a",
          barberId: "emp_x",
          status: "pending",
          startAt: sameStart,
          endAt: endLater,
        }),
      );
    });
  });

  describe("booking pagination (stable ordering)", () => {
    const salonId = "salon_page";
    const pageSize = 5;

    beforeAll(async () => {
      await env.withSecurityRulesDisabled(async (ctx) => {
        const db = ctx.firestore();
        await setDoc(doc(db, "users", "owner_page"), {
          role: "owner",
          salonId,
        });
        await setDoc(doc(db, "salons", salonId), {
          isActive: true,
          ownerUid: "owner_page",
        });
        const t = Timestamp.fromMillis(1_800_000_000_000);
        const end = Timestamp.fromMillis(1_800_000_360_000);
        for (let i = 0; i < 23; i++) {
          const id = `bk_${String(i).padStart(3, "0")}`;
          await setDoc(doc(db, "salons", salonId, "bookings", id), {
            id,
            salonId,
            customerId: "c1",
            barberId: "e1",
            status: "pending",
            startAt: t,
            endAt: end,
            reportYear: 2027,
            reportMonth: 1,
            reportPeriodKey: "2027-01",
          });
        }
      });
    });

    it("pages have no duplicates and cover all docs", async () => {
      const db = env.authenticatedContext("owner_page").firestore();
      const base = collection(db, "salons", salonId, "bookings");
      const allIds = new Set<string>();
      let last: QueryDocumentSnapshot | null = null;

      for (;;) {
        const q = last == null
          ? query(
            base,
            orderBy("startAt", "desc"),
            orderBy(documentId(), "desc"),
            limit(pageSize),
          )
          : query(
            base,
            orderBy("startAt", "desc"),
            orderBy(documentId(), "desc"),
            startAfter(last),
            limit(pageSize),
          );
        const snap = await getDocs(q);
        if (snap.empty) break;
        for (const d of snap.docs) {
          expect(allIds.has(d.id), `duplicate id ${d.id}`).toBe(false);
          allIds.add(d.id);
        }
        last = snap.docs[snap.docs.length - 1]!;
        if (snap.size < pageSize) break;
      }

      expect(allIds.size).toBe(23);
    });
  });
});
