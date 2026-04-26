import '../../employee_dashboard/domain/enums/attendance_punch_type.dart';
import '../data/models/et_attendance_settings.dart';

class AttendanceValidationResult {
  const AttendanceValidationResult({
    required this.allowed,
    this.message,
    this.expectedNextAction,
  });

  final bool allowed;
  final String? message;
  final AttendancePunchType? expectedNextAction;
}

/// Client-side punch validation (mirror server-side rules in production).
class AttendanceRuleEngine {
  const AttendanceRuleEngine();

  int _breakOutCount(List<String> seq) =>
      seq.where((e) => e == AttendancePunchType.breakOut.name).length;

  AttendanceValidationResult validateNextPunch({
    required EtAttendanceSettings settings,
    required List<String> punchSequence,
    required AttendancePunchType requestedType,
    required bool isInsideZone,
    required bool attendanceRequired,
  }) {
    if (!settings.attendanceEnabled) {
      return const AttendanceValidationResult(
        allowed: false,
        message: 'Attendance is not enabled for this salon.',
      );
    }

    final effectiveInside = !attendanceRequired || !settings.gpsRequired
        ? true
        : isInsideZone;
    if (!effectiveInside) {
      return const AttendanceValidationResult(
        allowed: false,
        message: 'You are outside the allowed salon zone.',
      );
    }

    if (attendanceRequired &&
        settings.gpsRequired &&
        !settings.hasSalonLocationConfigured) {
      return const AttendanceValidationResult(
        allowed: false,
        message:
            'Salon attendance location is not configured. Please contact the owner.',
      );
    }

    if (punchSequence.length >= settings.maxPunchesPerDay) {
      return const AttendanceValidationResult(
        allowed: false,
        message: 'You already completed your attendance for today.',
      );
    }

    if (requestedType == AttendancePunchType.breakOut &&
        _breakOutCount(punchSequence) >= settings.maxBreakCyclesPerDay) {
      return const AttendanceValidationResult(
        allowed: false,
        message:
            'You already reached the maximum number of breaks allowed today.',
      );
    }

    if (punchSequence.isEmpty) {
      if (requestedType != AttendancePunchType.punchIn) {
        return const AttendanceValidationResult(
          allowed: false,
          message: 'You must punch in before starting a break.',
          expectedNextAction: AttendancePunchType.punchIn,
        );
      }
      return const AttendanceValidationResult(allowed: true);
    }

    if (punchSequence.last == AttendancePunchType.punchOut.name) {
      return const AttendanceValidationResult(
        allowed: false,
        message: 'You already completed your attendance for today.',
      );
    }

    if (punchSequence.last == AttendancePunchType.breakOut.name) {
      if (requestedType != AttendancePunchType.breakIn) {
        return const AttendanceValidationResult(
          allowed: false,
          message: 'You are already on break. Please break in first.',
          expectedNextAction: AttendancePunchType.breakIn,
        );
      }
      return const AttendanceValidationResult(allowed: true);
    }

    if (requestedType == AttendancePunchType.punchIn) {
      return const AttendanceValidationResult(
        allowed: false,
        message: 'This punch sequence is not valid.',
      );
    }

    if (requestedType == AttendancePunchType.breakOut) {
      if (!punchSequence.contains(AttendancePunchType.punchIn.name)) {
        return const AttendanceValidationResult(
          allowed: false,
          message: 'You must punch in before starting a break.',
        );
      }
      return const AttendanceValidationResult(allowed: true);
    }

    if (requestedType == AttendancePunchType.breakIn) {
      return const AttendanceValidationResult(
        allowed: false,
        message: 'This punch sequence is not valid.',
      );
    }

    if (requestedType == AttendancePunchType.punchOut) {
      if (punchSequence.last == AttendancePunchType.breakOut.name) {
        return const AttendanceValidationResult(
          allowed: false,
          message: 'You are already on break. Please break in first.',
        );
      }
      if (!punchSequence.contains(AttendancePunchType.punchIn.name)) {
        return const AttendanceValidationResult(
          allowed: false,
          message: 'This punch sequence is not valid.',
        );
      }
      return const AttendanceValidationResult(allowed: true);
    }

    return const AttendanceValidationResult(allowed: true);
  }

  /// Validates inserting [requestedType] into [punchSequence] (e.g. correction).
  AttendanceValidationResult validateSequenceAfterInsert({
    required EtAttendanceSettings settings,
    required List<String> punchSequence,
    required AttendancePunchType requestedType,
  }) {
    final mergedTypes = List<String>.from(punchSequence)
      ..add(requestedType.name);
    if (mergedTypes.length > settings.maxPunchesPerDay) {
      return const AttendanceValidationResult(
        allowed: false,
        message: 'This punch would exceed the daily punch limit.',
      );
    }
    if (requestedType == AttendancePunchType.breakOut &&
        _breakOutCount(mergedTypes) > settings.maxBreakCyclesPerDay) {
      return const AttendanceValidationResult(
        allowed: false,
        message: 'This break would exceed the daily break limit.',
      );
    }
    return validateNextPunch(
      settings: settings,
      punchSequence: punchSequence,
      requestedType: requestedType,
      isInsideZone: true,
      attendanceRequired: false,
    );
  }
}
