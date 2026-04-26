// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppUser {

@JsonKey(fromJson: looseStringFromJson) String get uid;@JsonKey(fromJson: looseStringFromJson) String get email;@JsonKey(fromJson: looseStringFromJson) String get name;@JsonKey(fromJson: looseStringFromJson) String get role;@JsonKey(fromJson: trueBoolFromJson) bool get isActive;@JsonKey(fromJson: nullableLooseStringFromJson) String? get salonId;@JsonKey(fromJson: nullableLooseStringFromJson) String? get employeeId;@JsonKey(fromJson: nullableLooseStringFromJson) String? get username;@JsonKey(fromJson: nullableLooseStringFromJson) String? get usernameLower;@JsonKey(fromJson: nullableLooseStringFromJson) String? get photoUrl;@JsonKey(fromJson: nullableLooseStringFromJson) String? get authProvider;@JsonKey(fromJson: trueBoolFromJson) bool get onboardingCompleted;@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? get profileCompletedAt;@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? get createdAt;@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? get updatedAt;// Legacy / Other fields
@JsonKey(fromJson: nullableLooseStringFromJson) String? get onboardingStatus;@JsonKey(fromJson: _nullableBoolFromJson) bool? get salonCreationCompleted;@JsonKey(fromJson: _phoneFromJson, toJson: _phoneToJson) UserPhone? get phone;@JsonKey(fromJson: _addressFromJson, toJson: _addressToJson) UserAddress? get address;@JsonKey(fromJson: _notificationPrefsFromJson, toJson: _notificationPrefsToJson) UserNotificationPrefs? get notificationPrefs;@JsonKey(fromJson: _nullableBoolFromJson) bool? get mustChangePassword;
/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppUserCopyWith<AppUser> get copyWith => _$AppUserCopyWithImpl<AppUser>(this as AppUser, _$identity);

  /// Serializes this AppUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppUser&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.email, email) || other.email == email)&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.salonId, salonId) || other.salonId == salonId)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.username, username) || other.username == username)&&(identical(other.usernameLower, usernameLower) || other.usernameLower == usernameLower)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.authProvider, authProvider) || other.authProvider == authProvider)&&(identical(other.onboardingCompleted, onboardingCompleted) || other.onboardingCompleted == onboardingCompleted)&&(identical(other.profileCompletedAt, profileCompletedAt) || other.profileCompletedAt == profileCompletedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.onboardingStatus, onboardingStatus) || other.onboardingStatus == onboardingStatus)&&(identical(other.salonCreationCompleted, salonCreationCompleted) || other.salonCreationCompleted == salonCreationCompleted)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.address, address) || other.address == address)&&(identical(other.notificationPrefs, notificationPrefs) || other.notificationPrefs == notificationPrefs)&&(identical(other.mustChangePassword, mustChangePassword) || other.mustChangePassword == mustChangePassword));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,uid,email,name,role,isActive,salonId,employeeId,username,usernameLower,photoUrl,authProvider,onboardingCompleted,profileCompletedAt,createdAt,updatedAt,onboardingStatus,salonCreationCompleted,phone,address,notificationPrefs,mustChangePassword]);

@override
String toString() {
  return 'AppUser(uid: $uid, email: $email, name: $name, role: $role, isActive: $isActive, salonId: $salonId, employeeId: $employeeId, username: $username, usernameLower: $usernameLower, photoUrl: $photoUrl, authProvider: $authProvider, onboardingCompleted: $onboardingCompleted, profileCompletedAt: $profileCompletedAt, createdAt: $createdAt, updatedAt: $updatedAt, onboardingStatus: $onboardingStatus, salonCreationCompleted: $salonCreationCompleted, phone: $phone, address: $address, notificationPrefs: $notificationPrefs, mustChangePassword: $mustChangePassword)';
}


}

/// @nodoc
abstract mixin class $AppUserCopyWith<$Res>  {
  factory $AppUserCopyWith(AppUser value, $Res Function(AppUser) _then) = _$AppUserCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: looseStringFromJson) String uid,@JsonKey(fromJson: looseStringFromJson) String email,@JsonKey(fromJson: looseStringFromJson) String name,@JsonKey(fromJson: looseStringFromJson) String role,@JsonKey(fromJson: trueBoolFromJson) bool isActive,@JsonKey(fromJson: nullableLooseStringFromJson) String? salonId,@JsonKey(fromJson: nullableLooseStringFromJson) String? employeeId,@JsonKey(fromJson: nullableLooseStringFromJson) String? username,@JsonKey(fromJson: nullableLooseStringFromJson) String? usernameLower,@JsonKey(fromJson: nullableLooseStringFromJson) String? photoUrl,@JsonKey(fromJson: nullableLooseStringFromJson) String? authProvider,@JsonKey(fromJson: trueBoolFromJson) bool onboardingCompleted,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? profileCompletedAt,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? createdAt,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? updatedAt,@JsonKey(fromJson: nullableLooseStringFromJson) String? onboardingStatus,@JsonKey(fromJson: _nullableBoolFromJson) bool? salonCreationCompleted,@JsonKey(fromJson: _phoneFromJson, toJson: _phoneToJson) UserPhone? phone,@JsonKey(fromJson: _addressFromJson, toJson: _addressToJson) UserAddress? address,@JsonKey(fromJson: _notificationPrefsFromJson, toJson: _notificationPrefsToJson) UserNotificationPrefs? notificationPrefs,@JsonKey(fromJson: _nullableBoolFromJson) bool? mustChangePassword
});


$UserPhoneCopyWith<$Res>? get phone;$UserAddressCopyWith<$Res>? get address;$UserNotificationPrefsCopyWith<$Res>? get notificationPrefs;

}
/// @nodoc
class _$AppUserCopyWithImpl<$Res>
    implements $AppUserCopyWith<$Res> {
  _$AppUserCopyWithImpl(this._self, this._then);

  final AppUser _self;
  final $Res Function(AppUser) _then;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? email = null,Object? name = null,Object? role = null,Object? isActive = null,Object? salonId = freezed,Object? employeeId = freezed,Object? username = freezed,Object? usernameLower = freezed,Object? photoUrl = freezed,Object? authProvider = freezed,Object? onboardingCompleted = null,Object? profileCompletedAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? onboardingStatus = freezed,Object? salonCreationCompleted = freezed,Object? phone = freezed,Object? address = freezed,Object? notificationPrefs = freezed,Object? mustChangePassword = freezed,}) {
  return _then(_self.copyWith(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,salonId: freezed == salonId ? _self.salonId : salonId // ignore: cast_nullable_to_non_nullable
as String?,employeeId: freezed == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String?,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,usernameLower: freezed == usernameLower ? _self.usernameLower : usernameLower // ignore: cast_nullable_to_non_nullable
as String?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,authProvider: freezed == authProvider ? _self.authProvider : authProvider // ignore: cast_nullable_to_non_nullable
as String?,onboardingCompleted: null == onboardingCompleted ? _self.onboardingCompleted : onboardingCompleted // ignore: cast_nullable_to_non_nullable
as bool,profileCompletedAt: freezed == profileCompletedAt ? _self.profileCompletedAt : profileCompletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,onboardingStatus: freezed == onboardingStatus ? _self.onboardingStatus : onboardingStatus // ignore: cast_nullable_to_non_nullable
as String?,salonCreationCompleted: freezed == salonCreationCompleted ? _self.salonCreationCompleted : salonCreationCompleted // ignore: cast_nullable_to_non_nullable
as bool?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as UserPhone?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as UserAddress?,notificationPrefs: freezed == notificationPrefs ? _self.notificationPrefs : notificationPrefs // ignore: cast_nullable_to_non_nullable
as UserNotificationPrefs?,mustChangePassword: freezed == mustChangePassword ? _self.mustChangePassword : mustChangePassword // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}
/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserPhoneCopyWith<$Res>? get phone {
    if (_self.phone == null) {
    return null;
  }

  return $UserPhoneCopyWith<$Res>(_self.phone!, (value) {
    return _then(_self.copyWith(phone: value));
  });
}/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserAddressCopyWith<$Res>? get address {
    if (_self.address == null) {
    return null;
  }

  return $UserAddressCopyWith<$Res>(_self.address!, (value) {
    return _then(_self.copyWith(address: value));
  });
}/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserNotificationPrefsCopyWith<$Res>? get notificationPrefs {
    if (_self.notificationPrefs == null) {
    return null;
  }

  return $UserNotificationPrefsCopyWith<$Res>(_self.notificationPrefs!, (value) {
    return _then(_self.copyWith(notificationPrefs: value));
  });
}
}


/// Adds pattern-matching-related methods to [AppUser].
extension AppUserPatterns on AppUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppUser value)  $default,){
final _that = this;
switch (_that) {
case _AppUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppUser value)?  $default,){
final _that = this;
switch (_that) {
case _AppUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: looseStringFromJson)  String uid, @JsonKey(fromJson: looseStringFromJson)  String email, @JsonKey(fromJson: looseStringFromJson)  String name, @JsonKey(fromJson: looseStringFromJson)  String role, @JsonKey(fromJson: trueBoolFromJson)  bool isActive, @JsonKey(fromJson: nullableLooseStringFromJson)  String? salonId, @JsonKey(fromJson: nullableLooseStringFromJson)  String? employeeId, @JsonKey(fromJson: nullableLooseStringFromJson)  String? username, @JsonKey(fromJson: nullableLooseStringFromJson)  String? usernameLower, @JsonKey(fromJson: nullableLooseStringFromJson)  String? photoUrl, @JsonKey(fromJson: nullableLooseStringFromJson)  String? authProvider, @JsonKey(fromJson: trueBoolFromJson)  bool onboardingCompleted, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? profileCompletedAt, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? createdAt, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? updatedAt, @JsonKey(fromJson: nullableLooseStringFromJson)  String? onboardingStatus, @JsonKey(fromJson: _nullableBoolFromJson)  bool? salonCreationCompleted, @JsonKey(fromJson: _phoneFromJson, toJson: _phoneToJson)  UserPhone? phone, @JsonKey(fromJson: _addressFromJson, toJson: _addressToJson)  UserAddress? address, @JsonKey(fromJson: _notificationPrefsFromJson, toJson: _notificationPrefsToJson)  UserNotificationPrefs? notificationPrefs, @JsonKey(fromJson: _nullableBoolFromJson)  bool? mustChangePassword)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that.uid,_that.email,_that.name,_that.role,_that.isActive,_that.salonId,_that.employeeId,_that.username,_that.usernameLower,_that.photoUrl,_that.authProvider,_that.onboardingCompleted,_that.profileCompletedAt,_that.createdAt,_that.updatedAt,_that.onboardingStatus,_that.salonCreationCompleted,_that.phone,_that.address,_that.notificationPrefs,_that.mustChangePassword);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: looseStringFromJson)  String uid, @JsonKey(fromJson: looseStringFromJson)  String email, @JsonKey(fromJson: looseStringFromJson)  String name, @JsonKey(fromJson: looseStringFromJson)  String role, @JsonKey(fromJson: trueBoolFromJson)  bool isActive, @JsonKey(fromJson: nullableLooseStringFromJson)  String? salonId, @JsonKey(fromJson: nullableLooseStringFromJson)  String? employeeId, @JsonKey(fromJson: nullableLooseStringFromJson)  String? username, @JsonKey(fromJson: nullableLooseStringFromJson)  String? usernameLower, @JsonKey(fromJson: nullableLooseStringFromJson)  String? photoUrl, @JsonKey(fromJson: nullableLooseStringFromJson)  String? authProvider, @JsonKey(fromJson: trueBoolFromJson)  bool onboardingCompleted, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? profileCompletedAt, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? createdAt, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? updatedAt, @JsonKey(fromJson: nullableLooseStringFromJson)  String? onboardingStatus, @JsonKey(fromJson: _nullableBoolFromJson)  bool? salonCreationCompleted, @JsonKey(fromJson: _phoneFromJson, toJson: _phoneToJson)  UserPhone? phone, @JsonKey(fromJson: _addressFromJson, toJson: _addressToJson)  UserAddress? address, @JsonKey(fromJson: _notificationPrefsFromJson, toJson: _notificationPrefsToJson)  UserNotificationPrefs? notificationPrefs, @JsonKey(fromJson: _nullableBoolFromJson)  bool? mustChangePassword)  $default,) {final _that = this;
switch (_that) {
case _AppUser():
return $default(_that.uid,_that.email,_that.name,_that.role,_that.isActive,_that.salonId,_that.employeeId,_that.username,_that.usernameLower,_that.photoUrl,_that.authProvider,_that.onboardingCompleted,_that.profileCompletedAt,_that.createdAt,_that.updatedAt,_that.onboardingStatus,_that.salonCreationCompleted,_that.phone,_that.address,_that.notificationPrefs,_that.mustChangePassword);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: looseStringFromJson)  String uid, @JsonKey(fromJson: looseStringFromJson)  String email, @JsonKey(fromJson: looseStringFromJson)  String name, @JsonKey(fromJson: looseStringFromJson)  String role, @JsonKey(fromJson: trueBoolFromJson)  bool isActive, @JsonKey(fromJson: nullableLooseStringFromJson)  String? salonId, @JsonKey(fromJson: nullableLooseStringFromJson)  String? employeeId, @JsonKey(fromJson: nullableLooseStringFromJson)  String? username, @JsonKey(fromJson: nullableLooseStringFromJson)  String? usernameLower, @JsonKey(fromJson: nullableLooseStringFromJson)  String? photoUrl, @JsonKey(fromJson: nullableLooseStringFromJson)  String? authProvider, @JsonKey(fromJson: trueBoolFromJson)  bool onboardingCompleted, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? profileCompletedAt, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? createdAt, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? updatedAt, @JsonKey(fromJson: nullableLooseStringFromJson)  String? onboardingStatus, @JsonKey(fromJson: _nullableBoolFromJson)  bool? salonCreationCompleted, @JsonKey(fromJson: _phoneFromJson, toJson: _phoneToJson)  UserPhone? phone, @JsonKey(fromJson: _addressFromJson, toJson: _addressToJson)  UserAddress? address, @JsonKey(fromJson: _notificationPrefsFromJson, toJson: _notificationPrefsToJson)  UserNotificationPrefs? notificationPrefs, @JsonKey(fromJson: _nullableBoolFromJson)  bool? mustChangePassword)?  $default,) {final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that.uid,_that.email,_that.name,_that.role,_that.isActive,_that.salonId,_that.employeeId,_that.username,_that.usernameLower,_that.photoUrl,_that.authProvider,_that.onboardingCompleted,_that.profileCompletedAt,_that.createdAt,_that.updatedAt,_that.onboardingStatus,_that.salonCreationCompleted,_that.phone,_that.address,_that.notificationPrefs,_that.mustChangePassword);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppUser extends AppUser {
  const _AppUser({@JsonKey(fromJson: looseStringFromJson) required this.uid, @JsonKey(fromJson: looseStringFromJson) required this.email, @JsonKey(fromJson: looseStringFromJson) required this.name, @JsonKey(fromJson: looseStringFromJson) required this.role, @JsonKey(fromJson: trueBoolFromJson) this.isActive = true, @JsonKey(fromJson: nullableLooseStringFromJson) this.salonId, @JsonKey(fromJson: nullableLooseStringFromJson) this.employeeId, @JsonKey(fromJson: nullableLooseStringFromJson) this.username, @JsonKey(fromJson: nullableLooseStringFromJson) this.usernameLower, @JsonKey(fromJson: nullableLooseStringFromJson) this.photoUrl, @JsonKey(fromJson: nullableLooseStringFromJson) this.authProvider, @JsonKey(fromJson: trueBoolFromJson) this.onboardingCompleted = true, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) this.profileCompletedAt, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) this.createdAt, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) this.updatedAt, @JsonKey(fromJson: nullableLooseStringFromJson) this.onboardingStatus, @JsonKey(fromJson: _nullableBoolFromJson) this.salonCreationCompleted, @JsonKey(fromJson: _phoneFromJson, toJson: _phoneToJson) this.phone, @JsonKey(fromJson: _addressFromJson, toJson: _addressToJson) this.address, @JsonKey(fromJson: _notificationPrefsFromJson, toJson: _notificationPrefsToJson) this.notificationPrefs, @JsonKey(fromJson: _nullableBoolFromJson) this.mustChangePassword}): super._();
  factory _AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);

@override@JsonKey(fromJson: looseStringFromJson) final  String uid;
@override@JsonKey(fromJson: looseStringFromJson) final  String email;
@override@JsonKey(fromJson: looseStringFromJson) final  String name;
@override@JsonKey(fromJson: looseStringFromJson) final  String role;
@override@JsonKey(fromJson: trueBoolFromJson) final  bool isActive;
@override@JsonKey(fromJson: nullableLooseStringFromJson) final  String? salonId;
@override@JsonKey(fromJson: nullableLooseStringFromJson) final  String? employeeId;
@override@JsonKey(fromJson: nullableLooseStringFromJson) final  String? username;
@override@JsonKey(fromJson: nullableLooseStringFromJson) final  String? usernameLower;
@override@JsonKey(fromJson: nullableLooseStringFromJson) final  String? photoUrl;
@override@JsonKey(fromJson: nullableLooseStringFromJson) final  String? authProvider;
@override@JsonKey(fromJson: trueBoolFromJson) final  bool onboardingCompleted;
@override@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) final  DateTime? profileCompletedAt;
@override@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) final  DateTime? createdAt;
@override@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) final  DateTime? updatedAt;
// Legacy / Other fields
@override@JsonKey(fromJson: nullableLooseStringFromJson) final  String? onboardingStatus;
@override@JsonKey(fromJson: _nullableBoolFromJson) final  bool? salonCreationCompleted;
@override@JsonKey(fromJson: _phoneFromJson, toJson: _phoneToJson) final  UserPhone? phone;
@override@JsonKey(fromJson: _addressFromJson, toJson: _addressToJson) final  UserAddress? address;
@override@JsonKey(fromJson: _notificationPrefsFromJson, toJson: _notificationPrefsToJson) final  UserNotificationPrefs? notificationPrefs;
@override@JsonKey(fromJson: _nullableBoolFromJson) final  bool? mustChangePassword;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppUserCopyWith<_AppUser> get copyWith => __$AppUserCopyWithImpl<_AppUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppUserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppUser&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.email, email) || other.email == email)&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.salonId, salonId) || other.salonId == salonId)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.username, username) || other.username == username)&&(identical(other.usernameLower, usernameLower) || other.usernameLower == usernameLower)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.authProvider, authProvider) || other.authProvider == authProvider)&&(identical(other.onboardingCompleted, onboardingCompleted) || other.onboardingCompleted == onboardingCompleted)&&(identical(other.profileCompletedAt, profileCompletedAt) || other.profileCompletedAt == profileCompletedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.onboardingStatus, onboardingStatus) || other.onboardingStatus == onboardingStatus)&&(identical(other.salonCreationCompleted, salonCreationCompleted) || other.salonCreationCompleted == salonCreationCompleted)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.address, address) || other.address == address)&&(identical(other.notificationPrefs, notificationPrefs) || other.notificationPrefs == notificationPrefs)&&(identical(other.mustChangePassword, mustChangePassword) || other.mustChangePassword == mustChangePassword));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,uid,email,name,role,isActive,salonId,employeeId,username,usernameLower,photoUrl,authProvider,onboardingCompleted,profileCompletedAt,createdAt,updatedAt,onboardingStatus,salonCreationCompleted,phone,address,notificationPrefs,mustChangePassword]);

@override
String toString() {
  return 'AppUser(uid: $uid, email: $email, name: $name, role: $role, isActive: $isActive, salonId: $salonId, employeeId: $employeeId, username: $username, usernameLower: $usernameLower, photoUrl: $photoUrl, authProvider: $authProvider, onboardingCompleted: $onboardingCompleted, profileCompletedAt: $profileCompletedAt, createdAt: $createdAt, updatedAt: $updatedAt, onboardingStatus: $onboardingStatus, salonCreationCompleted: $salonCreationCompleted, phone: $phone, address: $address, notificationPrefs: $notificationPrefs, mustChangePassword: $mustChangePassword)';
}


}

/// @nodoc
abstract mixin class _$AppUserCopyWith<$Res> implements $AppUserCopyWith<$Res> {
  factory _$AppUserCopyWith(_AppUser value, $Res Function(_AppUser) _then) = __$AppUserCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: looseStringFromJson) String uid,@JsonKey(fromJson: looseStringFromJson) String email,@JsonKey(fromJson: looseStringFromJson) String name,@JsonKey(fromJson: looseStringFromJson) String role,@JsonKey(fromJson: trueBoolFromJson) bool isActive,@JsonKey(fromJson: nullableLooseStringFromJson) String? salonId,@JsonKey(fromJson: nullableLooseStringFromJson) String? employeeId,@JsonKey(fromJson: nullableLooseStringFromJson) String? username,@JsonKey(fromJson: nullableLooseStringFromJson) String? usernameLower,@JsonKey(fromJson: nullableLooseStringFromJson) String? photoUrl,@JsonKey(fromJson: nullableLooseStringFromJson) String? authProvider,@JsonKey(fromJson: trueBoolFromJson) bool onboardingCompleted,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? profileCompletedAt,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? createdAt,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? updatedAt,@JsonKey(fromJson: nullableLooseStringFromJson) String? onboardingStatus,@JsonKey(fromJson: _nullableBoolFromJson) bool? salonCreationCompleted,@JsonKey(fromJson: _phoneFromJson, toJson: _phoneToJson) UserPhone? phone,@JsonKey(fromJson: _addressFromJson, toJson: _addressToJson) UserAddress? address,@JsonKey(fromJson: _notificationPrefsFromJson, toJson: _notificationPrefsToJson) UserNotificationPrefs? notificationPrefs,@JsonKey(fromJson: _nullableBoolFromJson) bool? mustChangePassword
});


@override $UserPhoneCopyWith<$Res>? get phone;@override $UserAddressCopyWith<$Res>? get address;@override $UserNotificationPrefsCopyWith<$Res>? get notificationPrefs;

}
/// @nodoc
class __$AppUserCopyWithImpl<$Res>
    implements _$AppUserCopyWith<$Res> {
  __$AppUserCopyWithImpl(this._self, this._then);

  final _AppUser _self;
  final $Res Function(_AppUser) _then;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? email = null,Object? name = null,Object? role = null,Object? isActive = null,Object? salonId = freezed,Object? employeeId = freezed,Object? username = freezed,Object? usernameLower = freezed,Object? photoUrl = freezed,Object? authProvider = freezed,Object? onboardingCompleted = null,Object? profileCompletedAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? onboardingStatus = freezed,Object? salonCreationCompleted = freezed,Object? phone = freezed,Object? address = freezed,Object? notificationPrefs = freezed,Object? mustChangePassword = freezed,}) {
  return _then(_AppUser(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,salonId: freezed == salonId ? _self.salonId : salonId // ignore: cast_nullable_to_non_nullable
as String?,employeeId: freezed == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String?,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,usernameLower: freezed == usernameLower ? _self.usernameLower : usernameLower // ignore: cast_nullable_to_non_nullable
as String?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,authProvider: freezed == authProvider ? _self.authProvider : authProvider // ignore: cast_nullable_to_non_nullable
as String?,onboardingCompleted: null == onboardingCompleted ? _self.onboardingCompleted : onboardingCompleted // ignore: cast_nullable_to_non_nullable
as bool,profileCompletedAt: freezed == profileCompletedAt ? _self.profileCompletedAt : profileCompletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,onboardingStatus: freezed == onboardingStatus ? _self.onboardingStatus : onboardingStatus // ignore: cast_nullable_to_non_nullable
as String?,salonCreationCompleted: freezed == salonCreationCompleted ? _self.salonCreationCompleted : salonCreationCompleted // ignore: cast_nullable_to_non_nullable
as bool?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as UserPhone?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as UserAddress?,notificationPrefs: freezed == notificationPrefs ? _self.notificationPrefs : notificationPrefs // ignore: cast_nullable_to_non_nullable
as UserNotificationPrefs?,mustChangePassword: freezed == mustChangePassword ? _self.mustChangePassword : mustChangePassword // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserPhoneCopyWith<$Res>? get phone {
    if (_self.phone == null) {
    return null;
  }

  return $UserPhoneCopyWith<$Res>(_self.phone!, (value) {
    return _then(_self.copyWith(phone: value));
  });
}/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserAddressCopyWith<$Res>? get address {
    if (_self.address == null) {
    return null;
  }

  return $UserAddressCopyWith<$Res>(_self.address!, (value) {
    return _then(_self.copyWith(address: value));
  });
}/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserNotificationPrefsCopyWith<$Res>? get notificationPrefs {
    if (_self.notificationPrefs == null) {
    return null;
  }

  return $UserNotificationPrefsCopyWith<$Res>(_self.notificationPrefs!, (value) {
    return _then(_self.copyWith(notificationPrefs: value));
  });
}
}

// dart format on
