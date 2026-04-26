import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/firebase_providers.dart';
import '../../employee_dashboard/application/employee_dashboard_providers.dart';
import '../data/models/et_attendance_day.dart';
import '../data/models/et_attendance_punch.dart';
import '../data/models/et_attendance_settings.dart';
import '../data/models/et_correction_request.dart';
import '../data/models/et_policy_readable.dart';
import '../data/repositories/attendance_policy_repository.dart';
import '../data/repositories/employee_today_attendance_repository.dart';

final attendancePolicyRepositoryProvider = Provider<AttendancePolicyRepository>(
  (ref) {
    return AttendancePolicyRepository(firestore: ref.read(firestoreProvider));
  },
);

final employeeTodayAttendanceRepositoryProvider =
    Provider<EmployeeTodayAttendanceRepository>((ref) {
      return EmployeeTodayAttendanceRepository(
        firestore: ref.read(firestoreProvider),
      );
    });

final etAttendanceSettingsProvider =
    StreamProvider.autoDispose<EtAttendanceSettings>((ref) {
      final scope = ref.watch(employeeWorkspaceScopeProvider);
      if (scope == null) {
        return Stream<EtAttendanceSettings>.value(
          EtAttendanceSettings.defaults(''),
        );
      }
      return ref
          .watch(employeeTodayAttendanceRepositoryProvider)
          .watchAttendanceSettings(scope.salonId);
    });

final etTodayAttendanceDayProvider =
    StreamProvider.autoDispose<EtAttendanceDay?>((ref) {
      final scope = ref.watch(employeeWorkspaceScopeProvider);
      if (scope == null) {
        return Stream<EtAttendanceDay?>.value(null);
      }
      return ref
          .watch(employeeTodayAttendanceRepositoryProvider)
          .watchTodayAttendanceDay(
            salonId: scope.salonId,
            employeeId: scope.employeeId,
          );
    });

final etTodayPunchesProvider =
    StreamProvider.autoDispose<List<EtAttendancePunch>>((ref) {
      final scope = ref.watch(employeeWorkspaceScopeProvider);
      if (scope == null) {
        return Stream<List<EtAttendancePunch>>.value(const []);
      }
      final dk = EmployeeTodayAttendanceRepository.compactDateKey(
        DateTime.now(),
      );
      final id = EmployeeTodayAttendanceRepository.attendanceDayId(
        scope.employeeId,
        dk,
      );
      return ref
          .watch(employeeTodayAttendanceRepositoryProvider)
          .watchTodayPunches(salonId: scope.salonId, attendanceDayId: id);
    });

final etEmployeeCorrectionRequestsProvider =
    StreamProvider.autoDispose<List<EtCorrectionRequest>>((ref) {
      final scope = ref.watch(employeeWorkspaceScopeProvider);
      if (scope == null) {
        return Stream<List<EtCorrectionRequest>>.value(const []);
      }
      return ref
          .watch(employeeTodayAttendanceRepositoryProvider)
          .watchEmployeeCorrectionRequests(
            salonId: scope.salonId,
            employeeId: scope.employeeId,
            limit: 8,
          );
    });

final etAttendancePolicyReadableProvider =
    StreamProvider.autoDispose<EtPolicyReadable?>((ref) {
      final scope = ref.watch(employeeWorkspaceScopeProvider);
      if (scope == null) {
        return Stream<EtPolicyReadable?>.value(null);
      }
      return ref
          .watch(attendancePolicyRepositoryProvider)
          .watchReadablePolicy(scope.salonId);
    });
