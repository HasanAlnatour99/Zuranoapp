import { onDocumentCreated, onDocumentUpdated } from "firebase-functions/v2/firestore";

import { BookingStatuses, normalizeBookingStatus } from "./bookingShared";
import {
  notifyBookingConfirmedForCustomer,
  notifyPayrollCreated,
  notifyViolationCreated,
} from "./notificationOrchestrator";

export const onBookingUpdatedNotification = onDocumentUpdated(
  {
    document: "salons/{salonId}/bookings/{bookingId}",
    region: "us-central1",
  },
  async (event) => {
    const before = event.data?.before.data();
    const after = event.data?.after.data();
    if (!after) {
      return;
    }
    const salonId = event.params.salonId;
    const bookingId = event.params.bookingId;
    const stBefore = normalizeBookingStatus(
      (before?.status as string | undefined) ?? "",
    );
    const stAfter = normalizeBookingStatus(
      (after.status as string | undefined) ?? "",
    );
    if (
      stBefore === BookingStatuses.pending &&
      stAfter === BookingStatuses.confirmed
    ) {
      const customerId = after.customerId;
      if (typeof customerId === "string" && customerId.length > 0) {
        await notifyBookingConfirmedForCustomer({
          salonId,
          bookingId,
          customerId,
        });
      }
    }
  },
);

export const onViolationCreatedNotification = onDocumentCreated(
  {
    document: "salons/{salonId}/violations/{violationId}",
    region: "us-central1",
  },
  async (event) => {
    const snap = event.data;
    if (!snap) {
      return;
    }
    const d = snap.data();
    const salonId = event.params.salonId;
    const violationId = event.params.violationId;
    const employeeId = typeof d.employeeId === "string" ? d.employeeId : "";
    const bookingId = typeof d.bookingId === "string" ? d.bookingId : "";
    if (!employeeId || !bookingId) {
      return;
    }
    await notifyViolationCreated({
      salonId,
      violationId,
      employeeId,
      bookingId,
    });
  },
);

export const onPayrollCreatedNotification = onDocumentCreated(
  {
    document: "salons/{salonId}/payroll/{payrollId}",
    region: "us-central1",
  },
  async (event) => {
    const snap = event.data;
    if (!snap) {
      return;
    }
    const d = snap.data();
    const salonId = event.params.salonId;
    const payrollId = event.params.payrollId;
    const employeeId = typeof d.employeeId === "string" ? d.employeeId : "";
    if (!employeeId) {
      return;
    }
    await notifyPayrollCreated({
      salonId,
      payrollId,
      employeeId,
    });
  },
);
