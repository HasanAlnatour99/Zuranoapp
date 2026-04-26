/// Classified failure from [StaffProvisioningRepository.createStaffMemberWithAuth].
enum StaffProvisioningFailureKind {
  emailAlreadyExists,
  permissionDenied,
  network,
  invalidArgument,
  unknown,
}

class StaffProvisioningException implements Exception {
  const StaffProvisioningException(this.kind, {this.message, this.code});

  final StaffProvisioningFailureKind kind;
  final String? message;
  final String? code;

  @override
  String toString() =>
      'StaffProvisioningException($kind, code=$code, message=$message)';
}
