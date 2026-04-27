import '../../employees/data/models/employee.dart';
import '../../owner/settings/attendance/domain/models/attendance_settings_model.dart';
import '../data/models/et_attendance_day.dart';
import '../data/models/et_attendance_punch.dart';
import '../data/models/employee_workplace_location_snapshot.dart';

bool _completedForDay(EtAttendanceDay? day) {
  if (day == null) {
    return false;
  }
  if (day.status == 'checkedOut') {
    return true;
  }
  final seq = day.punchSequence;
  return seq.isNotEmpty && seq.last == 'punchOut';
}

/// Outside-zone chip: blocked now, or recorded issue after checkout.
bool shouldShowOutsideSalonZoneChip({
  required EtAttendanceDay? day,
  required List<EtAttendancePunch> punches,
  required AttendanceSettingsModel settings,
  required bool employeeAttendanceRequired,
  required EmployeeWorkplaceLocationSnapshot location,
}) {
  if (!settings.hasSalonLocationConfigured) {
    return false;
  }
  final zoneRequiredForEmployee =
      employeeAttendanceRequired && settings.locationRequired;
  final completed = _completedForDay(day);

  if (completed) {
    if (!zoneRequiredForEmployee) {
      return false;
    }
    if (punches.isNotEmpty && !punches.last.insideZone) {
      return true;
    }
    if (day != null && !day.isInsideZone) {
      return true;
    }
    return false;
  }

  if (!location.resolved || !location.hasFix) {
    return false;
  }
  if (!zoneRequiredForEmployee) {
    return false;
  }
  return location.insideZone == false;
}

bool shouldShowMissingPunchChip(EtAttendanceDay? day) {
  if (day == null) {
    return false;
  }
  if (day.status == 'incomplete') {
    return true;
  }
  return day.hasMissingPunch;
}

bool employeeAttendanceRequired(Employee? e) => e?.attendanceRequired == true;
