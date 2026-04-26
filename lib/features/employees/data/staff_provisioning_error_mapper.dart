import '../domain/staff_provisioning_exception.dart';

/// Maps [FirebaseFunctionsException.code] to [StaffProvisioningFailureKind].
StaffProvisioningFailureKind staffProvisioningFailureKindForCode(String code) {
  switch (code) {
    case 'already-exists':
      return StaffProvisioningFailureKind.emailAlreadyExists;
    case 'permission-denied':
    case 'unauthenticated':
      return StaffProvisioningFailureKind.permissionDenied;
    case 'unavailable':
    case 'deadline-exceeded':
    case 'resource-exhausted':
      return StaffProvisioningFailureKind.network;
    case 'invalid-argument':
      return StaffProvisioningFailureKind.invalidArgument;
    default:
      return StaffProvisioningFailureKind.unknown;
  }
}
