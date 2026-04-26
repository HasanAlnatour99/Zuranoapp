import '../../employee_dashboard/domain/enums/attendance_punch_type.dart';
import '../data/models/et_attendance_day.dart';
import '../data/models/et_attendance_punch.dart';
import '../data/models/et_attendance_settings.dart';

class AttendanceDayCalculation {
  const AttendanceDayCalculation({
    required this.status,
    required this.workedMinutes,
    required this.breakMinutes,
    required this.lateMinutes,
    required this.earlyExitMinutes,
    required this.isLateAfterGrace,
    required this.isEarlyExitAfterGrace,
    required this.hasMissingPunch,
    required this.totalBreaks,
    this.firstPunchInAt,
    this.lastPunchOutAt,
  });

  final String status;
  final int workedMinutes;
  final int breakMinutes;
  final int lateMinutes;
  final int earlyExitMinutes;
  final bool isLateAfterGrace;
  final bool isEarlyExitAfterGrace;
  final bool hasMissingPunch;
  final int totalBreaks;
  final DateTime? firstPunchInAt;
  final DateTime? lastPunchOutAt;
}

class AttendanceMonthlyAnalysis {
  const AttendanceMonthlyAnalysis({
    required this.monthlyLateAfterGraceCount,
    required this.monthlyEarlyExitAfterGraceCount,
    required this.remainingLateAllowance,
    required this.remainingEarlyExitAllowance,
  });

  final int monthlyLateAfterGraceCount;
  final int monthlyEarlyExitAfterGraceCount;
  final int remainingLateAllowance;
  final int remainingEarlyExitAllowance;
}

/// OTL-style summaries from ordered punch records.
class AttendanceAnalysisService {
  const AttendanceAnalysisService();

  DateTime? _shiftOnDay(DateTime day, String? hhmm) {
    if (hhmm == null || !hhmm.contains(':')) {
      return null;
    }
    final parts = hhmm.split(':');
    final h = int.tryParse(parts[0]) ?? 0;
    final m = int.tryParse(parts[1]) ?? 0;
    return DateTime(day.year, day.month, day.day, h, m);
  }

  AttendanceDayCalculation calculateDay({
    required EtAttendanceSettings settings,
    required List<EtAttendancePunch> punchesSorted,
    required DateTime calendarDay,
  }) {
    if (punchesSorted.isEmpty) {
      return AttendanceDayCalculation(
        status: 'notStarted',
        workedMinutes: 0,
        breakMinutes: 0,
        lateMinutes: 0,
        earlyExitMinutes: 0,
        isLateAfterGrace: false,
        isEarlyExitAfterGrace: false,
        hasMissingPunch: false,
        totalBreaks: 0,
      );
    }

    var breakMs = 0;
    DateTime? breakOpen;
    var workMs = 0;
    DateTime? workOpen;
    DateTime? firstIn;
    DateTime? lastOut;

    for (final p in punchesSorted) {
      switch (p.type) {
        case AttendancePunchType.punchIn:
          firstIn ??= p.punchTime;
          workOpen = p.punchTime;
          breakOpen = null;
        case AttendancePunchType.breakOut:
          if (workOpen != null) {
            workMs += p.punchTime.difference(workOpen).inMilliseconds;
            workOpen = null;
          }
          breakOpen = p.punchTime;
        case AttendancePunchType.breakIn:
          if (breakOpen != null) {
            breakMs += p.punchTime.difference(breakOpen).inMilliseconds;
            breakOpen = null;
          }
          workOpen = p.punchTime;
        case AttendancePunchType.punchOut:
          if (workOpen != null) {
            workMs += p.punchTime.difference(workOpen).inMilliseconds;
            workOpen = null;
          }
          lastOut = p.punchTime;
      }
    }

    final hasOpenBreak = breakOpen != null;
    final hasOpenWork = workOpen != null;
    final missing =
        hasOpenBreak ||
        (firstIn != null && lastOut == null) ||
        _hasInvalidOrder(punchesSorted);

    var lateMin = 0;
    var isLateGrace = false;
    final shiftStart = _shiftOnDay(calendarDay, settings.standardShiftStart);
    if (shiftStart != null && firstIn != null) {
      if (firstIn.isAfter(shiftStart)) {
        lateMin = firstIn.difference(shiftStart).inMinutes;
        if (lateMin <= settings.graceLateMinutes) {
          lateMin = 0;
        } else {
          isLateGrace = true;
        }
      }
    }

    var earlyMin = 0;
    var isEarlyGrace = false;
    final shiftEnd = _shiftOnDay(calendarDay, settings.standardShiftEnd);
    if (shiftEnd != null && lastOut != null) {
      if (lastOut.isBefore(shiftEnd)) {
        earlyMin = shiftEnd.difference(lastOut).inMinutes;
        if (earlyMin <= settings.graceEarlyExitMinutes) {
          earlyMin = 0;
        } else {
          isEarlyGrace = true;
        }
      }
    }

    final last = punchesSorted.last.type;
    final String status;
    if (hasOpenBreak) {
      status = 'onBreak';
    } else if (last == AttendancePunchType.punchOut) {
      status = missing ? 'incomplete' : 'checkedOut';
    } else if (firstIn != null) {
      status = missing ? 'incomplete' : 'checkedIn';
    } else {
      status = 'notStarted';
    }

    final completedPairs = _countCompletedBreakPairs(punchesSorted);

    return AttendanceDayCalculation(
      status: status,
      workedMinutes: (workMs / 60000).round(),
      breakMinutes: (breakMs / 60000).round(),
      lateMinutes: lateMin,
      earlyExitMinutes: earlyMin,
      isLateAfterGrace: isLateGrace,
      isEarlyExitAfterGrace: isEarlyGrace,
      hasMissingPunch: missing || hasOpenWork,
      totalBreaks: completedPairs,
      firstPunchInAt: firstIn,
      lastPunchOutAt: lastOut,
    );
  }

  bool _hasInvalidOrder(List<EtAttendancePunch> sorted) {
    for (var i = 0; i < sorted.length; i++) {
      final t = sorted[i].type;
      if (i == 0 && t != AttendancePunchType.punchIn) {
        return true;
      }
    }
    return false;
  }

  int _countCompletedBreakPairs(List<EtAttendancePunch> sorted) {
    var n = 0;
    for (var i = 0; i < sorted.length - 1; i++) {
      if (sorted[i].type == AttendancePunchType.breakOut &&
          sorted[i + 1].type == AttendancePunchType.breakIn) {
        n++;
      }
    }
    return n;
  }

  AttendanceMonthlyAnalysis calculateMonthlyViolations({
    required EtAttendanceSettings settings,
    required List<EtAttendanceDay> monthDays,
  }) {
    var lateC = 0;
    var earlyC = 0;
    for (final d in monthDays) {
      if (d.isLateAfterGrace) {
        lateC++;
      }
      if (d.isEarlyExitAfterGrace) {
        earlyC++;
      }
    }
    final lateAllow = settings.monthlyLateAllowanceAfterGrace;
    final earlyAllow = settings.monthlyEarlyExitAllowanceAfterGrace;
    return AttendanceMonthlyAnalysis(
      monthlyLateAfterGraceCount: lateC,
      monthlyEarlyExitAfterGraceCount: earlyC,
      remainingLateAllowance: (lateAllow - lateC).clamp(0, 1 << 30),
      remainingEarlyExitAllowance: (earlyAllow - earlyC).clamp(0, 1 << 30),
    );
  }
}
