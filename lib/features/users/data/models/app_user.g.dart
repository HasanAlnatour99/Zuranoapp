// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppUser _$AppUserFromJson(Map<String, dynamic> json) => _AppUser(
  uid: looseStringFromJson(json['uid']),
  email: looseStringFromJson(json['email']),
  name: looseStringFromJson(json['name']),
  role: looseStringFromJson(json['role']),
  isActive: json['isActive'] == null
      ? true
      : trueBoolFromJson(json['isActive']),
  salonId: nullableLooseStringFromJson(json['salonId']),
  employeeId: nullableLooseStringFromJson(json['employeeId']),
  username: nullableLooseStringFromJson(json['username']),
  usernameLower: nullableLooseStringFromJson(json['usernameLower']),
  photoUrl: nullableLooseStringFromJson(json['photoUrl']),
  authProvider: nullableLooseStringFromJson(json['authProvider']),
  onboardingCompleted: json['onboardingCompleted'] == null
      ? true
      : trueBoolFromJson(json['onboardingCompleted']),
  profileCompletedAt: nullableFirestoreDateTimeFromJson(
    json['profileCompletedAt'],
  ),
  createdAt: nullableFirestoreDateTimeFromJson(json['createdAt']),
  updatedAt: nullableFirestoreDateTimeFromJson(json['updatedAt']),
  onboardingStatus: nullableLooseStringFromJson(json['onboardingStatus']),
  salonCreationCompleted: _nullableBoolFromJson(json['salonCreationCompleted']),
  phone: _phoneFromJson(json['phone']),
  address: _addressFromJson(json['address']),
  notificationPrefs: _notificationPrefsFromJson(json['notificationPrefs']),
  mustChangePassword: _nullableBoolFromJson(json['mustChangePassword']),
);

Map<String, dynamic> _$AppUserToJson(_AppUser instance) => <String, dynamic>{
  'uid': instance.uid,
  'email': instance.email,
  'name': instance.name,
  'role': instance.role,
  'isActive': instance.isActive,
  'salonId': instance.salonId,
  'employeeId': instance.employeeId,
  'username': instance.username,
  'usernameLower': instance.usernameLower,
  'photoUrl': instance.photoUrl,
  'authProvider': instance.authProvider,
  'onboardingCompleted': instance.onboardingCompleted,
  'profileCompletedAt': nullableFirestoreDateTimeToJson(
    instance.profileCompletedAt,
  ),
  'createdAt': nullableFirestoreDateTimeToJson(instance.createdAt),
  'updatedAt': nullableFirestoreDateTimeToJson(instance.updatedAt),
  'onboardingStatus': instance.onboardingStatus,
  'salonCreationCompleted': instance.salonCreationCompleted,
  'phone': _phoneToJson(instance.phone),
  'address': _addressToJson(instance.address),
  'notificationPrefs': _notificationPrefsToJson(instance.notificationPrefs),
  'mustChangePassword': instance.mustChangePassword,
};
