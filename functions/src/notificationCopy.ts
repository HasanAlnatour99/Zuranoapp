import type { NotificationEventType } from "./notificationTypes";

export type SupportedLocale = "en" | "ar";

const COPY: Record<
  NotificationEventType,
  Record<SupportedLocale, { title: string; body: string }>
> = {
  booking_confirmed: {
    en: {
      title: "Booking confirmed",
      body: "Your appointment is confirmed. See details in the app.",
    },
    ar: {
      title: "تم تأكيد الحجز",
      body: "تم تأكيد موعدك. التفاصيل في التطبيق.",
    },
  },
  booking_reminder: {
    en: {
      title: "Upcoming appointment",
      body: "You have an appointment in about an hour.",
    },
    ar: {
      title: "موعد قريب",
      body: "لديك موعد خلال حوالي ساعة.",
    },
  },
  booking_cancelled: {
    en: {
      title: "Booking cancelled",
      body: "An appointment was cancelled.",
    },
    ar: {
      title: "تم إلغاء الحجز",
      body: "تم إلغاء أحد المواعيد.",
    },
  },
  booking_rescheduled: {
    en: {
      title: "Booking rescheduled",
      body: "An appointment was moved to a new time.",
    },
    ar: {
      title: "تم إعادة جدولة الحجز",
      body: "تم نقل أحد المواعيد إلى وقت جديد.",
    },
  },
  booking_completed: {
    en: {
      title: "Thanks for visiting",
      body: "Your appointment is complete. We hope to see you again.",
    },
    ar: {
      title: "شكرًا لزيارتك",
      body: "اكتمل موعدك. نأمل رؤيتك مجددًا.",
    },
  },
  new_booking_assigned: {
    en: {
      title: "New booking",
      body: "You have a new appointment on the schedule.",
    },
    ar: {
      title: "حجز جديد",
      body: "لديك موعد جديد في الجدول.",
    },
  },
  violation_created: {
    en: {
      title: "Policy notice",
      body: "A violation record was created for your salon.",
    },
    ar: {
      title: "إشعار سياسة",
      body: "تم إنشاء سجل مخالفة لصالونك.",
    },
  },
  no_show_recorded: {
    en: {
      title: "No-show recorded",
      body: "A no-show was recorded for a booking.",
    },
    ar: {
      title: "تسجيل عدم حضور",
      body: "تم تسجيل عدم حضور لأحد الحجوزات.",
    },
  },
  payroll_generated: {
    en: {
      title: "Payroll run",
      body: "A new payroll record was generated.",
    },
    ar: {
      title: "تشغيل الرواتب",
      body: "تم إنشاء سجل رواتب جديد.",
    },
  },
  payroll_ready: {
    en: {
      title: "Payroll ready",
      body: "Your payslip for this period is available.",
    },
    ar: {
      title: "الراتب جاهز",
      body: "قسيمة راتبك لهذه الفترة متاحة.",
    },
  },
};

function replacePlaceholders(
  template: string,
  vars: Record<string, string>,
): string {
  let s = template;
  for (const [k, v] of Object.entries(vars)) {
    s = s.split(`{${k}}`).join(v);
  }
  return s;
}

export function getLocalizedCopy(
  eventType: NotificationEventType,
  locale: SupportedLocale,
  vars: Record<string, string> = {},
): { title: string; body: string } {
  const row = COPY[eventType][locale] ?? COPY[eventType].en;
  return {
    title: replacePlaceholders(row.title, vars),
    body: replacePlaceholders(row.body, vars),
  };
}

export function normalizeLocale(raw: string | undefined): SupportedLocale {
  if (typeof raw === "string" && raw.toLowerCase().startsWith("ar")) {
    return "ar";
  }
  return "en";
}
