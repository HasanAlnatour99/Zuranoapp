import { initializeApp } from "firebase-admin/app";

initializeApp();

export { bookingCancel, bookingCreate, bookingReschedule } from "./bookingCallables";
// Customer HTTPS callables + publicSalon mirrors live under `functions/src/customer/` and
// `publicTeamMirror.ts` / `publicServiceMirror.ts` — add those files before re-exporting here.
export {
  bookingCompleteService,
  bookingMarkArrived,
  bookingMarkNoShow,
  bookingStartService,
  violationReview,
} from "./bookingOperationsCallables";
export { bookingDayBusyMask } from "./bookingDayBusyMask";
export { refreshBarberMetricsHourly } from "./barberMetricsScheduled";
export { refreshWeeklyInsights } from "./weeklyInsightsScheduled";
export {
  registerDeviceToken,
  unregisterDeviceToken,
  updateNotificationPreferences,
} from "./notificationCallables";
export {
  onBookingUpdatedNotification,
  onPayrollCreatedNotification,
  onViolationCreatedNotification,
} from "./notificationFirestoreTriggers";
export { sendUpcomingBookingReminders } from "./notificationScheduler";
export { salonStaffCreateWithAuth } from "./staffProvisioningCallables";
export { resolveStaffLoginEmail } from "./staffLoginCallables";
export { generateAttendancePolicyReadable } from "./attendancePolicyCallable";
export {
  approvePayslip,
  generateMonthlyPayroll,
  generatePayslipSummary,
  markPayslipPaid,
} from "./payrollCallables";
