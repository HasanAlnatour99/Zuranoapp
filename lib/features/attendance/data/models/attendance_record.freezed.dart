// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendance_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AttendanceRecord {

@JsonKey(fromJson: looseStringFromJson) String get id;@JsonKey(fromJson: looseStringFromJson) String get salonId;@JsonKey(fromJson: looseStringFromJson) String get employeeId;@JsonKey(fromJson: looseStringFromJson) String get employeeName;@JsonKey(fromJson: firestoreDateTimeFromJson, toJson: firestoreDateTimeToJson) DateTime get workDate;@JsonKey(fromJson: looseStringFromJson) String get dateKey;@JsonKey(fromJson: _statusFromJson) String get status;@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? get checkInAt;@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? get checkOutAt;@JsonKey(fromJson: looseIntFromJson) int get minutesLate;@JsonKey(fromJson: falseBoolFromJson) bool get needsCorrection;@JsonKey(fromJson: nullableLooseStringFromJson) String? get notes;@JsonKey(fromJson: _approvalStatusFromJson) String get approvalStatus;@JsonKey(fromJson: nullableLooseStringFromJson) String? get approvedByUid;@JsonKey(fromJson: nullableLooseStringFromJson) String? get approvedByName;@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? get approvedAt;@JsonKey(fromJson: nullableLooseStringFromJson) String? get rejectionReason;@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? get createdAt;@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? get updatedAt;
/// Create a copy of AttendanceRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceRecordCopyWith<AttendanceRecord> get copyWith => _$AttendanceRecordCopyWithImpl<AttendanceRecord>(this as AttendanceRecord, _$identity);

  /// Serializes this AttendanceRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendanceRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.salonId, salonId) || other.salonId == salonId)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.employeeName, employeeName) || other.employeeName == employeeName)&&(identical(other.workDate, workDate) || other.workDate == workDate)&&(identical(other.dateKey, dateKey) || other.dateKey == dateKey)&&(identical(other.status, status) || other.status == status)&&(identical(other.checkInAt, checkInAt) || other.checkInAt == checkInAt)&&(identical(other.checkOutAt, checkOutAt) || other.checkOutAt == checkOutAt)&&(identical(other.minutesLate, minutesLate) || other.minutesLate == minutesLate)&&(identical(other.needsCorrection, needsCorrection) || other.needsCorrection == needsCorrection)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.approvalStatus, approvalStatus) || other.approvalStatus == approvalStatus)&&(identical(other.approvedByUid, approvedByUid) || other.approvedByUid == approvedByUid)&&(identical(other.approvedByName, approvedByName) || other.approvedByName == approvedByName)&&(identical(other.approvedAt, approvedAt) || other.approvedAt == approvedAt)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,salonId,employeeId,employeeName,workDate,dateKey,status,checkInAt,checkOutAt,minutesLate,needsCorrection,notes,approvalStatus,approvedByUid,approvedByName,approvedAt,rejectionReason,createdAt,updatedAt]);

@override
String toString() {
  return 'AttendanceRecord(id: $id, salonId: $salonId, employeeId: $employeeId, employeeName: $employeeName, workDate: $workDate, dateKey: $dateKey, status: $status, checkInAt: $checkInAt, checkOutAt: $checkOutAt, minutesLate: $minutesLate, needsCorrection: $needsCorrection, notes: $notes, approvalStatus: $approvalStatus, approvedByUid: $approvedByUid, approvedByName: $approvedByName, approvedAt: $approvedAt, rejectionReason: $rejectionReason, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $AttendanceRecordCopyWith<$Res>  {
  factory $AttendanceRecordCopyWith(AttendanceRecord value, $Res Function(AttendanceRecord) _then) = _$AttendanceRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: looseStringFromJson) String id,@JsonKey(fromJson: looseStringFromJson) String salonId,@JsonKey(fromJson: looseStringFromJson) String employeeId,@JsonKey(fromJson: looseStringFromJson) String employeeName,@JsonKey(fromJson: firestoreDateTimeFromJson, toJson: firestoreDateTimeToJson) DateTime workDate,@JsonKey(fromJson: looseStringFromJson) String dateKey,@JsonKey(fromJson: _statusFromJson) String status,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? checkInAt,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? checkOutAt,@JsonKey(fromJson: looseIntFromJson) int minutesLate,@JsonKey(fromJson: falseBoolFromJson) bool needsCorrection,@JsonKey(fromJson: nullableLooseStringFromJson) String? notes,@JsonKey(fromJson: _approvalStatusFromJson) String approvalStatus,@JsonKey(fromJson: nullableLooseStringFromJson) String? approvedByUid,@JsonKey(fromJson: nullableLooseStringFromJson) String? approvedByName,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? approvedAt,@JsonKey(fromJson: nullableLooseStringFromJson) String? rejectionReason,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? createdAt,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? updatedAt
});




}
/// @nodoc
class _$AttendanceRecordCopyWithImpl<$Res>
    implements $AttendanceRecordCopyWith<$Res> {
  _$AttendanceRecordCopyWithImpl(this._self, this._then);

  final AttendanceRecord _self;
  final $Res Function(AttendanceRecord) _then;

/// Create a copy of AttendanceRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? salonId = null,Object? employeeId = null,Object? employeeName = null,Object? workDate = null,Object? dateKey = null,Object? status = null,Object? checkInAt = freezed,Object? checkOutAt = freezed,Object? minutesLate = null,Object? needsCorrection = null,Object? notes = freezed,Object? approvalStatus = null,Object? approvedByUid = freezed,Object? approvedByName = freezed,Object? approvedAt = freezed,Object? rejectionReason = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,salonId: null == salonId ? _self.salonId : salonId // ignore: cast_nullable_to_non_nullable
as String,employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String,employeeName: null == employeeName ? _self.employeeName : employeeName // ignore: cast_nullable_to_non_nullable
as String,workDate: null == workDate ? _self.workDate : workDate // ignore: cast_nullable_to_non_nullable
as DateTime,dateKey: null == dateKey ? _self.dateKey : dateKey // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,checkInAt: freezed == checkInAt ? _self.checkInAt : checkInAt // ignore: cast_nullable_to_non_nullable
as DateTime?,checkOutAt: freezed == checkOutAt ? _self.checkOutAt : checkOutAt // ignore: cast_nullable_to_non_nullable
as DateTime?,minutesLate: null == minutesLate ? _self.minutesLate : minutesLate // ignore: cast_nullable_to_non_nullable
as int,needsCorrection: null == needsCorrection ? _self.needsCorrection : needsCorrection // ignore: cast_nullable_to_non_nullable
as bool,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,approvalStatus: null == approvalStatus ? _self.approvalStatus : approvalStatus // ignore: cast_nullable_to_non_nullable
as String,approvedByUid: freezed == approvedByUid ? _self.approvedByUid : approvedByUid // ignore: cast_nullable_to_non_nullable
as String?,approvedByName: freezed == approvedByName ? _self.approvedByName : approvedByName // ignore: cast_nullable_to_non_nullable
as String?,approvedAt: freezed == approvedAt ? _self.approvedAt : approvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AttendanceRecord].
extension AttendanceRecordPatterns on AttendanceRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendanceRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendanceRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendanceRecord value)  $default,){
final _that = this;
switch (_that) {
case _AttendanceRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendanceRecord value)?  $default,){
final _that = this;
switch (_that) {
case _AttendanceRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: looseStringFromJson)  String id, @JsonKey(fromJson: looseStringFromJson)  String salonId, @JsonKey(fromJson: looseStringFromJson)  String employeeId, @JsonKey(fromJson: looseStringFromJson)  String employeeName, @JsonKey(fromJson: firestoreDateTimeFromJson, toJson: firestoreDateTimeToJson)  DateTime workDate, @JsonKey(fromJson: looseStringFromJson)  String dateKey, @JsonKey(fromJson: _statusFromJson)  String status, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? checkInAt, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? checkOutAt, @JsonKey(fromJson: looseIntFromJson)  int minutesLate, @JsonKey(fromJson: falseBoolFromJson)  bool needsCorrection, @JsonKey(fromJson: nullableLooseStringFromJson)  String? notes, @JsonKey(fromJson: _approvalStatusFromJson)  String approvalStatus, @JsonKey(fromJson: nullableLooseStringFromJson)  String? approvedByUid, @JsonKey(fromJson: nullableLooseStringFromJson)  String? approvedByName, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? approvedAt, @JsonKey(fromJson: nullableLooseStringFromJson)  String? rejectionReason, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? createdAt, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendanceRecord() when $default != null:
return $default(_that.id,_that.salonId,_that.employeeId,_that.employeeName,_that.workDate,_that.dateKey,_that.status,_that.checkInAt,_that.checkOutAt,_that.minutesLate,_that.needsCorrection,_that.notes,_that.approvalStatus,_that.approvedByUid,_that.approvedByName,_that.approvedAt,_that.rejectionReason,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: looseStringFromJson)  String id, @JsonKey(fromJson: looseStringFromJson)  String salonId, @JsonKey(fromJson: looseStringFromJson)  String employeeId, @JsonKey(fromJson: looseStringFromJson)  String employeeName, @JsonKey(fromJson: firestoreDateTimeFromJson, toJson: firestoreDateTimeToJson)  DateTime workDate, @JsonKey(fromJson: looseStringFromJson)  String dateKey, @JsonKey(fromJson: _statusFromJson)  String status, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? checkInAt, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? checkOutAt, @JsonKey(fromJson: looseIntFromJson)  int minutesLate, @JsonKey(fromJson: falseBoolFromJson)  bool needsCorrection, @JsonKey(fromJson: nullableLooseStringFromJson)  String? notes, @JsonKey(fromJson: _approvalStatusFromJson)  String approvalStatus, @JsonKey(fromJson: nullableLooseStringFromJson)  String? approvedByUid, @JsonKey(fromJson: nullableLooseStringFromJson)  String? approvedByName, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? approvedAt, @JsonKey(fromJson: nullableLooseStringFromJson)  String? rejectionReason, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? createdAt, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _AttendanceRecord():
return $default(_that.id,_that.salonId,_that.employeeId,_that.employeeName,_that.workDate,_that.dateKey,_that.status,_that.checkInAt,_that.checkOutAt,_that.minutesLate,_that.needsCorrection,_that.notes,_that.approvalStatus,_that.approvedByUid,_that.approvedByName,_that.approvedAt,_that.rejectionReason,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: looseStringFromJson)  String id, @JsonKey(fromJson: looseStringFromJson)  String salonId, @JsonKey(fromJson: looseStringFromJson)  String employeeId, @JsonKey(fromJson: looseStringFromJson)  String employeeName, @JsonKey(fromJson: firestoreDateTimeFromJson, toJson: firestoreDateTimeToJson)  DateTime workDate, @JsonKey(fromJson: looseStringFromJson)  String dateKey, @JsonKey(fromJson: _statusFromJson)  String status, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? checkInAt, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? checkOutAt, @JsonKey(fromJson: looseIntFromJson)  int minutesLate, @JsonKey(fromJson: falseBoolFromJson)  bool needsCorrection, @JsonKey(fromJson: nullableLooseStringFromJson)  String? notes, @JsonKey(fromJson: _approvalStatusFromJson)  String approvalStatus, @JsonKey(fromJson: nullableLooseStringFromJson)  String? approvedByUid, @JsonKey(fromJson: nullableLooseStringFromJson)  String? approvedByName, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? approvedAt, @JsonKey(fromJson: nullableLooseStringFromJson)  String? rejectionReason, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? createdAt, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _AttendanceRecord() when $default != null:
return $default(_that.id,_that.salonId,_that.employeeId,_that.employeeName,_that.workDate,_that.dateKey,_that.status,_that.checkInAt,_that.checkOutAt,_that.minutesLate,_that.needsCorrection,_that.notes,_that.approvalStatus,_that.approvedByUid,_that.approvedByName,_that.approvedAt,_that.rejectionReason,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttendanceRecord implements AttendanceRecord {
  const _AttendanceRecord({@JsonKey(fromJson: looseStringFromJson) required this.id, @JsonKey(fromJson: looseStringFromJson) required this.salonId, @JsonKey(fromJson: looseStringFromJson) required this.employeeId, @JsonKey(fromJson: looseStringFromJson) required this.employeeName, @JsonKey(fromJson: firestoreDateTimeFromJson, toJson: firestoreDateTimeToJson) required this.workDate, @JsonKey(fromJson: looseStringFromJson) this.dateKey = '', @JsonKey(fromJson: _statusFromJson) required this.status, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) this.checkInAt, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) this.checkOutAt, @JsonKey(fromJson: looseIntFromJson) this.minutesLate = 0, @JsonKey(fromJson: falseBoolFromJson) this.needsCorrection = false, @JsonKey(fromJson: nullableLooseStringFromJson) this.notes, @JsonKey(fromJson: _approvalStatusFromJson) this.approvalStatus = AttendanceApprovalStatuses.pending, @JsonKey(fromJson: nullableLooseStringFromJson) this.approvedByUid, @JsonKey(fromJson: nullableLooseStringFromJson) this.approvedByName, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) this.approvedAt, @JsonKey(fromJson: nullableLooseStringFromJson) this.rejectionReason, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) this.createdAt, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) this.updatedAt});
  factory _AttendanceRecord.fromJson(Map<String, dynamic> json) => _$AttendanceRecordFromJson(json);

@override@JsonKey(fromJson: looseStringFromJson) final  String id;
@override@JsonKey(fromJson: looseStringFromJson) final  String salonId;
@override@JsonKey(fromJson: looseStringFromJson) final  String employeeId;
@override@JsonKey(fromJson: looseStringFromJson) final  String employeeName;
@override@JsonKey(fromJson: firestoreDateTimeFromJson, toJson: firestoreDateTimeToJson) final  DateTime workDate;
@override@JsonKey(fromJson: looseStringFromJson) final  String dateKey;
@override@JsonKey(fromJson: _statusFromJson) final  String status;
@override@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) final  DateTime? checkInAt;
@override@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) final  DateTime? checkOutAt;
@override@JsonKey(fromJson: looseIntFromJson) final  int minutesLate;
@override@JsonKey(fromJson: falseBoolFromJson) final  bool needsCorrection;
@override@JsonKey(fromJson: nullableLooseStringFromJson) final  String? notes;
@override@JsonKey(fromJson: _approvalStatusFromJson) final  String approvalStatus;
@override@JsonKey(fromJson: nullableLooseStringFromJson) final  String? approvedByUid;
@override@JsonKey(fromJson: nullableLooseStringFromJson) final  String? approvedByName;
@override@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) final  DateTime? approvedAt;
@override@JsonKey(fromJson: nullableLooseStringFromJson) final  String? rejectionReason;
@override@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) final  DateTime? createdAt;
@override@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) final  DateTime? updatedAt;

/// Create a copy of AttendanceRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendanceRecordCopyWith<_AttendanceRecord> get copyWith => __$AttendanceRecordCopyWithImpl<_AttendanceRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttendanceRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendanceRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.salonId, salonId) || other.salonId == salonId)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.employeeName, employeeName) || other.employeeName == employeeName)&&(identical(other.workDate, workDate) || other.workDate == workDate)&&(identical(other.dateKey, dateKey) || other.dateKey == dateKey)&&(identical(other.status, status) || other.status == status)&&(identical(other.checkInAt, checkInAt) || other.checkInAt == checkInAt)&&(identical(other.checkOutAt, checkOutAt) || other.checkOutAt == checkOutAt)&&(identical(other.minutesLate, minutesLate) || other.minutesLate == minutesLate)&&(identical(other.needsCorrection, needsCorrection) || other.needsCorrection == needsCorrection)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.approvalStatus, approvalStatus) || other.approvalStatus == approvalStatus)&&(identical(other.approvedByUid, approvedByUid) || other.approvedByUid == approvedByUid)&&(identical(other.approvedByName, approvedByName) || other.approvedByName == approvedByName)&&(identical(other.approvedAt, approvedAt) || other.approvedAt == approvedAt)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,salonId,employeeId,employeeName,workDate,dateKey,status,checkInAt,checkOutAt,minutesLate,needsCorrection,notes,approvalStatus,approvedByUid,approvedByName,approvedAt,rejectionReason,createdAt,updatedAt]);

@override
String toString() {
  return 'AttendanceRecord(id: $id, salonId: $salonId, employeeId: $employeeId, employeeName: $employeeName, workDate: $workDate, dateKey: $dateKey, status: $status, checkInAt: $checkInAt, checkOutAt: $checkOutAt, minutesLate: $minutesLate, needsCorrection: $needsCorrection, notes: $notes, approvalStatus: $approvalStatus, approvedByUid: $approvedByUid, approvedByName: $approvedByName, approvedAt: $approvedAt, rejectionReason: $rejectionReason, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$AttendanceRecordCopyWith<$Res> implements $AttendanceRecordCopyWith<$Res> {
  factory _$AttendanceRecordCopyWith(_AttendanceRecord value, $Res Function(_AttendanceRecord) _then) = __$AttendanceRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: looseStringFromJson) String id,@JsonKey(fromJson: looseStringFromJson) String salonId,@JsonKey(fromJson: looseStringFromJson) String employeeId,@JsonKey(fromJson: looseStringFromJson) String employeeName,@JsonKey(fromJson: firestoreDateTimeFromJson, toJson: firestoreDateTimeToJson) DateTime workDate,@JsonKey(fromJson: looseStringFromJson) String dateKey,@JsonKey(fromJson: _statusFromJson) String status,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? checkInAt,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? checkOutAt,@JsonKey(fromJson: looseIntFromJson) int minutesLate,@JsonKey(fromJson: falseBoolFromJson) bool needsCorrection,@JsonKey(fromJson: nullableLooseStringFromJson) String? notes,@JsonKey(fromJson: _approvalStatusFromJson) String approvalStatus,@JsonKey(fromJson: nullableLooseStringFromJson) String? approvedByUid,@JsonKey(fromJson: nullableLooseStringFromJson) String? approvedByName,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? approvedAt,@JsonKey(fromJson: nullableLooseStringFromJson) String? rejectionReason,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? createdAt,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? updatedAt
});




}
/// @nodoc
class __$AttendanceRecordCopyWithImpl<$Res>
    implements _$AttendanceRecordCopyWith<$Res> {
  __$AttendanceRecordCopyWithImpl(this._self, this._then);

  final _AttendanceRecord _self;
  final $Res Function(_AttendanceRecord) _then;

/// Create a copy of AttendanceRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? salonId = null,Object? employeeId = null,Object? employeeName = null,Object? workDate = null,Object? dateKey = null,Object? status = null,Object? checkInAt = freezed,Object? checkOutAt = freezed,Object? minutesLate = null,Object? needsCorrection = null,Object? notes = freezed,Object? approvalStatus = null,Object? approvedByUid = freezed,Object? approvedByName = freezed,Object? approvedAt = freezed,Object? rejectionReason = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_AttendanceRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,salonId: null == salonId ? _self.salonId : salonId // ignore: cast_nullable_to_non_nullable
as String,employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String,employeeName: null == employeeName ? _self.employeeName : employeeName // ignore: cast_nullable_to_non_nullable
as String,workDate: null == workDate ? _self.workDate : workDate // ignore: cast_nullable_to_non_nullable
as DateTime,dateKey: null == dateKey ? _self.dateKey : dateKey // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,checkInAt: freezed == checkInAt ? _self.checkInAt : checkInAt // ignore: cast_nullable_to_non_nullable
as DateTime?,checkOutAt: freezed == checkOutAt ? _self.checkOutAt : checkOutAt // ignore: cast_nullable_to_non_nullable
as DateTime?,minutesLate: null == minutesLate ? _self.minutesLate : minutesLate // ignore: cast_nullable_to_non_nullable
as int,needsCorrection: null == needsCorrection ? _self.needsCorrection : needsCorrection // ignore: cast_nullable_to_non_nullable
as bool,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,approvalStatus: null == approvalStatus ? _self.approvalStatus : approvalStatus // ignore: cast_nullable_to_non_nullable
as String,approvedByUid: freezed == approvedByUid ? _self.approvedByUid : approvedByUid // ignore: cast_nullable_to_non_nullable
as String?,approvedByName: freezed == approvedByName ? _self.approvedByName : approvedByName // ignore: cast_nullable_to_non_nullable
as String?,approvedAt: freezed == approvedAt ? _self.approvedAt : approvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
