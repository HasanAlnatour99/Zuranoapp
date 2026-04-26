import type { NotificationEventType, NotificationPrefs } from "./notificationTypes";

export const defaultNotificationPrefs = (): NotificationPrefs => ({
  pushEnabled: true,
  bookingReminders: true,
  bookingChanges: true,
  payrollAlerts: true,
  violationAlerts: true,
  marketingEnabled: false,
});

export function mergeNotificationPrefs(raw: unknown): NotificationPrefs {
  const d = defaultNotificationPrefs();
  if (!raw || typeof raw !== "object") {
    return d;
  }
  const m = raw as Record<string, unknown>;
  return {
    pushEnabled: typeof m.pushEnabled === "boolean" ? m.pushEnabled : d.pushEnabled,
    bookingReminders: typeof m.bookingReminders === "boolean"
      ? m.bookingReminders
      : d.bookingReminders,
    bookingChanges: typeof m.bookingChanges === "boolean"
      ? m.bookingChanges
      : d.bookingChanges,
    payrollAlerts: typeof m.payrollAlerts === "boolean"
      ? m.payrollAlerts
      : d.payrollAlerts,
    violationAlerts: typeof m.violationAlerts === "boolean"
      ? m.violationAlerts
      : d.violationAlerts,
    marketingEnabled: typeof m.marketingEnabled === "boolean"
      ? m.marketingEnabled
      : d.marketingEnabled,
  };
}

/** Category gates (ignores pushEnabled — use for in-app and as part of push check). */
export function allowsCategoryForEvent(
  prefs: NotificationPrefs,
  eventType: NotificationEventType,
): boolean {
  switch (eventType) {
    case "booking_reminder":
      return prefs.bookingReminders;
    case "booking_cancelled":
    case "booking_rescheduled":
    case "booking_confirmed":
    case "new_booking_assigned":
    case "booking_completed":
      return prefs.bookingChanges;
    case "violation_created":
    case "no_show_recorded":
      return prefs.violationAlerts;
    case "payroll_generated":
    case "payroll_ready":
      return prefs.payrollAlerts;
    default:
      return true;
  }
}

export function allowsPushForEvent(
  prefs: NotificationPrefs,
  eventType: NotificationEventType,
): boolean {
  return prefs.pushEnabled && allowsCategoryForEvent(prefs, eventType);
}
