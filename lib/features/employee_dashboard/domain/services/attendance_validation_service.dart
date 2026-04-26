import '../attendance_day_states.dart';
import '../enums/attendance_punch_type.dart';
import '../../data/models/attendance_day_model.dart';

class AttendanceValidationService {
  void validatePunch({
    required AttendancePunchType type,
    required AttendanceDayModel? today,
    required bool attendanceRequired,
    required bool settingsEnabled,
    required bool zoneConfigured,
    required bool insideZone,
    required bool requireInsideZoneForPunchIn,
    required bool requireInsideZoneForPunchOut,
    required bool allowBreaks,
  }) {
    if (!settingsEnabled) {
      throw Exception('Attendance is disabled for this salon.');
    }
    if (!zoneConfigured) {
      throw Exception(
        'Attendance zone is not configured. Please contact your salon admin.',
      );
    }
    if (!attendanceRequired) {
      throw Exception('Attendance is not required for your account.');
    }

    final currentState =
        today?.currentState ?? AttendanceCurrentStates.notStarted;

    switch (type) {
      case AttendancePunchType.punchIn:
        if (requireInsideZoneForPunchIn && !insideZone) {
          throw Exception('You must be inside the salon zone to punch in.');
        }
        if (currentState == AttendanceCurrentStates.working ||
            currentState == AttendanceCurrentStates.onBreak) {
          throw Exception('You already punched in today.');
        }
        if (currentState == AttendanceCurrentStates.finished) {
          throw Exception('You already punched out today.');
        }
        break;
      case AttendancePunchType.breakOut:
        if (!allowBreaks) {
          throw Exception('Breaks are not enabled for this salon.');
        }
        if (currentState != AttendanceCurrentStates.working) {
          throw Exception('You can only break out after punch in.');
        }
        break;
      case AttendancePunchType.breakIn:
        if (currentState != AttendanceCurrentStates.onBreak) {
          throw Exception('You are not currently on break.');
        }
        break;
      case AttendancePunchType.punchOut:
        if (requireInsideZoneForPunchOut && !insideZone) {
          throw Exception('You must be inside the salon zone to punch out.');
        }
        if (currentState == AttendanceCurrentStates.notStarted) {
          throw Exception('You need to punch in first.');
        }
        if (currentState == AttendanceCurrentStates.onBreak) {
          throw Exception(
            'You are currently on break. Please break in before punch out.',
          );
        }
        if (currentState == AttendanceCurrentStates.finished) {
          throw Exception('You already punched out today.');
        }
        break;
    }
  }
}
