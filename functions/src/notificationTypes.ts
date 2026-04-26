/** Aligns with Flutter / Firestore `users/{uid}/notifications` and FCM data payloads. */
export type NotificationEventType =
  | "booking_confirmed"
  | "booking_reminder"
  | "booking_cancelled"
  | "booking_rescheduled"
  | "booking_completed"
  | "new_booking_assigned"
  | "violation_created"
  | "no_show_recorded"
  | "payroll_generated"
  | "payroll_ready";

export type NotificationChannel = "push" | "in_app";

export type ActorRole =
  | "customer"
  | "barber"
  | "owner"
  | "admin"
  | "system";

export type NotificationPrefs = {
  pushEnabled: boolean;
  bookingReminders: boolean;
  bookingChanges: boolean;
  payrollAlerts: boolean;
  violationAlerts: boolean;
  marketingEnabled: boolean;
};

export type SendNotificationInput = {
  userId: string;
  eventType: NotificationEventType;
  dedupeKey: string;
  title: string;
  body: string;
  data: Record<string, string>;
  actorRole: ActorRole;
  salonId?: string;
  bookingId?: string;
  employeeId?: string;
  payrollId?: string;
  violationId?: string;
};
