import '../../employee_today/data/models/et_attendance_day.dart';
import '../../employee_today/data/repositories/employee_today_attendance_repository.dart';

/// Client-side summary for the overview card (no separate Firestore doc required).
class EmployeeMonthlyAttendanceStats {
  const EmployeeMonthlyAttendanceStats({
    required this.presentDays,
    required this.absentDays,
    required this.lateDays,
    required this.totalDaysTracked,
  });

  final int presentDays;
  final int absentDays;
  final int lateDays;

  /// Calendar days elapsed in month through today (cap at month end).
  final int totalDaysTracked;

  /// Days with no record or no check-in through today in the month.
  static EmployeeMonthlyAttendanceStats compute({
    required List<EtAttendanceDay> daysInMonth,
    required DateTime now,
  }) {
    final y = now.year;
    final m = now.month;
    final today = DateTime(now.year, now.month, now.day);
    final monthEnd = DateTime(y, m + 1, 0).day;
    final lastDayToScore = today.day > monthEnd ? monthEnd : today.day;

    final byKey = {for (final d in daysInMonth) d.dateKey: d};

    var present = 0;
    var absent = 0;
    var late = 0;

    for (var day = 1; day <= lastDayToScore; day++) {
      final date = DateTime(y, m, day);
      final key = EmployeeTodayAttendanceRepository.compactDateKey(date);
      final row = byKey[key];
      if (row == null) {
        absent++;
        continue;
      }
      if (row.firstPunchInAt != null) {
        present++;
        if (row.isLateAfterGrace) {
          late++;
        }
      } else {
        absent++;
      }
    }

    return EmployeeMonthlyAttendanceStats(
      presentDays: present,
      absentDays: absent,
      lateDays: late,
      totalDaysTracked: lastDayToScore,
    );
  }
}
