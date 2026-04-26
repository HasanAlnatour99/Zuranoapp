import { getFirestore } from "firebase-admin/firestore";

import {
  bookingDeepLinkData,
  deliverTemplatedNotification,
  payrollDeepLinkData,
  violationDeepLinkData,
} from "./notificationDispatch";
import { getEmployeeAuthUid, listOwnerAdminUserIds } from "./notificationSalonUsers";

const db = getFirestore();

export async function notifyNewBookingAssigned(params: {
  salonId: string;
  bookingId: string;
  barberId: string;
}): Promise<void> {
  const uid = await getEmployeeAuthUid(params.salonId, params.barberId);
  if (!uid) {
    return;
  }
  await deliverTemplatedNotification({
    userId: uid,
    eventType: "new_booking_assigned",
    dedupeKey: `new_booking_assigned:${params.bookingId}:${uid}`,
    data: bookingDeepLinkData(params.salonId, params.bookingId),
    actorRole: "system",
    salonId: params.salonId,
    bookingId: params.bookingId,
    employeeId: params.barberId,
  });
}

export async function notifyBookingCancelled(params: {
  salonId: string;
  bookingId: string;
  customerId: string;
  barberId: string;
}): Promise<void> {
  const barberUid = await getEmployeeAuthUid(params.salonId, params.barberId);
  const targets = new Set<string>([params.customerId]);
  if (barberUid) {
    targets.add(barberUid);
  }
  for (const userId of targets) {
    await deliverTemplatedNotification({
      userId,
      eventType: "booking_cancelled",
      dedupeKey: `booking_cancelled:${params.bookingId}:${userId}`,
      data: bookingDeepLinkData(params.salonId, params.bookingId),
      actorRole: "system",
      salonId: params.salonId,
      bookingId: params.bookingId,
      employeeId: params.barberId,
    });
  }
}

export async function notifyBookingRescheduled(params: {
  salonId: string;
  oldBookingId: string;
  newBookingId: string;
  customerId: string;
  barberId: string;
}): Promise<void> {
  const barberUid = await getEmployeeAuthUid(params.salonId, params.barberId);
  const targets = new Set<string>([params.customerId]);
  if (barberUid) {
    targets.add(barberUid);
  }
  for (const userId of targets) {
    await deliverTemplatedNotification({
      userId,
      eventType: "booking_rescheduled",
      dedupeKey:
        `booking_rescheduled:${params.oldBookingId}:${params.newBookingId}:${userId}`,
      data: bookingDeepLinkData(params.salonId, params.newBookingId),
      actorRole: "system",
      salonId: params.salonId,
      bookingId: params.newBookingId,
      employeeId: params.barberId,
    });
  }
}

export async function notifyBookingCompletedForCustomer(params: {
  salonId: string;
  bookingId: string;
  customerId: string;
}): Promise<void> {
  await deliverTemplatedNotification({
    userId: params.customerId,
    eventType: "booking_completed",
    dedupeKey: `booking_completed:${params.bookingId}:${params.customerId}`,
    data: bookingDeepLinkData(params.salonId, params.bookingId),
    actorRole: "system",
    salonId: params.salonId,
    bookingId: params.bookingId,
  });
}

export async function notifyNoShowToOwners(params: {
  salonId: string;
  bookingId: string;
}): Promise<void> {
  const ids = await listOwnerAdminUserIds(params.salonId);
  for (const userId of ids) {
    await deliverTemplatedNotification({
      userId,
      eventType: "no_show_recorded",
      dedupeKey: `no_show_recorded:${params.bookingId}:${userId}`,
      data: bookingDeepLinkData(params.salonId, params.bookingId),
      actorRole: "system",
      salonId: params.salonId,
      bookingId: params.bookingId,
    });
  }
}

export async function notifyBookingConfirmedForCustomer(params: {
  salonId: string;
  bookingId: string;
  customerId: string;
}): Promise<void> {
  await deliverTemplatedNotification({
    userId: params.customerId,
    eventType: "booking_confirmed",
    dedupeKey: `booking_confirmed:${params.bookingId}:${params.customerId}`,
    data: bookingDeepLinkData(params.salonId, params.bookingId),
    actorRole: "system",
    salonId: params.salonId,
    bookingId: params.bookingId,
  });
}

export async function notifyViolationCreated(params: {
  salonId: string;
  violationId: string;
  employeeId: string;
  bookingId: string;
}): Promise<void> {
  const barberUid = await getEmployeeAuthUid(params.salonId, params.employeeId);
  if (barberUid) {
    await deliverTemplatedNotification({
      userId: barberUid,
      eventType: "violation_created",
      dedupeKey: `violation_created:${params.violationId}:${barberUid}`,
      data: violationDeepLinkData(params.salonId, params.violationId),
      actorRole: "system",
      salonId: params.salonId,
      bookingId: params.bookingId,
      employeeId: params.employeeId,
      violationId: params.violationId,
    });
  }
  const staff = await listOwnerAdminUserIds(params.salonId);
  for (const userId of staff) {
    if (barberUid && userId === barberUid) {
      continue;
    }
    await deliverTemplatedNotification({
      userId,
      eventType: "violation_created",
      dedupeKey: `violation_created:${params.violationId}:${userId}:admin`,
      data: violationDeepLinkData(params.salonId, params.violationId),
      actorRole: "system",
      salonId: params.salonId,
      bookingId: params.bookingId,
      employeeId: params.employeeId,
      violationId: params.violationId,
    });
  }
}

export async function notifyPayrollCreated(params: {
  salonId: string;
  payrollId: string;
  employeeId: string;
}): Promise<void> {
  const barberUid = await getEmployeeAuthUid(params.salonId, params.employeeId);
  if (barberUid) {
    await deliverTemplatedNotification({
      userId: barberUid,
      eventType: "payroll_ready",
      dedupeKey: `payroll_ready:${params.payrollId}:${barberUid}`,
      data: payrollDeepLinkData(params.salonId, params.payrollId),
      actorRole: "system",
      salonId: params.salonId,
      payrollId: params.payrollId,
      employeeId: params.employeeId,
    });
  }
  const staff = await listOwnerAdminUserIds(params.salonId);
  for (const userId of staff) {
    await deliverTemplatedNotification({
      userId,
      eventType: "payroll_generated",
      dedupeKey: `payroll_generated:${params.payrollId}:${userId}`,
      data: payrollDeepLinkData(params.salonId, params.payrollId),
      actorRole: "system",
      salonId: params.salonId,
      payrollId: params.payrollId,
      employeeId: params.employeeId,
    });
  }
}

export async function loadBookingParticipants(
  salonId: string,
  bookingId: string,
): Promise<{ customerId: string; barberId: string } | null> {
  const snap = await db
    .collection("salons")
    .doc(salonId)
    .collection("bookings")
    .doc(bookingId)
    .get();
  if (!snap.exists) {
    return null;
  }
  const customerId = snap.get("customerId");
  const barberId = snap.get("barberId");
  if (typeof customerId !== "string" || typeof barberId !== "string") {
    return null;
  }
  return { customerId, barberId };
}
