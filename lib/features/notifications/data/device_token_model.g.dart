// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_token_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DeviceRegistrationPayload _$DeviceRegistrationPayloadFromJson(
  Map<String, dynamic> json,
) => _DeviceRegistrationPayload(
  deviceId: json['deviceId'] as String,
  token: json['token'] as String,
  platform: json['platform'] as String,
  appVersion: json['appVersion'] as String,
  locale: json['locale'] as String,
  timezone: json['timezone'] as String,
  pushEnabled: json['pushEnabled'] as bool? ?? true,
);

Map<String, dynamic> _$DeviceRegistrationPayloadToJson(
  _DeviceRegistrationPayload instance,
) => <String, dynamic>{
  'deviceId': instance.deviceId,
  'token': instance.token,
  'platform': instance.platform,
  'appVersion': instance.appVersion,
  'locale': instance.locale,
  'timezone': instance.timezone,
  'pushEnabled': instance.pushEnabled,
};
