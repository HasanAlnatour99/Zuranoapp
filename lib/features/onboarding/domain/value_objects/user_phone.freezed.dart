// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_phone.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserPhone {

 String get countryIsoCode; String get dialCode; String get nationalNumber; String get e164;
/// Create a copy of UserPhone
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserPhoneCopyWith<UserPhone> get copyWith => _$UserPhoneCopyWithImpl<UserPhone>(this as UserPhone, _$identity);

  /// Serializes this UserPhone to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserPhone&&(identical(other.countryIsoCode, countryIsoCode) || other.countryIsoCode == countryIsoCode)&&(identical(other.dialCode, dialCode) || other.dialCode == dialCode)&&(identical(other.nationalNumber, nationalNumber) || other.nationalNumber == nationalNumber)&&(identical(other.e164, e164) || other.e164 == e164));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,countryIsoCode,dialCode,nationalNumber,e164);

@override
String toString() {
  return 'UserPhone(countryIsoCode: $countryIsoCode, dialCode: $dialCode, nationalNumber: $nationalNumber, e164: $e164)';
}


}

/// @nodoc
abstract mixin class $UserPhoneCopyWith<$Res>  {
  factory $UserPhoneCopyWith(UserPhone value, $Res Function(UserPhone) _then) = _$UserPhoneCopyWithImpl;
@useResult
$Res call({
 String countryIsoCode, String dialCode, String nationalNumber, String e164
});




}
/// @nodoc
class _$UserPhoneCopyWithImpl<$Res>
    implements $UserPhoneCopyWith<$Res> {
  _$UserPhoneCopyWithImpl(this._self, this._then);

  final UserPhone _self;
  final $Res Function(UserPhone) _then;

/// Create a copy of UserPhone
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? countryIsoCode = null,Object? dialCode = null,Object? nationalNumber = null,Object? e164 = null,}) {
  return _then(_self.copyWith(
countryIsoCode: null == countryIsoCode ? _self.countryIsoCode : countryIsoCode // ignore: cast_nullable_to_non_nullable
as String,dialCode: null == dialCode ? _self.dialCode : dialCode // ignore: cast_nullable_to_non_nullable
as String,nationalNumber: null == nationalNumber ? _self.nationalNumber : nationalNumber // ignore: cast_nullable_to_non_nullable
as String,e164: null == e164 ? _self.e164 : e164 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UserPhone].
extension UserPhonePatterns on UserPhone {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserPhone value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserPhone() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserPhone value)  $default,){
final _that = this;
switch (_that) {
case _UserPhone():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserPhone value)?  $default,){
final _that = this;
switch (_that) {
case _UserPhone() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String countryIsoCode,  String dialCode,  String nationalNumber,  String e164)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserPhone() when $default != null:
return $default(_that.countryIsoCode,_that.dialCode,_that.nationalNumber,_that.e164);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String countryIsoCode,  String dialCode,  String nationalNumber,  String e164)  $default,) {final _that = this;
switch (_that) {
case _UserPhone():
return $default(_that.countryIsoCode,_that.dialCode,_that.nationalNumber,_that.e164);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String countryIsoCode,  String dialCode,  String nationalNumber,  String e164)?  $default,) {final _that = this;
switch (_that) {
case _UserPhone() when $default != null:
return $default(_that.countryIsoCode,_that.dialCode,_that.nationalNumber,_that.e164);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserPhone extends UserPhone {
  const _UserPhone({required this.countryIsoCode, required this.dialCode, required this.nationalNumber, required this.e164}): super._();
  factory _UserPhone.fromJson(Map<String, dynamic> json) => _$UserPhoneFromJson(json);

@override final  String countryIsoCode;
@override final  String dialCode;
@override final  String nationalNumber;
@override final  String e164;

/// Create a copy of UserPhone
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserPhoneCopyWith<_UserPhone> get copyWith => __$UserPhoneCopyWithImpl<_UserPhone>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserPhoneToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserPhone&&(identical(other.countryIsoCode, countryIsoCode) || other.countryIsoCode == countryIsoCode)&&(identical(other.dialCode, dialCode) || other.dialCode == dialCode)&&(identical(other.nationalNumber, nationalNumber) || other.nationalNumber == nationalNumber)&&(identical(other.e164, e164) || other.e164 == e164));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,countryIsoCode,dialCode,nationalNumber,e164);

@override
String toString() {
  return 'UserPhone(countryIsoCode: $countryIsoCode, dialCode: $dialCode, nationalNumber: $nationalNumber, e164: $e164)';
}


}

/// @nodoc
abstract mixin class _$UserPhoneCopyWith<$Res> implements $UserPhoneCopyWith<$Res> {
  factory _$UserPhoneCopyWith(_UserPhone value, $Res Function(_UserPhone) _then) = __$UserPhoneCopyWithImpl;
@override @useResult
$Res call({
 String countryIsoCode, String dialCode, String nationalNumber, String e164
});




}
/// @nodoc
class __$UserPhoneCopyWithImpl<$Res>
    implements _$UserPhoneCopyWith<$Res> {
  __$UserPhoneCopyWithImpl(this._self, this._then);

  final _UserPhone _self;
  final $Res Function(_UserPhone) _then;

/// Create a copy of UserPhone
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? countryIsoCode = null,Object? dialCode = null,Object? nationalNumber = null,Object? e164 = null,}) {
  return _then(_UserPhone(
countryIsoCode: null == countryIsoCode ? _self.countryIsoCode : countryIsoCode // ignore: cast_nullable_to_non_nullable
as String,dialCode: null == dialCode ? _self.dialCode : dialCode // ignore: cast_nullable_to_non_nullable
as String,nationalNumber: null == nationalNumber ? _self.nationalNumber : nationalNumber // ignore: cast_nullable_to_non_nullable
as String,e164: null == e164 ? _self.e164 : e164 // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
