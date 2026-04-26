import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/employees/data/models/employee.dart';
import '../../../providers/repository_providers.dart';
import '../../../providers/session_provider.dart';
import '../data/models/attendance_day_model.dart';
import '../data/models/attendance_event_model.dart';
import '../data/models/employee_today_summary_model.dart';
import '../data/repositories/employee_attendance_repository.dart';
import '../domain/services/attendance_calculation_service.dart';
import 'employee_session_scope.dart';
import 'employee_workspace_scope.dart';

final employeeWorkspaceScopeProvider = Provider<EmployeeWorkspaceScope?>((ref) {
  final user = ref.watch(sessionUserProvider).asData?.value;
  return EmployeeWorkspaceScope.fromAppUser(user);
});

/// When staff is signed in but `users/{uid}` lacks `salonId` or `employeeId`, employee queries must not run.
final employeeStaffFirestoreLinkReadyProvider = Provider<bool>((ref) {
  final user = ref.watch(sessionUserProvider).asData?.value;
  return EmployeeWorkspaceScope.userHasStaffWorkspaceLink(user);
});

final employeeTodayAttendanceStreamProvider =
    StreamProvider.autoDispose<AttendanceDayModel?>((ref) {
      final scope = ref.watch(employeeWorkspaceScopeProvider);
      if (scope == null) {
        return Stream<AttendanceDayModel?>.value(null);
      }
      final dk = EmployeeAttendanceRepository.compactDateKey(DateTime.now());
      final attendanceId = EmployeeAttendanceRepository.attendanceDocumentId(
        scope.employeeId,
        dk,
      );
      debugPrint('[EmployeeDashboard] attendanceId=$attendanceId (day stream)');
      return ref
          .watch(employeeAttendanceRepositoryProvider)
          .watchDay(
            salonId: scope.salonId,
            employeeId: scope.employeeId,
            day: DateTime.now(),
          );
    });

final employeeTodayEventsStreamProvider =
    StreamProvider.autoDispose<List<AttendanceEventModel>>((ref) {
      final scope = ref.watch(employeeWorkspaceScopeProvider);
      if (scope == null) {
        return Stream<List<AttendanceEventModel>>.value(const []);
      }
      return ref
          .watch(employeeAttendanceRepositoryProvider)
          .watchDayEvents(
            salonId: scope.salonId,
            employeeId: scope.employeeId,
            day: DateTime.now(),
          );
    });

final employeeTodaySummaryProvider =
    FutureProvider.autoDispose<EmployeeTodaySummaryModel>((ref) async {
      final scope = ref.watch(employeeWorkspaceScopeProvider);
      if (scope == null) {
        return EmployeeTodaySummaryModel.empty;
      }
      final day = await ref
          .read(employeeAttendanceRepositoryProvider)
          .watchDay(
            salonId: scope.salonId,
            employeeId: scope.employeeId,
            day: DateTime.now(),
          )
          .first;
      final calc = AttendanceCalculationService();
      var worked = '0.0';
      if (day?.punchInAt != null) {
        final mins = calc.calculateWorkedMinutes(
          punchInAt: day!.punchInAt!,
          punchOutAt: day.punchOutAt,
          totalBreakMinutes: day.totalBreakMinutes,
        );
        worked = calc.formatHoursFromMinutes(mins);
      }
      return ref
          .read(employeeDashboardRepositoryProvider)
          .loadTodaySummary(
            salonId: scope.salonId,
            employeeId: scope.employeeId,
            day: DateTime.now(),
            workedHoursLabel: worked,
          );
    });

final workspaceEmployeeProvider = FutureProvider.autoDispose<Employee?>((
  ref,
) async {
  final scope = ref.watch(employeeWorkspaceScopeProvider);
  if (scope == null) {
    return null;
  }
  return ref
      .read(employeeRepositoryProvider)
      .getEmployee(scope.salonId, scope.employeeId);
});

/// Workspace scope plus `employees/{employeeId}` for active flags and profile.
final employeeSessionScopeProvider =
    FutureProvider.autoDispose<EmployeeSessionScope?>((ref) async {
      final scope = ref.watch(employeeWorkspaceScopeProvider);
      if (scope == null) {
        return null;
      }
      final emp = await ref
          .read(employeeRepositoryProvider)
          .getEmployee(scope.salonId, scope.employeeId);
      return EmployeeSessionScope.merge(scope: scope, employee: emp);
    });

final employeePendingAttendanceRequestsCountProvider =
    FutureProvider.autoDispose<int>((ref) async {
      final scope = ref.watch(employeeWorkspaceScopeProvider);
      if (scope == null) {
        return 0;
      }
      return ref
          .watch(attendanceRequestRepositoryProvider)
          .countPendingForEmployee(
            salonId: scope.salonId,
            employeeId: scope.employeeId,
          );
    });
