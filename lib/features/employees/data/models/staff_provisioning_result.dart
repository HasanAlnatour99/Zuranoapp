import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/firestore/firestore_json_helpers.dart';

/// Result of [StaffProvisioningRepository.createStaffMemberWithAuth].
part 'staff_provisioning_result.freezed.dart';
part 'staff_provisioning_result.g.dart';

@freezed
abstract class StaffProvisioningResult with _$StaffProvisioningResult {
  const factory StaffProvisioningResult({
    required String employeeId,
    required String uid,
    required String email,
    @JsonKey(fromJson: nullableLooseStringFromJson) String? username,
  }) = _StaffProvisioningResult;

  factory StaffProvisioningResult.fromJson(Map<String, dynamic> json) =>
      _$StaffProvisioningResultFromJson(json);
}
