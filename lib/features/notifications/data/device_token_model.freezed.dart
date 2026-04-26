// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device_token_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeviceRegistrationPayload {

 String get deviceId; String get token; String get platform; String get appVersion; String get locale; String get timezone; bool get pushEnabled;
/// Create a copy of DeviceRegistrationPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceRegistrationPayloadCopyWith<DeviceRegistrationPayload> get copyWith => _$DeviceRegistrationPayloadCopyWithImpl<DeviceRegistrationPayload>(this as DeviceRegistrationPayload, _$identity);

  /// Serializes this DeviceRegistrationPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceRegistrationPayload&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.token, token) || other.token == token)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.pushEnabled, pushEnabled) || other.pushEnabled == pushEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deviceId,token,platform,appVersion,locale,timezone,pushEnabled);

@override
String toString() {
  return 'DeviceRegistrationPayload(deviceId: $deviceId, token: $token, platform: $platform, appVersion: $appVersion, locale: $locale, timezone: $timezone, pushEnabled: $pushEnabled)';
}


}

/// @nodoc
abstract mixin class $DeviceRegistrationPayloadCopyWith<$Res>  {
  factory $DeviceRegistrationPayloadCopyWith(DeviceRegistrationPayload value, $Res Function(DeviceRegistrationPayload) _then) = _$DeviceRegistrationPayloadCopyWithImpl;
@useResult
$Res call({
 String deviceId, String token, String platform, String appVersion, String locale, String timezone, bool pushEnabled
});




}
/// @nodoc
class _$DeviceRegistrationPayloadCopyWithImpl<$Res>
    implements $DeviceRegistrationPayloadCopyWith<$Res> {
  _$DeviceRegistrationPayloadCopyWithImpl(this._self, this._then);

  final DeviceRegistrationPayload _self;
  final $Res Function(DeviceRegistrationPayload) _then;

/// Create a copy of DeviceRegistrationPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deviceId = null,Object? token = null,Object? platform = null,Object? appVersion = null,Object? locale = null,Object? timezone = null,Object? pushEnabled = null,}) {
  return _then(_self.copyWith(
deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,appVersion: null == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,pushEnabled: null == pushEnabled ? _self.pushEnabled : pushEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DeviceRegistrationPayload].
extension DeviceRegistrationPayloadPatterns on DeviceRegistrationPayload {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeviceRegistrationPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeviceRegistrationPayload() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeviceRegistrationPayload value)  $default,){
final _that = this;
switch (_that) {
case _DeviceRegistrationPayload():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeviceRegistrationPayload value)?  $default,){
final _that = this;
switch (_that) {
case _DeviceRegistrationPayload() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String deviceId,  String token,  String platform,  String appVersion,  String locale,  String timezone,  bool pushEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeviceRegistrationPayload() when $default != null:
return $default(_that.deviceId,_that.token,_that.platform,_that.appVersion,_that.locale,_that.timezone,_that.pushEnabled);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String deviceId,  String token,  String platform,  String appVersion,  String locale,  String timezone,  bool pushEnabled)  $default,) {final _that = this;
switch (_that) {
case _DeviceRegistrationPayload():
return $default(_that.deviceId,_that.token,_that.platform,_that.appVersion,_that.locale,_that.timezone,_that.pushEnabled);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String deviceId,  String token,  String platform,  String appVersion,  String locale,  String timezone,  bool pushEnabled)?  $default,) {final _that = this;
switch (_that) {
case _DeviceRegistrationPayload() when $default != null:
return $default(_that.deviceId,_that.token,_that.platform,_that.appVersion,_that.locale,_that.timezone,_that.pushEnabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeviceRegistrationPayload extends DeviceRegistrationPayload {
  const _DeviceRegistrationPayload({required this.deviceId, required this.token, required this.platform, required this.appVersion, required this.locale, required this.timezone, this.pushEnabled = true}): super._();
  factory _DeviceRegistrationPayload.fromJson(Map<String, dynamic> json) => _$DeviceRegistrationPayloadFromJson(json);

@override final  String deviceId;
@override final  String token;
@override final  String platform;
@override final  String appVersion;
@override final  String locale;
@override final  String timezone;
@override@JsonKey() final  bool pushEnabled;

/// Create a copy of DeviceRegistrationPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceRegistrationPayloadCopyWith<_DeviceRegistrationPayload> get copyWith => __$DeviceRegistrationPayloadCopyWithImpl<_DeviceRegistrationPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeviceRegistrationPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeviceRegistrationPayload&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.token, token) || other.token == token)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.pushEnabled, pushEnabled) || other.pushEnabled == pushEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deviceId,token,platform,appVersion,locale,timezone,pushEnabled);

@override
String toString() {
  return 'DeviceRegistrationPayload(deviceId: $deviceId, token: $token, platform: $platform, appVersion: $appVersion, locale: $locale, timezone: $timezone, pushEnabled: $pushEnabled)';
}


}

/// @nodoc
abstract mixin class _$DeviceRegistrationPayloadCopyWith<$Res> implements $DeviceRegistrationPayloadCopyWith<$Res> {
  factory _$DeviceRegistrationPayloadCopyWith(_DeviceRegistrationPayload value, $Res Function(_DeviceRegistrationPayload) _then) = __$DeviceRegistrationPayloadCopyWithImpl;
@override @useResult
$Res call({
 String deviceId, String token, String platform, String appVersion, String locale, String timezone, bool pushEnabled
});




}
/// @nodoc
class __$DeviceRegistrationPayloadCopyWithImpl<$Res>
    implements _$DeviceRegistrationPayloadCopyWith<$Res> {
  __$DeviceRegistrationPayloadCopyWithImpl(this._self, this._then);

  final _DeviceRegistrationPayload _self;
  final $Res Function(_DeviceRegistrationPayload) _then;

/// Create a copy of DeviceRegistrationPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deviceId = null,Object? token = null,Object? platform = null,Object? appVersion = null,Object? locale = null,Object? timezone = null,Object? pushEnabled = null,}) {
  return _then(_DeviceRegistrationPayload(
deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,appVersion: null == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,pushEnabled: null == pushEnabled ? _self.pushEnabled : pushEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
