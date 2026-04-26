// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'staff_provisioning_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StaffProvisioningResult _$StaffProvisioningResultFromJson(
  Map<String, dynamic> json,
) => _StaffProvisioningResult(
  employeeId: json['employeeId'] as String,
  uid: json['uid'] as String,
  email: json['email'] as String,
  username: nullableLooseStringFromJson(json['username']),
);

Map<String, dynamic> _$StaffProvisioningResultToJson(
  _StaffProvisioningResult instance,
) => <String, dynamic>{
  'employeeId': instance.employeeId,
  'uid': instance.uid,
  'email': instance.email,
  'username': instance.username,
};
