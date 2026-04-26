import 'package:flutter/foundation.dart';

import '../../employees/data/models/employee.dart';
import 'employee_workspace_scope.dart';

/// Staff session derived from `users/{uid}` ([EmployeeWorkspaceScope]) plus
/// `salons/{salonId}/employees/{employeeId}` when available.
@immutable
class EmployeeSessionScope {
  const EmployeeSessionScope({
    required this.uid,
    required this.salonId,
    required this.employeeId,
    required this.role,
    required this.userActive,
    required this.employeeActive,
    required this.employeeRecordResolved,
    this.permissions = const <String, dynamic>{},
    this.attendanceRequired = true,
    this.commissionPercent,
    this.displayName,
    this.photoUrl,
  });

  final String uid;
  final String salonId;
  final String employeeId;
  final String role;
  final bool userActive;
  final bool employeeActive;
  final bool employeeRecordResolved;
  final Map<String, dynamic> permissions;
  final bool attendanceRequired;
  final double? commissionPercent;
  final String? displayName;
  final String? photoUrl;

  bool get hasStaffLink =>
      salonId.trim().isNotEmpty && employeeId.trim().isNotEmpty;

  /// Staff workspace Firestore reads/writes are allowed only when the user and
  /// employee profile are both active and the employee doc exists.
  bool get canUseStaffWorkspace =>
      hasStaffLink && userActive && employeeRecordResolved && employeeActive;

  static EmployeeSessionScope merge({
    required EmployeeWorkspaceScope scope,
    Employee? employee,
  }) {
    final emp = employee;
    final name = emp?.name.trim() ?? '';
    return EmployeeSessionScope(
      uid: scope.uid,
      salonId: scope.salonId,
      employeeId: scope.employeeId,
      role: scope.role,
      userActive: scope.userActive,
      employeeActive: emp?.isActive ?? false,
      employeeRecordResolved: emp != null,
      permissions: const <String, dynamic>{},
      attendanceRequired: emp?.attendanceRequired ?? true,
      commissionPercent: emp?.effectiveCommissionRate ?? emp?.commissionRate,
      displayName: name.isNotEmpty ? name : scope.displayName,
      photoUrl: emp?.avatarUrl,
    );
  }
}
