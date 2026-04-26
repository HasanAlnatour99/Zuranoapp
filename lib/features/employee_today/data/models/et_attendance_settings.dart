import '../../../owner/settings/attendance/domain/models/attendance_settings_model.dart';

/// Deprecated alias kept for backward compatibility while the employee
/// punch pipeline migrates to [AttendanceSettingsModel].
///
/// All static factories (`defaults`, `fromFirestore`) and instance fields
/// (`attendanceEnabled`, `gpsRequired`, `salonLatitude`, `salonLongitude`,
/// `salonAddress`, `allowedRadiusMeters`, `maxBreakCyclesPerDay`,
/// `graceLateMinutes`, `graceEarlyExitMinutes`, …) resolve through the
/// canonical model thanks to compatibility getters declared there.
///
/// Prefer the canonical name in new code.
@Deprecated(
  'Use AttendanceSettingsModel from '
  'features/owner/settings/attendance/domain/models/attendance_settings_model.dart',
)
typedef EtAttendanceSettings = AttendanceSettingsModel;
