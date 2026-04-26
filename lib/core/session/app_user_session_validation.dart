import '../../features/users/data/models/app_user.dart';
import '../constants/user_roles.dart';

bool _hasSalonId(AppUser u) => u.salonId?.trim().isNotEmpty == true;

bool _hasEmployeeId(AppUser u) => u.employeeId?.trim().isNotEmpty == true;

/// Owner: correct role; salon may be absent until onboarding completes.
bool isOwnerSessionValid(AppUser u) {
  if (u.role != UserRoles.owner) {
    return false;
  }
  if (u.isActive != true) {
    return false;
  }
  return true;
}

bool isAdminSessionValid(AppUser u) {
  if (u.role != UserRoles.admin) {
    return false;
  }
  if (!_hasSalonId(u) || !_hasEmployeeId(u)) {
    return false;
  }
  if (u.isActive != true) {
    return false;
  }
  return true;
}

bool isBarberSessionValid(AppUser u) {
  if (u.role != UserRoles.barber) {
    return false;
  }
  if (!_hasSalonId(u) || !_hasEmployeeId(u)) {
    return false;
  }
  if (u.isActive != true) {
    return false;
  }
  return true;
}

enum ProfileIntegrityIssue { none, staffMissingLinkage }

ProfileIntegrityIssue classifyStaffLinkage(AppUser u) {
  if (u.role != UserRoles.employee &&
      u.role != UserRoles.admin &&
      u.role != UserRoles.barber &&
      u.role != UserRoles.readonly) {
    return ProfileIntegrityIssue.none;
  }
  if (!_hasSalonId(u) || !_hasEmployeeId(u)) {
    return ProfileIntegrityIssue.staffMissingLinkage;
  }
  return ProfileIntegrityIssue.none;
}
