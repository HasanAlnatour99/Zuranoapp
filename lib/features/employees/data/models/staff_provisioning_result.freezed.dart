// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'staff_provisioning_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StaffProvisioningResult {

 String get employeeId; String get uid; String get email;@JsonKey(fromJson: nullableLooseStringFromJson) String? get username;
/// Create a copy of StaffProvisioningResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StaffProvisioningResultCopyWith<StaffProvisioningResult> get copyWith => _$StaffProvisioningResultCopyWithImpl<StaffProvisioningResult>(this as StaffProvisioningResult, _$identity);

  /// Serializes this StaffProvisioningResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StaffProvisioningResult&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.email, email) || other.email == email)&&(identical(other.username, username) || other.username == username));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,employeeId,uid,email,username);

@override
String toString() {
  return 'StaffProvisioningResult(employeeId: $employeeId, uid: $uid, email: $email, username: $username)';
}


}

/// @nodoc
abstract mixin class $StaffProvisioningResultCopyWith<$Res>  {
  factory $StaffProvisioningResultCopyWith(StaffProvisioningResult value, $Res Function(StaffProvisioningResult) _then) = _$StaffProvisioningResultCopyWithImpl;
@useResult
$Res call({
 String employeeId, String uid, String email,@JsonKey(fromJson: nullableLooseStringFromJson) String? username
});




}
/// @nodoc
class _$StaffProvisioningResultCopyWithImpl<$Res>
    implements $StaffProvisioningResultCopyWith<$Res> {
  _$StaffProvisioningResultCopyWithImpl(this._self, this._then);

  final StaffProvisioningResult _self;
  final $Res Function(StaffProvisioningResult) _then;

/// Create a copy of StaffProvisioningResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? employeeId = null,Object? uid = null,Object? email = null,Object? username = freezed,}) {
  return _then(_self.copyWith(
employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StaffProvisioningResult].
extension StaffProvisioningResultPatterns on StaffProvisioningResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StaffProvisioningResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StaffProvisioningResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StaffProvisioningResult value)  $default,){
final _that = this;
switch (_that) {
case _StaffProvisioningResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StaffProvisioningResult value)?  $default,){
final _that = this;
switch (_that) {
case _StaffProvisioningResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String employeeId,  String uid,  String email, @JsonKey(fromJson: nullableLooseStringFromJson)  String? username)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StaffProvisioningResult() when $default != null:
return $default(_that.employeeId,_that.uid,_that.email,_that.username);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String employeeId,  String uid,  String email, @JsonKey(fromJson: nullableLooseStringFromJson)  String? username)  $default,) {final _that = this;
switch (_that) {
case _StaffProvisioningResult():
return $default(_that.employeeId,_that.uid,_that.email,_that.username);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String employeeId,  String uid,  String email, @JsonKey(fromJson: nullableLooseStringFromJson)  String? username)?  $default,) {final _that = this;
switch (_that) {
case _StaffProvisioningResult() when $default != null:
return $default(_that.employeeId,_that.uid,_that.email,_that.username);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StaffProvisioningResult implements StaffProvisioningResult {
  const _StaffProvisioningResult({required this.employeeId, required this.uid, required this.email, @JsonKey(fromJson: nullableLooseStringFromJson) this.username});
  factory _StaffProvisioningResult.fromJson(Map<String, dynamic> json) => _$StaffProvisioningResultFromJson(json);

@override final  String employeeId;
@override final  String uid;
@override final  String email;
@override@JsonKey(fromJson: nullableLooseStringFromJson) final  String? username;

/// Create a copy of StaffProvisioningResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StaffProvisioningResultCopyWith<_StaffProvisioningResult> get copyWith => __$StaffProvisioningResultCopyWithImpl<_StaffProvisioningResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StaffProvisioningResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StaffProvisioningResult&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.email, email) || other.email == email)&&(identical(other.username, username) || other.username == username));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,employeeId,uid,email,username);

@override
String toString() {
  return 'StaffProvisioningResult(employeeId: $employeeId, uid: $uid, email: $email, username: $username)';
}


}

/// @nodoc
abstract mixin class _$StaffProvisioningResultCopyWith<$Res> implements $StaffProvisioningResultCopyWith<$Res> {
  factory _$StaffProvisioningResultCopyWith(_StaffProvisioningResult value, $Res Function(_StaffProvisioningResult) _then) = __$StaffProvisioningResultCopyWithImpl;
@override @useResult
$Res call({
 String employeeId, String uid, String email,@JsonKey(fromJson: nullableLooseStringFromJson) String? username
});




}
/// @nodoc
class __$StaffProvisioningResultCopyWithImpl<$Res>
    implements _$StaffProvisioningResultCopyWith<$Res> {
  __$StaffProvisioningResultCopyWithImpl(this._self, this._then);

  final _StaffProvisioningResult _self;
  final $Res Function(_StaffProvisioningResult) _then;

/// Create a copy of StaffProvisioningResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? employeeId = null,Object? uid = null,Object? email = null,Object? username = freezed,}) {
  return _then(_StaffProvisioningResult(
employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
