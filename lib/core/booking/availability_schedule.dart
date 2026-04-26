import 'package:flutter/foundation.dart';

import '../../features/bookings/data/models/booking.dart';
import '../../features/employees/data/models/employee.dart';
import '../../features/salon/data/models/salon.dart';
import '../constants/booking_statuses.dart';
import 'booking_slots.dart';

/// Default grid step for customer booking (must stay compatible with [BookingSlots]).
const int kCustomerSlotStepMinutes = 30;

/// One weekday configuration (local minutes from midnight for the booking day).
@immutable
class DaySchedule {
  const DaySchedule({
    required this.isDayOff,
    required this.openMinute,
    required this.closeMinute,
    required this.breaks,
  });

  final bool isDayOff;
  final int openMinute;
  final int closeMinute;

  /// Each break: [startMinute, endMinute) in local minutes from midnight.
  final List<(int, int)> breaks;

  static DaySchedule defaultWindow() => const DaySchedule(
    isDayOff: false,
    openMinute: 9 * 60,
    closeMinute: 18 * 60,
    breaks: [],
  );

  static DaySchedule? tryParse(Object? raw) {
    if (raw is! Map) {
      return null;
    }
    final m = Map<String, dynamic>.from(raw);
    final closed =
        m['closed'] == true || m['isDayOff'] == true || m['off'] == true;
    if (closed) {
      return const DaySchedule(
        isDayOff: true,
        openMinute: 0,
        closeMinute: 0,
        breaks: [],
      );
    }
    final open = _intVal(m['openMinute'] ?? m['o'] ?? m['open']);
    final close = _intVal(m['closeMinute'] ?? m['c'] ?? m['close']);
    if (open == null || close == null || close <= open) {
      return null;
    }
    final breaksRaw = m['breaks'] ?? m['b'];
    final breaks = <(int, int)>[];
    if (breaksRaw is List) {
      for (final item in breaksRaw) {
        if (item is Map) {
          final sm = _intVal(item['start'] ?? item['s'] ?? item['startMinute']);
          final em = _intVal(item['end'] ?? item['e'] ?? item['endMinute']);
          if (sm != null && em != null && em > sm) {
            breaks.add((sm, em));
          }
        }
      }
    }
    return DaySchedule(
      isDayOff: false,
      openMinute: open,
      closeMinute: close,
      breaks: breaks,
    );
  }

  static int? _intVal(Object? v) {
    if (v is int) {
      return v;
    }
    if (v is double) {
      return v.round();
    }
    return int.tryParse(v?.toString() ?? '');
  }
}

/// Map DateTime.weekday (Mon=1 … Sun=7) → schedule.
@immutable
class WeeklyAvailability {
  const WeeklyAvailability(this.byWeekday);

  final Map<int, DaySchedule> byWeekday;

  static WeeklyAvailability? maybeParse(Object? raw) {
    if (raw == null) {
      return null;
    }
    if (raw is! Map) {
      return null;
    }
    final out = <int, DaySchedule>{};
    for (final e in raw.entries) {
      final key = int.tryParse(e.key.toString());
      if (key == null || key < 1 || key > 7) {
        continue;
      }
      final ds = DaySchedule.tryParse(e.value);
      if (ds != null) {
        out[key] = ds;
      }
    }
    if (out.isEmpty) {
      return null;
    }
    return WeeklyAvailability(out);
  }

  DaySchedule? dayIfSet(int weekday) => byWeekday[weekday];
}

bool _sameLocalCalendarDayForSlots(DateTime a, DateTime b) {
  final la = a.toLocal();
  final lb = b.toLocal();
  return la.year == lb.year && la.month == lb.month && la.day == lb.day;
}

DaySchedule effectiveDaySchedule({
  required Salon salon,
  required Employee? barber,
  required int weekday,
}) {
  final barberDay = barber?.weeklyAvailability?.dayIfSet(weekday);
  if (barberDay != null) {
    return barberDay;
  }
  final salonDay = salon.weeklyAvailability?.dayIfSet(weekday);
  if (salonDay != null) {
    return salonDay;
  }
  return DaySchedule.defaultWindow();
}

/// UTC-aligned slot generation; respects [BookingSlots] grid.
abstract final class CustomerSlotPlanner {
  static DateTime _alignUtcUp(DateTime utc, int step) {
    final midnight = DateTime.utc(utc.year, utc.month, utc.day);
    var minutes = utc.difference(midnight).inMinutes;
    final rem = minutes % step;
    if (rem != 0) {
      minutes += step - rem;
    }
    return midnight.add(Duration(minutes: minutes));
  }

  static List<(int, int)> _subtractBreaks(
    int open,
    int close,
    List<(int, int)> breaks,
  ) {
    var intervals = <(int, int)>[(open, close)];
    for (final br in breaks) {
      final bs = br.$1.clamp(open, close);
      final be = br.$2.clamp(open, close);
      if (be <= bs) {
        continue;
      }
      final next = <(int, int)>[];
      for (final iv in intervals) {
        final a = iv.$1;
        final b = iv.$2;
        if (be <= a || bs >= b) {
          next.add(iv);
          continue;
        }
        if (bs > a) {
          next.add((a, bs));
        }
        if (be < b) {
          next.add((be, b));
        }
      }
      intervals = next;
    }
    return intervals.where((i) => i.$2 > i.$1).toList();
  }

  static bool _blocksBooking(Booking b) {
    return b.status != BookingStatuses.cancelled;
  }

  static List<DateTime> candidateStartsUtc({
    required DateTime selectedLocalDay,
    required int serviceDurationMinutes,
    required List<Booking> existingBookings,
    required String barberId,
    required Salon salon,
    Employee? barber,
    int slotStepMinutes = 30,
  }) {
    BookingSlots.assertAllowedStep(slotStepMinutes);
    final weekday = selectedLocalDay.weekday;
    final schedule = effectiveDaySchedule(
      salon: salon,
      barber: barber,
      weekday: weekday,
    );
    if (schedule.isDayOff) {
      return [];
    }
    final dayStart = DateTime(
      selectedLocalDay.year,
      selectedLocalDay.month,
      selectedLocalDay.day,
    );
    final segments = _subtractBreaks(
      schedule.openMinute,
      schedule.closeMinute,
      schedule.breaks,
    );

    final busy = existingBookings
        .where((b) => b.barberId == barberId && _blocksBooking(b))
        .toList(growable: false);

    final out = <DateTime>[];
    for (final seg in segments) {
      for (
        var m = seg.$1;
        m + serviceDurationMinutes <= seg.$2;
        m += slotStepMinutes
      ) {
        final localStart = dayStart.add(Duration(minutes: m));
        final utcSlot = _alignUtcUp(localStart.toUtc(), slotStepMinutes);
        final loc = utcSlot.toLocal();
        if (loc.year != selectedLocalDay.year ||
            loc.month != selectedLocalDay.month ||
            loc.day != selectedLocalDay.day) {
          continue;
        }
        final minFromMidnight = loc.difference(dayStart).inMinutes;
        if (minFromMidnight < seg.$1 ||
            minFromMidnight + serviceDurationMinutes > seg.$2) {
          continue;
        }
        if (_sameLocalCalendarDayForSlots(selectedLocalDay, DateTime.now()) &&
            loc.isBefore(DateTime.now())) {
          continue;
        }
        final end = utcSlot.add(Duration(minutes: serviceDurationMinutes));
        var blocked = false;
        for (final b in busy) {
          if (utcSlot.isBefore(b.endAt) && end.isAfter(b.startAt)) {
            blocked = true;
            break;
          }
        }
        if (!blocked) {
          try {
            BookingSlots.assertUtcSlotRange(utcSlot, end, slotStepMinutes);
            out.add(utcSlot);
          } on Object {
            // Skip invalid grid.
          }
        }
      }
    }
    return out;
  }
}
