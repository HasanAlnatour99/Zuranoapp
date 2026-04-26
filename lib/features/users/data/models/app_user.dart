import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/firestore/firestore_json_helpers.dart';
import '../../../../core/firestore/firestore_serializers.dart';
import '../../../notifications/data/user_notification_prefs.dart';
import '../../../onboarding/domain/value_objects/user_address.dart';
import '../../../onboarding/domain/value_objects/user_phone.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

@freezed
abstract class AppUser with _$AppUser {
  const AppUser._();

  const factory AppUser({
    @JsonKey(fromJson: looseStringFromJson) required String uid,
    @JsonKey(fromJson: looseStringFromJson) required String email,
    @JsonKey(fromJson: looseStringFromJson) required String name,
    @JsonKey(fromJson: looseStringFromJson) required String role,
    @Default(true) @JsonKey(fromJson: trueBoolFromJson) bool isActive,
    @JsonKey(fromJson: nullableLooseStringFromJson) String? salonId,
    @JsonKey(fromJson: nullableLooseStringFromJson) String? employeeId,
    @JsonKey(fromJson: nullableLooseStringFromJson) String? username,
    @JsonKey(fromJson: nullableLooseStringFromJson) String? usernameLower,
    @JsonKey(fromJson: nullableLooseStringFromJson) String? photoUrl,
    @JsonKey(fromJson: nullableLooseStringFromJson) String? authProvider,
    @Default(true)
    @JsonKey(fromJson: trueBoolFromJson)
    bool onboardingCompleted,
    @JsonKey(
      fromJson: nullableFirestoreDateTimeFromJson,
      toJson: nullableFirestoreDateTimeToJson,
    )
    DateTime? profileCompletedAt,
    @JsonKey(
      fromJson: nullableFirestoreDateTimeFromJson,
      toJson: nullableFirestoreDateTimeToJson,
    )
    DateTime? createdAt,
    @JsonKey(
      fromJson: nullableFirestoreDateTimeFromJson,
      toJson: nullableFirestoreDateTimeToJson,
    )
    DateTime? updatedAt,
    // Legacy / Other fields
    @JsonKey(fromJson: nullableLooseStringFromJson) String? onboardingStatus,
    @JsonKey(fromJson: _nullableBoolFromJson) bool? salonCreationCompleted,
    @JsonKey(fromJson: _phoneFromJson, toJson: _phoneToJson) UserPhone? phone,
    @JsonKey(fromJson: _addressFromJson, toJson: _addressToJson)
    UserAddress? address,
    @JsonKey(
      fromJson: _notificationPrefsFromJson,
      toJson: _notificationPrefsToJson,
    )
    UserNotificationPrefs? notificationPrefs,
    @JsonKey(fromJson: _nullableBoolFromJson) bool? mustChangePassword,
  }) = _AppUser;

  /// E.164 or legacy string for employee rows / display fallbacks.
  String? get phoneE164OrEmpty => phone?.e164;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(_normalizedAppUserJson(json));

  @override
  Map<String, dynamic> toJson() {
    final json = _$AppUserToJson(this as _AppUser);
    json['displayName'] = name;
    json['fullName'] = name;
    json['name'] = name;
    return json;
  }
}

Map<String, dynamic> _normalizedAppUserJson(Map<String, dynamic> json) {
  final displayName =
      FirestoreSerializers.string(json['displayName']) ??
      FirestoreSerializers.string(json['fullName']) ??
      FirestoreSerializers.string(json['name']) ??
      '';

  final normalized = Map<String, dynamic>.from(json);
  normalized['name'] = displayName;
  return normalized;
}

UserPhone? _phoneFromJson(Object? raw) {
  if (raw == null) return null;
  if (raw is String) {
    final value = raw.trim();
    if (value.isEmpty) {
      return null;
    }
    return UserPhone(
      countryIsoCode: '',
      dialCode: '',
      nationalNumber: value,
      e164: value,
    );
  }
  if (raw is Map) {
    return UserPhone.fromJson(Map<String, dynamic>.from(raw));
  }
  return null;
}

Map<String, dynamic>? _phoneToJson(UserPhone? phone) => phone?.toJson();

UserAddress? _addressFromJson(Object? raw) {
  if (raw is Map) {
    return UserAddress.fromJson(Map<String, dynamic>.from(raw));
  }
  return null;
}

Map<String, dynamic>? _addressToJson(UserAddress? address) => address?.toJson();

UserNotificationPrefs? _notificationPrefsFromJson(Object? raw) {
  if (raw is Map<String, dynamic>) {
    return UserNotificationPrefs.fromJson(raw);
  }
  if (raw is Map) {
    return UserNotificationPrefs.fromJson(Map<String, dynamic>.from(raw));
  }
  return null;
}

Map<String, dynamic>? _notificationPrefsToJson(UserNotificationPrefs? prefs) =>
    prefs?.toJson();

bool? _nullableBoolFromJson(Object? value) {
  if (value == null) {
    return null;
  }
  return FirestoreSerializers.boolValue(value);
}
