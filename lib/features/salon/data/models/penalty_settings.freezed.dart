// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'penalty_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PenaltySettings {

@JsonKey(fromJson: falseBoolFromJson) bool get barberLateEnabled;@JsonKey(fromJson: _lateGraceMinutesFromJson) int get barberLateGraceMinutes;@JsonKey(fromJson: _lateTypeFromJson) String get barberLateCalculationType;@JsonKey(fromJson: looseDoubleFromJson) double get barberLateValue;@JsonKey(fromJson: falseBoolFromJson) bool get barberNoShowEnabled;@JsonKey(fromJson: _noShowTypeFromJson) String get barberNoShowCalculationType;@JsonKey(fromJson: looseDoubleFromJson) double get barberNoShowValue;
/// Create a copy of PenaltySettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PenaltySettingsCopyWith<PenaltySettings> get copyWith => _$PenaltySettingsCopyWithImpl<PenaltySettings>(this as PenaltySettings, _$identity);

  /// Serializes this PenaltySettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PenaltySettings&&(identical(other.barberLateEnabled, barberLateEnabled) || other.barberLateEnabled == barberLateEnabled)&&(identical(other.barberLateGraceMinutes, barberLateGraceMinutes) || other.barberLateGraceMinutes == barberLateGraceMinutes)&&(identical(other.barberLateCalculationType, barberLateCalculationType) || other.barberLateCalculationType == barberLateCalculationType)&&(identical(other.barberLateValue, barberLateValue) || other.barberLateValue == barberLateValue)&&(identical(other.barberNoShowEnabled, barberNoShowEnabled) || other.barberNoShowEnabled == barberNoShowEnabled)&&(identical(other.barberNoShowCalculationType, barberNoShowCalculationType) || other.barberNoShowCalculationType == barberNoShowCalculationType)&&(identical(other.barberNoShowValue, barberNoShowValue) || other.barberNoShowValue == barberNoShowValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,barberLateEnabled,barberLateGraceMinutes,barberLateCalculationType,barberLateValue,barberNoShowEnabled,barberNoShowCalculationType,barberNoShowValue);

@override
String toString() {
  return 'PenaltySettings(barberLateEnabled: $barberLateEnabled, barberLateGraceMinutes: $barberLateGraceMinutes, barberLateCalculationType: $barberLateCalculationType, barberLateValue: $barberLateValue, barberNoShowEnabled: $barberNoShowEnabled, barberNoShowCalculationType: $barberNoShowCalculationType, barberNoShowValue: $barberNoShowValue)';
}


}

/// @nodoc
abstract mixin class $PenaltySettingsCopyWith<$Res>  {
  factory $PenaltySettingsCopyWith(PenaltySettings value, $Res Function(PenaltySettings) _then) = _$PenaltySettingsCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: falseBoolFromJson) bool barberLateEnabled,@JsonKey(fromJson: _lateGraceMinutesFromJson) int barberLateGraceMinutes,@JsonKey(fromJson: _lateTypeFromJson) String barberLateCalculationType,@JsonKey(fromJson: looseDoubleFromJson) double barberLateValue,@JsonKey(fromJson: falseBoolFromJson) bool barberNoShowEnabled,@JsonKey(fromJson: _noShowTypeFromJson) String barberNoShowCalculationType,@JsonKey(fromJson: looseDoubleFromJson) double barberNoShowValue
});




}
/// @nodoc
class _$PenaltySettingsCopyWithImpl<$Res>
    implements $PenaltySettingsCopyWith<$Res> {
  _$PenaltySettingsCopyWithImpl(this._self, this._then);

  final PenaltySettings _self;
  final $Res Function(PenaltySettings) _then;

/// Create a copy of PenaltySettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? barberLateEnabled = null,Object? barberLateGraceMinutes = null,Object? barberLateCalculationType = null,Object? barberLateValue = null,Object? barberNoShowEnabled = null,Object? barberNoShowCalculationType = null,Object? barberNoShowValue = null,}) {
  return _then(_self.copyWith(
barberLateEnabled: null == barberLateEnabled ? _self.barberLateEnabled : barberLateEnabled // ignore: cast_nullable_to_non_nullable
as bool,barberLateGraceMinutes: null == barberLateGraceMinutes ? _self.barberLateGraceMinutes : barberLateGraceMinutes // ignore: cast_nullable_to_non_nullable
as int,barberLateCalculationType: null == barberLateCalculationType ? _self.barberLateCalculationType : barberLateCalculationType // ignore: cast_nullable_to_non_nullable
as String,barberLateValue: null == barberLateValue ? _self.barberLateValue : barberLateValue // ignore: cast_nullable_to_non_nullable
as double,barberNoShowEnabled: null == barberNoShowEnabled ? _self.barberNoShowEnabled : barberNoShowEnabled // ignore: cast_nullable_to_non_nullable
as bool,barberNoShowCalculationType: null == barberNoShowCalculationType ? _self.barberNoShowCalculationType : barberNoShowCalculationType // ignore: cast_nullable_to_non_nullable
as String,barberNoShowValue: null == barberNoShowValue ? _self.barberNoShowValue : barberNoShowValue // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [PenaltySettings].
extension PenaltySettingsPatterns on PenaltySettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PenaltySettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PenaltySettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PenaltySettings value)  $default,){
final _that = this;
switch (_that) {
case _PenaltySettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PenaltySettings value)?  $default,){
final _that = this;
switch (_that) {
case _PenaltySettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: falseBoolFromJson)  bool barberLateEnabled, @JsonKey(fromJson: _lateGraceMinutesFromJson)  int barberLateGraceMinutes, @JsonKey(fromJson: _lateTypeFromJson)  String barberLateCalculationType, @JsonKey(fromJson: looseDoubleFromJson)  double barberLateValue, @JsonKey(fromJson: falseBoolFromJson)  bool barberNoShowEnabled, @JsonKey(fromJson: _noShowTypeFromJson)  String barberNoShowCalculationType, @JsonKey(fromJson: looseDoubleFromJson)  double barberNoShowValue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PenaltySettings() when $default != null:
return $default(_that.barberLateEnabled,_that.barberLateGraceMinutes,_that.barberLateCalculationType,_that.barberLateValue,_that.barberNoShowEnabled,_that.barberNoShowCalculationType,_that.barberNoShowValue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: falseBoolFromJson)  bool barberLateEnabled, @JsonKey(fromJson: _lateGraceMinutesFromJson)  int barberLateGraceMinutes, @JsonKey(fromJson: _lateTypeFromJson)  String barberLateCalculationType, @JsonKey(fromJson: looseDoubleFromJson)  double barberLateValue, @JsonKey(fromJson: falseBoolFromJson)  bool barberNoShowEnabled, @JsonKey(fromJson: _noShowTypeFromJson)  String barberNoShowCalculationType, @JsonKey(fromJson: looseDoubleFromJson)  double barberNoShowValue)  $default,) {final _that = this;
switch (_that) {
case _PenaltySettings():
return $default(_that.barberLateEnabled,_that.barberLateGraceMinutes,_that.barberLateCalculationType,_that.barberLateValue,_that.barberNoShowEnabled,_that.barberNoShowCalculationType,_that.barberNoShowValue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: falseBoolFromJson)  bool barberLateEnabled, @JsonKey(fromJson: _lateGraceMinutesFromJson)  int barberLateGraceMinutes, @JsonKey(fromJson: _lateTypeFromJson)  String barberLateCalculationType, @JsonKey(fromJson: looseDoubleFromJson)  double barberLateValue, @JsonKey(fromJson: falseBoolFromJson)  bool barberNoShowEnabled, @JsonKey(fromJson: _noShowTypeFromJson)  String barberNoShowCalculationType, @JsonKey(fromJson: looseDoubleFromJson)  double barberNoShowValue)?  $default,) {final _that = this;
switch (_that) {
case _PenaltySettings() when $default != null:
return $default(_that.barberLateEnabled,_that.barberLateGraceMinutes,_that.barberLateCalculationType,_that.barberLateValue,_that.barberNoShowEnabled,_that.barberNoShowCalculationType,_that.barberNoShowValue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PenaltySettings implements PenaltySettings {
  const _PenaltySettings({@JsonKey(fromJson: falseBoolFromJson) this.barberLateEnabled = false, @JsonKey(fromJson: _lateGraceMinutesFromJson) this.barberLateGraceMinutes = 5, @JsonKey(fromJson: _lateTypeFromJson) this.barberLateCalculationType = PenaltyCalculationTypes.flat, @JsonKey(fromJson: looseDoubleFromJson) this.barberLateValue = 0, @JsonKey(fromJson: falseBoolFromJson) this.barberNoShowEnabled = false, @JsonKey(fromJson: _noShowTypeFromJson) this.barberNoShowCalculationType = PenaltyCalculationTypes.flat, @JsonKey(fromJson: looseDoubleFromJson) this.barberNoShowValue = 0});
  factory _PenaltySettings.fromJson(Map<String, dynamic> json) => _$PenaltySettingsFromJson(json);

@override@JsonKey(fromJson: falseBoolFromJson) final  bool barberLateEnabled;
@override@JsonKey(fromJson: _lateGraceMinutesFromJson) final  int barberLateGraceMinutes;
@override@JsonKey(fromJson: _lateTypeFromJson) final  String barberLateCalculationType;
@override@JsonKey(fromJson: looseDoubleFromJson) final  double barberLateValue;
@override@JsonKey(fromJson: falseBoolFromJson) final  bool barberNoShowEnabled;
@override@JsonKey(fromJson: _noShowTypeFromJson) final  String barberNoShowCalculationType;
@override@JsonKey(fromJson: looseDoubleFromJson) final  double barberNoShowValue;

/// Create a copy of PenaltySettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PenaltySettingsCopyWith<_PenaltySettings> get copyWith => __$PenaltySettingsCopyWithImpl<_PenaltySettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PenaltySettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PenaltySettings&&(identical(other.barberLateEnabled, barberLateEnabled) || other.barberLateEnabled == barberLateEnabled)&&(identical(other.barberLateGraceMinutes, barberLateGraceMinutes) || other.barberLateGraceMinutes == barberLateGraceMinutes)&&(identical(other.barberLateCalculationType, barberLateCalculationType) || other.barberLateCalculationType == barberLateCalculationType)&&(identical(other.barberLateValue, barberLateValue) || other.barberLateValue == barberLateValue)&&(identical(other.barberNoShowEnabled, barberNoShowEnabled) || other.barberNoShowEnabled == barberNoShowEnabled)&&(identical(other.barberNoShowCalculationType, barberNoShowCalculationType) || other.barberNoShowCalculationType == barberNoShowCalculationType)&&(identical(other.barberNoShowValue, barberNoShowValue) || other.barberNoShowValue == barberNoShowValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,barberLateEnabled,barberLateGraceMinutes,barberLateCalculationType,barberLateValue,barberNoShowEnabled,barberNoShowCalculationType,barberNoShowValue);

@override
String toString() {
  return 'PenaltySettings(barberLateEnabled: $barberLateEnabled, barberLateGraceMinutes: $barberLateGraceMinutes, barberLateCalculationType: $barberLateCalculationType, barberLateValue: $barberLateValue, barberNoShowEnabled: $barberNoShowEnabled, barberNoShowCalculationType: $barberNoShowCalculationType, barberNoShowValue: $barberNoShowValue)';
}


}

/// @nodoc
abstract mixin class _$PenaltySettingsCopyWith<$Res> implements $PenaltySettingsCopyWith<$Res> {
  factory _$PenaltySettingsCopyWith(_PenaltySettings value, $Res Function(_PenaltySettings) _then) = __$PenaltySettingsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: falseBoolFromJson) bool barberLateEnabled,@JsonKey(fromJson: _lateGraceMinutesFromJson) int barberLateGraceMinutes,@JsonKey(fromJson: _lateTypeFromJson) String barberLateCalculationType,@JsonKey(fromJson: looseDoubleFromJson) double barberLateValue,@JsonKey(fromJson: falseBoolFromJson) bool barberNoShowEnabled,@JsonKey(fromJson: _noShowTypeFromJson) String barberNoShowCalculationType,@JsonKey(fromJson: looseDoubleFromJson) double barberNoShowValue
});




}
/// @nodoc
class __$PenaltySettingsCopyWithImpl<$Res>
    implements _$PenaltySettingsCopyWith<$Res> {
  __$PenaltySettingsCopyWithImpl(this._self, this._then);

  final _PenaltySettings _self;
  final $Res Function(_PenaltySettings) _then;

/// Create a copy of PenaltySettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? barberLateEnabled = null,Object? barberLateGraceMinutes = null,Object? barberLateCalculationType = null,Object? barberLateValue = null,Object? barberNoShowEnabled = null,Object? barberNoShowCalculationType = null,Object? barberNoShowValue = null,}) {
  return _then(_PenaltySettings(
barberLateEnabled: null == barberLateEnabled ? _self.barberLateEnabled : barberLateEnabled // ignore: cast_nullable_to_non_nullable
as bool,barberLateGraceMinutes: null == barberLateGraceMinutes ? _self.barberLateGraceMinutes : barberLateGraceMinutes // ignore: cast_nullable_to_non_nullable
as int,barberLateCalculationType: null == barberLateCalculationType ? _self.barberLateCalculationType : barberLateCalculationType // ignore: cast_nullable_to_non_nullable
as String,barberLateValue: null == barberLateValue ? _self.barberLateValue : barberLateValue // ignore: cast_nullable_to_non_nullable
as double,barberNoShowEnabled: null == barberNoShowEnabled ? _self.barberNoShowEnabled : barberNoShowEnabled // ignore: cast_nullable_to_non_nullable
as bool,barberNoShowCalculationType: null == barberNoShowCalculationType ? _self.barberNoShowCalculationType : barberNoShowCalculationType // ignore: cast_nullable_to_non_nullable
as String,barberNoShowValue: null == barberNoShowValue ? _self.barberNoShowValue : barberNoShowValue // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
