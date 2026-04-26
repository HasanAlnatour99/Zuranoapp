import '../../../core/constants/user_roles.dart';

enum EmployeeRole { owner, admin, barber, readonly }

extension EmployeeRoleX on EmployeeRole {
  String get value => name;
}

EmployeeRole employeeRoleFromString(String? value) {
  final normalized = (value ?? '').trim().toLowerCase();
  switch (normalized) {
    case UserRoles.owner:
      return EmployeeRole.owner;
    case UserRoles.admin:
      return EmployeeRole.admin;
    case UserRoles.barber:
      return EmployeeRole.barber;
    case UserRoles.readonly:
      return EmployeeRole.readonly;
    // Legacy role used by older staff provisioning.
    case UserRoles.employee:
      return EmployeeRole.barber;
    default:
      throw ArgumentError('Invalid employee role: $value');
  }
}

String employeeRoleToFirestoreString(EmployeeRole role) => role.value;
