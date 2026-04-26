// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_notification_prefs.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserNotificationPrefs {

@JsonKey(fromJson: trueBoolFromJson) bool get pushEnabled;@JsonKey(fromJson: trueBoolFromJson) bool get bookingReminders;@JsonKey(fromJson: trueBoolFromJson) bool get bookingChanges;@JsonKey(fromJson: trueBoolFromJson) bool get payrollAlerts;@JsonKey(fromJson: trueBoolFromJson) bool get violationAlerts;@JsonKey(fromJson: falseBoolFromJson) bool get marketingEnabled;
/// Create a copy of UserNotificationPrefs
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserNotificationPrefsCopyWith<UserNotificationPrefs> get copyWith => _$UserNotificationPrefsCopyWithImpl<UserNotificationPrefs>(this as UserNotificationPrefs, _$identity);

  /// Serializes this UserNotificationPrefs to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserNotificationPrefs&&(identical(other.pushEnabled, pushEnabled) || other.pushEnabled == pushEnabled)&&(identical(other.bookingReminders, bookingReminders) || other.bookingReminders == bookingReminders)&&(identical(other.bookingChanges, bookingChanges) || other.bookingChanges == bookingChanges)&&(identical(other.payrollAlerts, payrollAlerts) || other.payrollAlerts == payrollAlerts)&&(identical(other.violationAlerts, violationAlerts) || other.violationAlerts == violationAlerts)&&(identical(other.marketingEnabled, marketingEnabled) || other.marketingEnabled == marketingEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pushEnabled,bookingReminders,bookingChanges,payrollAlerts,violationAlerts,marketingEnabled);

@override
String toString() {
  return 'UserNotificationPrefs(pushEnabled: $pushEnabled, bookingReminders: $bookingReminders, bookingChanges: $bookingChanges, payrollAlerts: $payrollAlerts, violationAlerts: $violationAlerts, marketingEnabled: $marketingEnabled)';
}


}

/// @nodoc
abstract mixin class $UserNotificationPrefsCopyWith<$Res>  {
  factory $UserNotificationPrefsCopyWith(UserNotificationPrefs value, $Res Function(UserNotificationPrefs) _then) = _$UserNotificationPrefsCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: trueBoolFromJson) bool pushEnabled,@JsonKey(fromJson: trueBoolFromJson) bool bookingReminders,@JsonKey(fromJson: trueBoolFromJson) bool bookingChanges,@JsonKey(fromJson: trueBoolFromJson) bool payrollAlerts,@JsonKey(fromJson: trueBoolFromJson) bool violationAlerts,@JsonKey(fromJson: falseBoolFromJson) bool marketingEnabled
});




}
/// @nodoc
class _$UserNotificationPrefsCopyWithImpl<$Res>
    implements $UserNotificationPrefsCopyWith<$Res> {
  _$UserNotificationPrefsCopyWithImpl(this._self, this._then);

  final UserNotificationPrefs _self;
  final $Res Function(UserNotificationPrefs) _then;

/// Create a copy of UserNotificationPrefs
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pushEnabled = null,Object? bookingReminders = null,Object? bookingChanges = null,Object? payrollAlerts = null,Object? violationAlerts = null,Object? marketingEnabled = null,}) {
  return _then(_self.copyWith(
pushEnabled: null == pushEnabled ? _self.pushEnabled : pushEnabled // ignore: cast_nullable_to_non_nullable
as bool,bookingReminders: null == bookingReminders ? _self.bookingReminders : bookingReminders // ignore: cast_nullable_to_non_nullable
as bool,bookingChanges: null == bookingChanges ? _self.bookingChanges : bookingChanges // ignore: cast_nullable_to_non_nullable
as bool,payrollAlerts: null == payrollAlerts ? _self.payrollAlerts : payrollAlerts // ignore: cast_nullable_to_non_nullable
as bool,violationAlerts: null == violationAlerts ? _self.violationAlerts : violationAlerts // ignore: cast_nullable_to_non_nullable
as bool,marketingEnabled: null == marketingEnabled ? _self.marketingEnabled : marketingEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UserNotificationPrefs].
extension UserNotificationPrefsPatterns on UserNotificationPrefs {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserNotificationPrefs value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserNotificationPrefs() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserNotificationPrefs value)  $default,){
final _that = this;
switch (_that) {
case _UserNotificationPrefs():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserNotificationPrefs value)?  $default,){
final _that = this;
switch (_that) {
case _UserNotificationPrefs() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: trueBoolFromJson)  bool pushEnabled, @JsonKey(fromJson: trueBoolFromJson)  bool bookingReminders, @JsonKey(fromJson: trueBoolFromJson)  bool bookingChanges, @JsonKey(fromJson: trueBoolFromJson)  bool payrollAlerts, @JsonKey(fromJson: trueBoolFromJson)  bool violationAlerts, @JsonKey(fromJson: falseBoolFromJson)  bool marketingEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserNotificationPrefs() when $default != null:
return $default(_that.pushEnabled,_that.bookingReminders,_that.bookingChanges,_that.payrollAlerts,_that.violationAlerts,_that.marketingEnabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: trueBoolFromJson)  bool pushEnabled, @JsonKey(fromJson: trueBoolFromJson)  bool bookingReminders, @JsonKey(fromJson: trueBoolFromJson)  bool bookingChanges, @JsonKey(fromJson: trueBoolFromJson)  bool payrollAlerts, @JsonKey(fromJson: trueBoolFromJson)  bool violationAlerts, @JsonKey(fromJson: falseBoolFromJson)  bool marketingEnabled)  $default,) {final _that = this;
switch (_that) {
case _UserNotificationPrefs():
return $default(_that.pushEnabled,_that.bookingReminders,_that.bookingChanges,_that.payrollAlerts,_that.violationAlerts,_that.marketingEnabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: trueBoolFromJson)  bool pushEnabled, @JsonKey(fromJson: trueBoolFromJson)  bool bookingReminders, @JsonKey(fromJson: trueBoolFromJson)  bool bookingChanges, @JsonKey(fromJson: trueBoolFromJson)  bool payrollAlerts, @JsonKey(fromJson: trueBoolFromJson)  bool violationAlerts, @JsonKey(fromJson: falseBoolFromJson)  bool marketingEnabled)?  $default,) {final _that = this;
switch (_that) {
case _UserNotificationPrefs() when $default != null:
return $default(_that.pushEnabled,_that.bookingReminders,_that.bookingChanges,_that.payrollAlerts,_that.violationAlerts,_that.marketingEnabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserNotificationPrefs extends UserNotificationPrefs {
  const _UserNotificationPrefs({@JsonKey(fromJson: trueBoolFromJson) this.pushEnabled = true, @JsonKey(fromJson: trueBoolFromJson) this.bookingReminders = true, @JsonKey(fromJson: trueBoolFromJson) this.bookingChanges = true, @JsonKey(fromJson: trueBoolFromJson) this.payrollAlerts = true, @JsonKey(fromJson: trueBoolFromJson) this.violationAlerts = true, @JsonKey(fromJson: falseBoolFromJson) this.marketingEnabled = false}): super._();
  factory _UserNotificationPrefs.fromJson(Map<String, dynamic> json) => _$UserNotificationPrefsFromJson(json);

@override@JsonKey(fromJson: trueBoolFromJson) final  bool pushEnabled;
@override@JsonKey(fromJson: trueBoolFromJson) final  bool bookingReminders;
@override@JsonKey(fromJson: trueBoolFromJson) final  bool bookingChanges;
@override@JsonKey(fromJson: trueBoolFromJson) final  bool payrollAlerts;
@override@JsonKey(fromJson: trueBoolFromJson) final  bool violationAlerts;
@override@JsonKey(fromJson: falseBoolFromJson) final  bool marketingEnabled;

/// Create a copy of UserNotificationPrefs
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserNotificationPrefsCopyWith<_UserNotificationPrefs> get copyWith => __$UserNotificationPrefsCopyWithImpl<_UserNotificationPrefs>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserNotificationPrefsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserNotificationPrefs&&(identical(other.pushEnabled, pushEnabled) || other.pushEnabled == pushEnabled)&&(identical(other.bookingReminders, bookingReminders) || other.bookingReminders == bookingReminders)&&(identical(other.bookingChanges, bookingChanges) || other.bookingChanges == bookingChanges)&&(identical(other.payrollAlerts, payrollAlerts) || other.payrollAlerts == payrollAlerts)&&(identical(other.violationAlerts, violationAlerts) || other.violationAlerts == violationAlerts)&&(identical(other.marketingEnabled, marketingEnabled) || other.marketingEnabled == marketingEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pushEnabled,bookingReminders,bookingChanges,payrollAlerts,violationAlerts,marketingEnabled);

@override
String toString() {
  return 'UserNotificationPrefs(pushEnabled: $pushEnabled, bookingReminders: $bookingReminders, bookingChanges: $bookingChanges, payrollAlerts: $payrollAlerts, violationAlerts: $violationAlerts, marketingEnabled: $marketingEnabled)';
}


}

/// @nodoc
abstract mixin class _$UserNotificationPrefsCopyWith<$Res> implements $UserNotificationPrefsCopyWith<$Res> {
  factory _$UserNotificationPrefsCopyWith(_UserNotificationPrefs value, $Res Function(_UserNotificationPrefs) _then) = __$UserNotificationPrefsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: trueBoolFromJson) bool pushEnabled,@JsonKey(fromJson: trueBoolFromJson) bool bookingReminders,@JsonKey(fromJson: trueBoolFromJson) bool bookingChanges,@JsonKey(fromJson: trueBoolFromJson) bool payrollAlerts,@JsonKey(fromJson: trueBoolFromJson) bool violationAlerts,@JsonKey(fromJson: falseBoolFromJson) bool marketingEnabled
});




}
/// @nodoc
class __$UserNotificationPrefsCopyWithImpl<$Res>
    implements _$UserNotificationPrefsCopyWith<$Res> {
  __$UserNotificationPrefsCopyWithImpl(this._self, this._then);

  final _UserNotificationPrefs _self;
  final $Res Function(_UserNotificationPrefs) _then;

/// Create a copy of UserNotificationPrefs
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pushEnabled = null,Object? bookingReminders = null,Object? bookingChanges = null,Object? payrollAlerts = null,Object? violationAlerts = null,Object? marketingEnabled = null,}) {
  return _then(_UserNotificationPrefs(
pushEnabled: null == pushEnabled ? _self.pushEnabled : pushEnabled // ignore: cast_nullable_to_non_nullable
as bool,bookingReminders: null == bookingReminders ? _self.bookingReminders : bookingReminders // ignore: cast_nullable_to_non_nullable
as bool,bookingChanges: null == bookingChanges ? _self.bookingChanges : bookingChanges // ignore: cast_nullable_to_non_nullable
as bool,payrollAlerts: null == payrollAlerts ? _self.payrollAlerts : payrollAlerts // ignore: cast_nullable_to_non_nullable
as bool,violationAlerts: null == violationAlerts ? _self.violationAlerts : violationAlerts // ignore: cast_nullable_to_non_nullable
as bool,marketingEnabled: null == marketingEnabled ? _self.marketingEnabled : marketingEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
