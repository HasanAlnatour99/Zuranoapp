// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'violation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Violation {

@JsonKey(fromJson: looseStringFromJson) String get id;@JsonKey(fromJson: looseStringFromJson) String get salonId;@JsonKey(fromJson: looseStringFromJson) String get employeeId;@JsonKey(fromJson: nullableLooseStringFromJson) String? get employeeName;@JsonKey(fromJson: nullableLooseStringFromJson) String? get bookingId;@JsonKey(fromJson: _sourceTypeFromJson) String get sourceType;@JsonKey(fromJson: looseStringFromJson) String get violationType;@JsonKey(fromJson: _statusFromJson) String get status;@JsonKey(fromJson: firestoreDateTimeFromJson, toJson: firestoreDateTimeToJson) DateTime get occurredAt;@JsonKey(fromJson: looseIntFromJson) int get reportYear;@JsonKey(fromJson: looseIntFromJson) int get reportMonth;@JsonKey(fromJson: nullableLooseIntFromJson) int? get minutesLate;@JsonKey(fromJson: looseDoubleFromJson) double get amount;@JsonKey(fromJson: nullableLooseDoubleFromJson) double? get percent;@JsonKey(fromJson: nullableLooseStringFromJson) String? get currency;@JsonKey(fromJson: nullableStringDynamicMapFromJson, toJson: nullableStringDynamicMapToJson) Map<String, dynamic>? get ruleSnapshot;@JsonKey(fromJson: nullableLooseStringFromJson) String? get notes;@JsonKey(fromJson: nullableLooseStringFromJson) String? get createdByUid;@JsonKey(fromJson: nullableLooseStringFromJson) String? get createdByRole;@JsonKey(fromJson: nullableLooseStringFromJson) String? get approvedByUid;@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? get approvedAt;@JsonKey(fromJson: nullableLooseStringFromJson) String? get payrollRunId;@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? get appliedAt;@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? get createdAt;@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? get updatedAt;
/// Create a copy of Violation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ViolationCopyWith<Violation> get copyWith => _$ViolationCopyWithImpl<Violation>(this as Violation, _$identity);

  /// Serializes this Violation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Violation&&(identical(other.id, id) || other.id == id)&&(identical(other.salonId, salonId) || other.salonId == salonId)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.employeeName, employeeName) || other.employeeName == employeeName)&&(identical(other.bookingId, bookingId) || other.bookingId == bookingId)&&(identical(other.sourceType, sourceType) || other.sourceType == sourceType)&&(identical(other.violationType, violationType) || other.violationType == violationType)&&(identical(other.status, status) || other.status == status)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.reportYear, reportYear) || other.reportYear == reportYear)&&(identical(other.reportMonth, reportMonth) || other.reportMonth == reportMonth)&&(identical(other.minutesLate, minutesLate) || other.minutesLate == minutesLate)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.percent, percent) || other.percent == percent)&&(identical(other.currency, currency) || other.currency == currency)&&const DeepCollectionEquality().equals(other.ruleSnapshot, ruleSnapshot)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdByUid, createdByUid) || other.createdByUid == createdByUid)&&(identical(other.createdByRole, createdByRole) || other.createdByRole == createdByRole)&&(identical(other.approvedByUid, approvedByUid) || other.approvedByUid == approvedByUid)&&(identical(other.approvedAt, approvedAt) || other.approvedAt == approvedAt)&&(identical(other.payrollRunId, payrollRunId) || other.payrollRunId == payrollRunId)&&(identical(other.appliedAt, appliedAt) || other.appliedAt == appliedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,salonId,employeeId,employeeName,bookingId,sourceType,violationType,status,occurredAt,reportYear,reportMonth,minutesLate,amount,percent,currency,const DeepCollectionEquality().hash(ruleSnapshot),notes,createdByUid,createdByRole,approvedByUid,approvedAt,payrollRunId,appliedAt,createdAt,updatedAt]);

@override
String toString() {
  return 'Violation(id: $id, salonId: $salonId, employeeId: $employeeId, employeeName: $employeeName, bookingId: $bookingId, sourceType: $sourceType, violationType: $violationType, status: $status, occurredAt: $occurredAt, reportYear: $reportYear, reportMonth: $reportMonth, minutesLate: $minutesLate, amount: $amount, percent: $percent, currency: $currency, ruleSnapshot: $ruleSnapshot, notes: $notes, createdByUid: $createdByUid, createdByRole: $createdByRole, approvedByUid: $approvedByUid, approvedAt: $approvedAt, payrollRunId: $payrollRunId, appliedAt: $appliedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ViolationCopyWith<$Res>  {
  factory $ViolationCopyWith(Violation value, $Res Function(Violation) _then) = _$ViolationCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: looseStringFromJson) String id,@JsonKey(fromJson: looseStringFromJson) String salonId,@JsonKey(fromJson: looseStringFromJson) String employeeId,@JsonKey(fromJson: nullableLooseStringFromJson) String? employeeName,@JsonKey(fromJson: nullableLooseStringFromJson) String? bookingId,@JsonKey(fromJson: _sourceTypeFromJson) String sourceType,@JsonKey(fromJson: looseStringFromJson) String violationType,@JsonKey(fromJson: _statusFromJson) String status,@JsonKey(fromJson: firestoreDateTimeFromJson, toJson: firestoreDateTimeToJson) DateTime occurredAt,@JsonKey(fromJson: looseIntFromJson) int reportYear,@JsonKey(fromJson: looseIntFromJson) int reportMonth,@JsonKey(fromJson: nullableLooseIntFromJson) int? minutesLate,@JsonKey(fromJson: looseDoubleFromJson) double amount,@JsonKey(fromJson: nullableLooseDoubleFromJson) double? percent,@JsonKey(fromJson: nullableLooseStringFromJson) String? currency,@JsonKey(fromJson: nullableStringDynamicMapFromJson, toJson: nullableStringDynamicMapToJson) Map<String, dynamic>? ruleSnapshot,@JsonKey(fromJson: nullableLooseStringFromJson) String? notes,@JsonKey(fromJson: nullableLooseStringFromJson) String? createdByUid,@JsonKey(fromJson: nullableLooseStringFromJson) String? createdByRole,@JsonKey(fromJson: nullableLooseStringFromJson) String? approvedByUid,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? approvedAt,@JsonKey(fromJson: nullableLooseStringFromJson) String? payrollRunId,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? appliedAt,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? createdAt,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? updatedAt
});




}
/// @nodoc
class _$ViolationCopyWithImpl<$Res>
    implements $ViolationCopyWith<$Res> {
  _$ViolationCopyWithImpl(this._self, this._then);

  final Violation _self;
  final $Res Function(Violation) _then;

/// Create a copy of Violation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? salonId = null,Object? employeeId = null,Object? employeeName = freezed,Object? bookingId = freezed,Object? sourceType = null,Object? violationType = null,Object? status = null,Object? occurredAt = null,Object? reportYear = null,Object? reportMonth = null,Object? minutesLate = freezed,Object? amount = null,Object? percent = freezed,Object? currency = freezed,Object? ruleSnapshot = freezed,Object? notes = freezed,Object? createdByUid = freezed,Object? createdByRole = freezed,Object? approvedByUid = freezed,Object? approvedAt = freezed,Object? payrollRunId = freezed,Object? appliedAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,salonId: null == salonId ? _self.salonId : salonId // ignore: cast_nullable_to_non_nullable
as String,employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String,employeeName: freezed == employeeName ? _self.employeeName : employeeName // ignore: cast_nullable_to_non_nullable
as String?,bookingId: freezed == bookingId ? _self.bookingId : bookingId // ignore: cast_nullable_to_non_nullable
as String?,sourceType: null == sourceType ? _self.sourceType : sourceType // ignore: cast_nullable_to_non_nullable
as String,violationType: null == violationType ? _self.violationType : violationType // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,reportYear: null == reportYear ? _self.reportYear : reportYear // ignore: cast_nullable_to_non_nullable
as int,reportMonth: null == reportMonth ? _self.reportMonth : reportMonth // ignore: cast_nullable_to_non_nullable
as int,minutesLate: freezed == minutesLate ? _self.minutesLate : minutesLate // ignore: cast_nullable_to_non_nullable
as int?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,percent: freezed == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as double?,currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,ruleSnapshot: freezed == ruleSnapshot ? _self.ruleSnapshot : ruleSnapshot // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdByUid: freezed == createdByUid ? _self.createdByUid : createdByUid // ignore: cast_nullable_to_non_nullable
as String?,createdByRole: freezed == createdByRole ? _self.createdByRole : createdByRole // ignore: cast_nullable_to_non_nullable
as String?,approvedByUid: freezed == approvedByUid ? _self.approvedByUid : approvedByUid // ignore: cast_nullable_to_non_nullable
as String?,approvedAt: freezed == approvedAt ? _self.approvedAt : approvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,payrollRunId: freezed == payrollRunId ? _self.payrollRunId : payrollRunId // ignore: cast_nullable_to_non_nullable
as String?,appliedAt: freezed == appliedAt ? _self.appliedAt : appliedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Violation].
extension ViolationPatterns on Violation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Violation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Violation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Violation value)  $default,){
final _that = this;
switch (_that) {
case _Violation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Violation value)?  $default,){
final _that = this;
switch (_that) {
case _Violation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: looseStringFromJson)  String id, @JsonKey(fromJson: looseStringFromJson)  String salonId, @JsonKey(fromJson: looseStringFromJson)  String employeeId, @JsonKey(fromJson: nullableLooseStringFromJson)  String? employeeName, @JsonKey(fromJson: nullableLooseStringFromJson)  String? bookingId, @JsonKey(fromJson: _sourceTypeFromJson)  String sourceType, @JsonKey(fromJson: looseStringFromJson)  String violationType, @JsonKey(fromJson: _statusFromJson)  String status, @JsonKey(fromJson: firestoreDateTimeFromJson, toJson: firestoreDateTimeToJson)  DateTime occurredAt, @JsonKey(fromJson: looseIntFromJson)  int reportYear, @JsonKey(fromJson: looseIntFromJson)  int reportMonth, @JsonKey(fromJson: nullableLooseIntFromJson)  int? minutesLate, @JsonKey(fromJson: looseDoubleFromJson)  double amount, @JsonKey(fromJson: nullableLooseDoubleFromJson)  double? percent, @JsonKey(fromJson: nullableLooseStringFromJson)  String? currency, @JsonKey(fromJson: nullableStringDynamicMapFromJson, toJson: nullableStringDynamicMapToJson)  Map<String, dynamic>? ruleSnapshot, @JsonKey(fromJson: nullableLooseStringFromJson)  String? notes, @JsonKey(fromJson: nullableLooseStringFromJson)  String? createdByUid, @JsonKey(fromJson: nullableLooseStringFromJson)  String? createdByRole, @JsonKey(fromJson: nullableLooseStringFromJson)  String? approvedByUid, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? approvedAt, @JsonKey(fromJson: nullableLooseStringFromJson)  String? payrollRunId, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? appliedAt, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? createdAt, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Violation() when $default != null:
return $default(_that.id,_that.salonId,_that.employeeId,_that.employeeName,_that.bookingId,_that.sourceType,_that.violationType,_that.status,_that.occurredAt,_that.reportYear,_that.reportMonth,_that.minutesLate,_that.amount,_that.percent,_that.currency,_that.ruleSnapshot,_that.notes,_that.createdByUid,_that.createdByRole,_that.approvedByUid,_that.approvedAt,_that.payrollRunId,_that.appliedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: looseStringFromJson)  String id, @JsonKey(fromJson: looseStringFromJson)  String salonId, @JsonKey(fromJson: looseStringFromJson)  String employeeId, @JsonKey(fromJson: nullableLooseStringFromJson)  String? employeeName, @JsonKey(fromJson: nullableLooseStringFromJson)  String? bookingId, @JsonKey(fromJson: _sourceTypeFromJson)  String sourceType, @JsonKey(fromJson: looseStringFromJson)  String violationType, @JsonKey(fromJson: _statusFromJson)  String status, @JsonKey(fromJson: firestoreDateTimeFromJson, toJson: firestoreDateTimeToJson)  DateTime occurredAt, @JsonKey(fromJson: looseIntFromJson)  int reportYear, @JsonKey(fromJson: looseIntFromJson)  int reportMonth, @JsonKey(fromJson: nullableLooseIntFromJson)  int? minutesLate, @JsonKey(fromJson: looseDoubleFromJson)  double amount, @JsonKey(fromJson: nullableLooseDoubleFromJson)  double? percent, @JsonKey(fromJson: nullableLooseStringFromJson)  String? currency, @JsonKey(fromJson: nullableStringDynamicMapFromJson, toJson: nullableStringDynamicMapToJson)  Map<String, dynamic>? ruleSnapshot, @JsonKey(fromJson: nullableLooseStringFromJson)  String? notes, @JsonKey(fromJson: nullableLooseStringFromJson)  String? createdByUid, @JsonKey(fromJson: nullableLooseStringFromJson)  String? createdByRole, @JsonKey(fromJson: nullableLooseStringFromJson)  String? approvedByUid, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? approvedAt, @JsonKey(fromJson: nullableLooseStringFromJson)  String? payrollRunId, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? appliedAt, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? createdAt, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Violation():
return $default(_that.id,_that.salonId,_that.employeeId,_that.employeeName,_that.bookingId,_that.sourceType,_that.violationType,_that.status,_that.occurredAt,_that.reportYear,_that.reportMonth,_that.minutesLate,_that.amount,_that.percent,_that.currency,_that.ruleSnapshot,_that.notes,_that.createdByUid,_that.createdByRole,_that.approvedByUid,_that.approvedAt,_that.payrollRunId,_that.appliedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: looseStringFromJson)  String id, @JsonKey(fromJson: looseStringFromJson)  String salonId, @JsonKey(fromJson: looseStringFromJson)  String employeeId, @JsonKey(fromJson: nullableLooseStringFromJson)  String? employeeName, @JsonKey(fromJson: nullableLooseStringFromJson)  String? bookingId, @JsonKey(fromJson: _sourceTypeFromJson)  String sourceType, @JsonKey(fromJson: looseStringFromJson)  String violationType, @JsonKey(fromJson: _statusFromJson)  String status, @JsonKey(fromJson: firestoreDateTimeFromJson, toJson: firestoreDateTimeToJson)  DateTime occurredAt, @JsonKey(fromJson: looseIntFromJson)  int reportYear, @JsonKey(fromJson: looseIntFromJson)  int reportMonth, @JsonKey(fromJson: nullableLooseIntFromJson)  int? minutesLate, @JsonKey(fromJson: looseDoubleFromJson)  double amount, @JsonKey(fromJson: nullableLooseDoubleFromJson)  double? percent, @JsonKey(fromJson: nullableLooseStringFromJson)  String? currency, @JsonKey(fromJson: nullableStringDynamicMapFromJson, toJson: nullableStringDynamicMapToJson)  Map<String, dynamic>? ruleSnapshot, @JsonKey(fromJson: nullableLooseStringFromJson)  String? notes, @JsonKey(fromJson: nullableLooseStringFromJson)  String? createdByUid, @JsonKey(fromJson: nullableLooseStringFromJson)  String? createdByRole, @JsonKey(fromJson: nullableLooseStringFromJson)  String? approvedByUid, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? approvedAt, @JsonKey(fromJson: nullableLooseStringFromJson)  String? payrollRunId, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? appliedAt, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? createdAt, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Violation() when $default != null:
return $default(_that.id,_that.salonId,_that.employeeId,_that.employeeName,_that.bookingId,_that.sourceType,_that.violationType,_that.status,_that.occurredAt,_that.reportYear,_that.reportMonth,_that.minutesLate,_that.amount,_that.percent,_that.currency,_that.ruleSnapshot,_that.notes,_that.createdByUid,_that.createdByRole,_that.approvedByUid,_that.approvedAt,_that.payrollRunId,_that.appliedAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Violation extends Violation {
  const _Violation({@JsonKey(fromJson: looseStringFromJson) required this.id, @JsonKey(fromJson: looseStringFromJson) required this.salonId, @JsonKey(fromJson: looseStringFromJson) required this.employeeId, @JsonKey(fromJson: nullableLooseStringFromJson) this.employeeName, @JsonKey(fromJson: nullableLooseStringFromJson) this.bookingId, @JsonKey(fromJson: _sourceTypeFromJson) required this.sourceType, @JsonKey(fromJson: looseStringFromJson) required this.violationType, @JsonKey(fromJson: _statusFromJson) required this.status, @JsonKey(fromJson: firestoreDateTimeFromJson, toJson: firestoreDateTimeToJson) required this.occurredAt, @JsonKey(fromJson: looseIntFromJson) this.reportYear = 0, @JsonKey(fromJson: looseIntFromJson) this.reportMonth = 0, @JsonKey(fromJson: nullableLooseIntFromJson) this.minutesLate, @JsonKey(fromJson: looseDoubleFromJson) this.amount = 0, @JsonKey(fromJson: nullableLooseDoubleFromJson) this.percent, @JsonKey(fromJson: nullableLooseStringFromJson) this.currency, @JsonKey(fromJson: nullableStringDynamicMapFromJson, toJson: nullableStringDynamicMapToJson) final  Map<String, dynamic>? ruleSnapshot, @JsonKey(fromJson: nullableLooseStringFromJson) this.notes, @JsonKey(fromJson: nullableLooseStringFromJson) this.createdByUid, @JsonKey(fromJson: nullableLooseStringFromJson) this.createdByRole, @JsonKey(fromJson: nullableLooseStringFromJson) this.approvedByUid, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) this.approvedAt, @JsonKey(fromJson: nullableLooseStringFromJson) this.payrollRunId, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) this.appliedAt, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) this.createdAt, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) this.updatedAt}): _ruleSnapshot = ruleSnapshot,super._();
  factory _Violation.fromJson(Map<String, dynamic> json) => _$ViolationFromJson(json);

@override@JsonKey(fromJson: looseStringFromJson) final  String id;
@override@JsonKey(fromJson: looseStringFromJson) final  String salonId;
@override@JsonKey(fromJson: looseStringFromJson) final  String employeeId;
@override@JsonKey(fromJson: nullableLooseStringFromJson) final  String? employeeName;
@override@JsonKey(fromJson: nullableLooseStringFromJson) final  String? bookingId;
@override@JsonKey(fromJson: _sourceTypeFromJson) final  String sourceType;
@override@JsonKey(fromJson: looseStringFromJson) final  String violationType;
@override@JsonKey(fromJson: _statusFromJson) final  String status;
@override@JsonKey(fromJson: firestoreDateTimeFromJson, toJson: firestoreDateTimeToJson) final  DateTime occurredAt;
@override@JsonKey(fromJson: looseIntFromJson) final  int reportYear;
@override@JsonKey(fromJson: looseIntFromJson) final  int reportMonth;
@override@JsonKey(fromJson: nullableLooseIntFromJson) final  int? minutesLate;
@override@JsonKey(fromJson: looseDoubleFromJson) final  double amount;
@override@JsonKey(fromJson: nullableLooseDoubleFromJson) final  double? percent;
@override@JsonKey(fromJson: nullableLooseStringFromJson) final  String? currency;
 final  Map<String, dynamic>? _ruleSnapshot;
@override@JsonKey(fromJson: nullableStringDynamicMapFromJson, toJson: nullableStringDynamicMapToJson) Map<String, dynamic>? get ruleSnapshot {
  final value = _ruleSnapshot;
  if (value == null) return null;
  if (_ruleSnapshot is EqualUnmodifiableMapView) return _ruleSnapshot;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override@JsonKey(fromJson: nullableLooseStringFromJson) final  String? notes;
@override@JsonKey(fromJson: nullableLooseStringFromJson) final  String? createdByUid;
@override@JsonKey(fromJson: nullableLooseStringFromJson) final  String? createdByRole;
@override@JsonKey(fromJson: nullableLooseStringFromJson) final  String? approvedByUid;
@override@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) final  DateTime? approvedAt;
@override@JsonKey(fromJson: nullableLooseStringFromJson) final  String? payrollRunId;
@override@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) final  DateTime? appliedAt;
@override@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) final  DateTime? createdAt;
@override@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) final  DateTime? updatedAt;

/// Create a copy of Violation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ViolationCopyWith<_Violation> get copyWith => __$ViolationCopyWithImpl<_Violation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ViolationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Violation&&(identical(other.id, id) || other.id == id)&&(identical(other.salonId, salonId) || other.salonId == salonId)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.employeeName, employeeName) || other.employeeName == employeeName)&&(identical(other.bookingId, bookingId) || other.bookingId == bookingId)&&(identical(other.sourceType, sourceType) || other.sourceType == sourceType)&&(identical(other.violationType, violationType) || other.violationType == violationType)&&(identical(other.status, status) || other.status == status)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.reportYear, reportYear) || other.reportYear == reportYear)&&(identical(other.reportMonth, reportMonth) || other.reportMonth == reportMonth)&&(identical(other.minutesLate, minutesLate) || other.minutesLate == minutesLate)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.percent, percent) || other.percent == percent)&&(identical(other.currency, currency) || other.currency == currency)&&const DeepCollectionEquality().equals(other._ruleSnapshot, _ruleSnapshot)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdByUid, createdByUid) || other.createdByUid == createdByUid)&&(identical(other.createdByRole, createdByRole) || other.createdByRole == createdByRole)&&(identical(other.approvedByUid, approvedByUid) || other.approvedByUid == approvedByUid)&&(identical(other.approvedAt, approvedAt) || other.approvedAt == approvedAt)&&(identical(other.payrollRunId, payrollRunId) || other.payrollRunId == payrollRunId)&&(identical(other.appliedAt, appliedAt) || other.appliedAt == appliedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,salonId,employeeId,employeeName,bookingId,sourceType,violationType,status,occurredAt,reportYear,reportMonth,minutesLate,amount,percent,currency,const DeepCollectionEquality().hash(_ruleSnapshot),notes,createdByUid,createdByRole,approvedByUid,approvedAt,payrollRunId,appliedAt,createdAt,updatedAt]);

@override
String toString() {
  return 'Violation(id: $id, salonId: $salonId, employeeId: $employeeId, employeeName: $employeeName, bookingId: $bookingId, sourceType: $sourceType, violationType: $violationType, status: $status, occurredAt: $occurredAt, reportYear: $reportYear, reportMonth: $reportMonth, minutesLate: $minutesLate, amount: $amount, percent: $percent, currency: $currency, ruleSnapshot: $ruleSnapshot, notes: $notes, createdByUid: $createdByUid, createdByRole: $createdByRole, approvedByUid: $approvedByUid, approvedAt: $approvedAt, payrollRunId: $payrollRunId, appliedAt: $appliedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ViolationCopyWith<$Res> implements $ViolationCopyWith<$Res> {
  factory _$ViolationCopyWith(_Violation value, $Res Function(_Violation) _then) = __$ViolationCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: looseStringFromJson) String id,@JsonKey(fromJson: looseStringFromJson) String salonId,@JsonKey(fromJson: looseStringFromJson) String employeeId,@JsonKey(fromJson: nullableLooseStringFromJson) String? employeeName,@JsonKey(fromJson: nullableLooseStringFromJson) String? bookingId,@JsonKey(fromJson: _sourceTypeFromJson) String sourceType,@JsonKey(fromJson: looseStringFromJson) String violationType,@JsonKey(fromJson: _statusFromJson) String status,@JsonKey(fromJson: firestoreDateTimeFromJson, toJson: firestoreDateTimeToJson) DateTime occurredAt,@JsonKey(fromJson: looseIntFromJson) int reportYear,@JsonKey(fromJson: looseIntFromJson) int reportMonth,@JsonKey(fromJson: nullableLooseIntFromJson) int? minutesLate,@JsonKey(fromJson: looseDoubleFromJson) double amount,@JsonKey(fromJson: nullableLooseDoubleFromJson) double? percent,@JsonKey(fromJson: nullableLooseStringFromJson) String? currency,@JsonKey(fromJson: nullableStringDynamicMapFromJson, toJson: nullableStringDynamicMapToJson) Map<String, dynamic>? ruleSnapshot,@JsonKey(fromJson: nullableLooseStringFromJson) String? notes,@JsonKey(fromJson: nullableLooseStringFromJson) String? createdByUid,@JsonKey(fromJson: nullableLooseStringFromJson) String? createdByRole,@JsonKey(fromJson: nullableLooseStringFromJson) String? approvedByUid,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? approvedAt,@JsonKey(fromJson: nullableLooseStringFromJson) String? payrollRunId,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? appliedAt,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? createdAt,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? updatedAt
});




}
/// @nodoc
class __$ViolationCopyWithImpl<$Res>
    implements _$ViolationCopyWith<$Res> {
  __$ViolationCopyWithImpl(this._self, this._then);

  final _Violation _self;
  final $Res Function(_Violation) _then;

/// Create a copy of Violation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? salonId = null,Object? employeeId = null,Object? employeeName = freezed,Object? bookingId = freezed,Object? sourceType = null,Object? violationType = null,Object? status = null,Object? occurredAt = null,Object? reportYear = null,Object? reportMonth = null,Object? minutesLate = freezed,Object? amount = null,Object? percent = freezed,Object? currency = freezed,Object? ruleSnapshot = freezed,Object? notes = freezed,Object? createdByUid = freezed,Object? createdByRole = freezed,Object? approvedByUid = freezed,Object? approvedAt = freezed,Object? payrollRunId = freezed,Object? appliedAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Violation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,salonId: null == salonId ? _self.salonId : salonId // ignore: cast_nullable_to_non_nullable
as String,employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String,employeeName: freezed == employeeName ? _self.employeeName : employeeName // ignore: cast_nullable_to_non_nullable
as String?,bookingId: freezed == bookingId ? _self.bookingId : bookingId // ignore: cast_nullable_to_non_nullable
as String?,sourceType: null == sourceType ? _self.sourceType : sourceType // ignore: cast_nullable_to_non_nullable
as String,violationType: null == violationType ? _self.violationType : violationType // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,reportYear: null == reportYear ? _self.reportYear : reportYear // ignore: cast_nullable_to_non_nullable
as int,reportMonth: null == reportMonth ? _self.reportMonth : reportMonth // ignore: cast_nullable_to_non_nullable
as int,minutesLate: freezed == minutesLate ? _self.minutesLate : minutesLate // ignore: cast_nullable_to_non_nullable
as int?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,percent: freezed == percent ? _self.percent : percent // ignore: cast_nullable_to_non_nullable
as double?,currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,ruleSnapshot: freezed == ruleSnapshot ? _self._ruleSnapshot : ruleSnapshot // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdByUid: freezed == createdByUid ? _self.createdByUid : createdByUid // ignore: cast_nullable_to_non_nullable
as String?,createdByRole: freezed == createdByRole ? _self.createdByRole : createdByRole // ignore: cast_nullable_to_non_nullable
as String?,approvedByUid: freezed == approvedByUid ? _self.approvedByUid : approvedByUid // ignore: cast_nullable_to_non_nullable
as String?,approvedAt: freezed == approvedAt ? _self.approvedAt : approvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,payrollRunId: freezed == payrollRunId ? _self.payrollRunId : payrollRunId // ignore: cast_nullable_to_non_nullable
as String?,appliedAt: freezed == appliedAt ? _self.appliedAt : appliedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
