import '../../../core/constants/booking_statuses.dart';
import '../../../core/constants/violation_types.dart';
import '../../bookings/data/models/booking.dart';
import '../../violations/data/models/violation.dart';

/// No-show and penalty KPIs for the owner overview.
class OwnerReliabilityKpis {
  const OwnerReliabilityKpis({
    required this.noShowCountToday,
    required this.noShowRateMonth,
    required this.penaltyAmountMonth,
    required this.topPenalizedBarberName,
  });

  final int noShowCountToday;

  /// 0.0–1.0 among terminal outcomes in month, or null if none.
  final double? noShowRateMonth;
  final double penaltyAmountMonth;
  final String? topPenalizedBarberName;

  static bool _sameLocalCalendarDay(DateTime a, DateTime b) {
    final la = a.toLocal();
    final lb = b.toLocal();
    return la.year == lb.year && la.month == lb.month && la.day == lb.day;
  }

  static OwnerReliabilityKpis compute(
    List<Booking> bookings,
    List<Violation> violations,
    DateTime now,
  ) {
    var noShowToday = 0;
    final inMonthBookings = bookings.where(
      (b) => b.reportYear == now.year && b.reportMonth == now.month,
    );

    for (final b in bookings) {
      if (b.status != BookingStatuses.noShow) {
        continue;
      }
      final marked = b.noShowMarkedAt;
      if (marked != null && _sameLocalCalendarDay(marked, now)) {
        noShowToday++;
      } else if (marked == null &&
          _sameLocalCalendarDay(b.startAt, now) &&
          b.status == BookingStatuses.noShow) {
        noShowToday++;
      }
    }

    var completedM = 0;
    var cancelledM = 0;
    var noShowM = 0;
    for (final b in inMonthBookings) {
      switch (b.status) {
        case BookingStatuses.completed:
          completedM++;
        case BookingStatuses.cancelled:
          cancelledM++;
        case BookingStatuses.noShow:
          noShowM++;
        default:
          break;
      }
    }
    final denom = completedM + cancelledM + noShowM;
    final double? noShowRateMonth = denom > 0 ? noShowM / denom : null;

    final inMonthViolations = violations.where(
      (v) => v.reportYear == now.year && v.reportMonth == now.month,
    );
    var penaltyMonth = 0.0;
    final byBarber = <String, ({double sum, String name})>{};
    for (final v in inMonthViolations) {
      if (v.status != ViolationStatuses.approved &&
          v.status != ViolationStatuses.applied) {
        continue;
      }
      penaltyMonth += v.amount;
      final name = (v.employeeName?.trim().isNotEmpty ?? false)
          ? v.employeeName!.trim()
          : v.employeeId;
      final prev = byBarber[v.employeeId];
      final sum = (prev?.sum ?? 0) + v.amount;
      byBarber[v.employeeId] = (sum: sum, name: name);
    }
    penaltyMonth = double.parse(penaltyMonth.toStringAsFixed(2));

    String? topPenalized;
    if (byBarber.isNotEmpty) {
      final best = byBarber.entries.reduce((a, b) {
        if (a.value.sum != b.value.sum) {
          return a.value.sum >= b.value.sum ? a : b;
        }
        return a.value.name.compareTo(b.value.name) <= 0 ? a : b;
      });
      if (best.value.sum > 0) {
        topPenalized = best.value.name;
      }
    }

    return OwnerReliabilityKpis(
      noShowCountToday: noShowToday,
      noShowRateMonth: noShowRateMonth,
      penaltyAmountMonth: penaltyMonth,
      topPenalizedBarberName: topPenalized,
    );
  }
}
