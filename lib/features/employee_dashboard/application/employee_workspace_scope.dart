import 'package:flutter/foundation.dart';

import '../../users/data/models/app_user.dart';

@immutable
class EmployeeWorkspaceScope {
  const EmployeeWorkspaceScope({
    required this.salonId,
    required this.employeeId,
    required this.uid,
    required this.displayName,
    required this.role,
    required this.userActive,
  });

  final String salonId;
  final String employeeId;
  final String uid;
  final String displayName;

  /// From `users/{uid}.role` (staff roles: barber, employee, admin, readonly).
  final String role;
  final bool userActive;

  /// True when `users/{uid}` has both `salonId` and `employeeId` (required for employee Firestore queries).
  static bool userHasStaffWorkspaceLink(AppUser? user) {
    if (user == null) {
      return false;
    }
    final sid = user.salonId?.trim() ?? '';
    final eid = user.employeeId?.trim() ?? '';
    return sid.isNotEmpty && eid.isNotEmpty;
  }

  static EmployeeWorkspaceScope? fromAppUser(AppUser? user) {
    if (user == null) {
      return null;
    }
    final sid = user.salonId?.trim() ?? '';
    final eid = user.employeeId?.trim() ?? '';
    if (sid.isEmpty || eid.isEmpty) {
      return null;
    }
    return EmployeeWorkspaceScope(
      salonId: sid,
      employeeId: eid,
      uid: user.uid,
      displayName: user.name.trim().isNotEmpty ? user.name.trim() : user.email,
      role: user.role.trim(),
      userActive: user.isActive,
    );
  }
}
