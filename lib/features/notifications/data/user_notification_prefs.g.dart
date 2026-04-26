// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_notification_prefs.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserNotificationPrefs _$UserNotificationPrefsFromJson(
  Map<String, dynamic> json,
) => _UserNotificationPrefs(
  pushEnabled: json['pushEnabled'] == null
      ? true
      : trueBoolFromJson(json['pushEnabled']),
  bookingReminders: json['bookingReminders'] == null
      ? true
      : trueBoolFromJson(json['bookingReminders']),
  bookingChanges: json['bookingChanges'] == null
      ? true
      : trueBoolFromJson(json['bookingChanges']),
  payrollAlerts: json['payrollAlerts'] == null
      ? true
      : trueBoolFromJson(json['payrollAlerts']),
  violationAlerts: json['violationAlerts'] == null
      ? true
      : trueBoolFromJson(json['violationAlerts']),
  marketingEnabled: json['marketingEnabled'] == null
      ? false
      : falseBoolFromJson(json['marketingEnabled']),
);

Map<String, dynamic> _$UserNotificationPrefsToJson(
  _UserNotificationPrefs instance,
) => <String, dynamic>{
  'pushEnabled': instance.pushEnabled,
  'bookingReminders': instance.bookingReminders,
  'bookingChanges': instance.bookingChanges,
  'payrollAlerts': instance.payrollAlerts,
  'violationAlerts': instance.violationAlerts,
  'marketingEnabled': instance.marketingEnabled,
};
