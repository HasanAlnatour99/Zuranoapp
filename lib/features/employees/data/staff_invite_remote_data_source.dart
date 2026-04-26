import 'package:cloud_functions/cloud_functions.dart';

import '../../../core/firebase/cloud_functions_region.dart';

/// Raw HTTPS callable for salon staff provisioning (see `salonStaffCreateWithAuth`).
class StaffInviteRemoteDataSource {
  StaffInviteRemoteDataSource({FirebaseFunctions? functions})
    : _functions = functions ?? appCloudFunctions();

  final FirebaseFunctions _functions;

  static const callableName = 'salonStaffCreateWithAuth';

  Future<Map<String, dynamic>> createStaffWithAuth({
    required String salonId,
    required String email,
    required String username,

    /// Raw display name from the form (server trims for validation and Auth).
    /// [fullName] is sent as a trimmed alias for older deployments that only read `fullName`.
    required String displayName,
    required String password,
    required String role,
    String? phone,
    required double commissionPercent,
    required bool attendanceRequired,
    required bool isBookable,
    required bool isActive,
    required Map<String, bool> permissions,
  }) async {
    final callable = _functions.httpsCallable(callableName);
    final result = await callable.call(<String, dynamic>{
      'salonId': salonId,
      'email': email.trim().toLowerCase(),
      'username': username.trim(),
      'role': role.trim().toLowerCase(),
      'displayName': displayName,
      'fullName': displayName.trim(),
      'password': password,
      'commissionPercent': commissionPercent,
      'attendanceRequired': attendanceRequired,
      'isBookable': isBookable,
      'isActive': isActive,
      'permissions': permissions,
      if (phone != null && phone.trim().isNotEmpty) 'phone': phone.trim(),
    });

    final raw = result.data;
    if (raw is! Map) {
      throw StateError('$callableName returned invalid payload.');
    }
    return Map<String, dynamic>.from(raw);
  }
}
