import '../../../core/constants/booking_statuses.dart';
import '../../bookings/data/models/booking.dart';

/// Owner dashboard booking KPIs derived from the salon bookings stream.
///
/// Definitions:
/// - **Completed today:** [BookingStatuses.completed] and local calendar day of
///   [Booking.endAt] is [now] (service-day semantics).
/// - **Cancelled today:** [BookingStatuses.cancelled] and [Booking.cancelledAt]
///   local day is [now].
/// - **Rescheduled today:** [BookingStatuses.rescheduled] and [Booking.updatedAt]
///   local day is [now] (superseded row moved that day).
/// - **Month scope:** [Booking.reportYear] / [Booking.reportMonth] match [now].
/// - **Rates (month):** among bookings in that month with terminal outcomes only
///   ([completed], [cancelled], [no_show]), completion rate = completed / denom,
///   cancellation rate = cancelled / denom.
/// - **Top barber (completions):** max count of completed bookings in month by
///   [Booking.barberId]; tie-break by [Booking.barberName] (lexicographic).
class OwnerBookingKpis {
  const OwnerBookingKpis({
    required this.completedToday,
    required this.cancelledToday,
    required this.rescheduledToday,
    required this.completionRateMonth,
    required this.cancellationRateMonth,
    required this.topBarberCompletionsName,
  });

  final int completedToday;
  final int cancelledToday;
  final int rescheduledToday;

  /// 0.0–1.0, or null if no terminal outcomes in month.
  final double? completionRateMonth;

  /// 0.0–1.0, or null if no terminal outcomes in month.
  final double? cancellationRateMonth;

  /// Display name for barber with most completed bookings this month, or null.
  final String? topBarberCompletionsName;

  static bool _sameLocalCalendarDay(DateTime a, DateTime b) {
    final la = a.toLocal();
    final lb = b.toLocal();
    return la.year == lb.year && la.month == lb.month && la.day == lb.day;
  }

  static OwnerBookingKpis compute(List<Booking> bookings, DateTime now) {
    var completedToday = 0;
    var cancelledToday = 0;
    var rescheduledToday = 0;

    final inMonth = bookings.where(
      (b) => b.reportYear == now.year && b.reportMonth == now.month,
    );

    for (final b in bookings) {
      if (b.status == BookingStatuses.completed &&
          _sameLocalCalendarDay(b.endAt, now)) {
        completedToday++;
      }
      if (b.status == BookingStatuses.cancelled) {
        final ca = b.cancelledAt;
        if (ca != null && _sameLocalCalendarDay(ca, now)) {
          cancelledToday++;
        }
      }
      if (b.status == BookingStatuses.rescheduled) {
        final ua = b.updatedAt;
        if (ua != null && _sameLocalCalendarDay(ua, now)) {
          rescheduledToday++;
        }
      }
    }

    var completedM = 0;
    var cancelledM = 0;
    var noShowM = 0;
    final completedByBarber = <String, ({int count, String name})>{};

    for (final b in inMonth) {
      switch (b.status) {
        case BookingStatuses.completed:
          completedM++;
          final prev = completedByBarber[b.barberId];
          final name = (b.barberName?.trim().isNotEmpty ?? false)
              ? b.barberName!.trim()
              : b.barberId;
          final c = (prev?.count ?? 0) + 1;
          completedByBarber[b.barberId] = (count: c, name: name);
        case BookingStatuses.cancelled:
          cancelledM++;
        case BookingStatuses.noShow:
          noShowM++;
        default:
          break;
      }
    }

    final denom = completedM + cancelledM + noShowM;
    final double? completionRateMonth = denom > 0 ? completedM / denom : null;
    final double? cancellationRateMonth = denom > 0 ? cancelledM / denom : null;

    String? topBarberCompletionsName;
    if (completedByBarber.isNotEmpty) {
      final best = completedByBarber.entries.reduce((a, b) {
        if (a.value.count != b.value.count) {
          return a.value.count >= b.value.count ? a : b;
        }
        return a.value.name.compareTo(b.value.name) <= 0 ? a : b;
      });
      topBarberCompletionsName = best.value.name;
    }

    return OwnerBookingKpis(
      completedToday: completedToday,
      cancelledToday: cancelledToday,
      rescheduledToday: rescheduledToday,
      completionRateMonth: completionRateMonth,
      cancellationRateMonth: cancellationRateMonth,
      topBarberCompletionsName: topBarberCompletionsName,
    );
  }
}
