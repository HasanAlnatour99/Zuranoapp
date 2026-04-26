import 'package:freezed_annotation/freezed_annotation.dart';

/// Payload for [NotificationRepository.registerDeviceToken] (callable).
part 'device_token_model.freezed.dart';
part 'device_token_model.g.dart';

@freezed
abstract class DeviceRegistrationPayload with _$DeviceRegistrationPayload {
  const factory DeviceRegistrationPayload({
    required String deviceId,
    required String token,
    required String platform,
    required String appVersion,
    required String locale,
    required String timezone,
    @Default(true) bool pushEnabled,
  }) = _DeviceRegistrationPayload;

  factory DeviceRegistrationPayload.fromJson(Map<String, dynamic> json) =>
      _$DeviceRegistrationPayloadFromJson(json);

  const DeviceRegistrationPayload._();

  Map<String, dynamic> toCallableMap() => toJson();
}
