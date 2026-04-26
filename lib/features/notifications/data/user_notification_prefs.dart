import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/firestore/firestore_json_helpers.dart';

part 'user_notification_prefs.freezed.dart';
part 'user_notification_prefs.g.dart';

@freezed
abstract class UserNotificationPrefs with _$UserNotificationPrefs {
  const UserNotificationPrefs._();

  const factory UserNotificationPrefs({
    @Default(true) @JsonKey(fromJson: trueBoolFromJson) bool pushEnabled,
    @Default(true) @JsonKey(fromJson: trueBoolFromJson) bool bookingReminders,
    @Default(true) @JsonKey(fromJson: trueBoolFromJson) bool bookingChanges,
    @Default(true) @JsonKey(fromJson: trueBoolFromJson) bool payrollAlerts,
    @Default(true) @JsonKey(fromJson: trueBoolFromJson) bool violationAlerts,
    @Default(false) @JsonKey(fromJson: falseBoolFromJson) bool marketingEnabled,
  }) = _UserNotificationPrefs;

  static UserNotificationPrefs defaults() => const UserNotificationPrefs();

  factory UserNotificationPrefs.fromJson(Map<String, dynamic>? json) =>
      json == null || json.isEmpty
      ? UserNotificationPrefs.defaults()
      : _$UserNotificationPrefsFromJson(json);

  Map<String, dynamic> toCallableUpdatePayload() => toJson();
}
