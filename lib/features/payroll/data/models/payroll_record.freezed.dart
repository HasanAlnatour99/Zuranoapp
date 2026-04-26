// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payroll_record.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PayrollRecord {

@JsonKey(fromJson: looseStringFromJson) String get id;@JsonKey(fromJson: looseStringFromJson) String get salonId;@JsonKey(fromJson: looseStringFromJson) String get employeeId;@JsonKey(fromJson: looseStringFromJson) String get employeeName;@JsonKey(fromJson: firestoreDateTimeFromJson, toJson: firestoreDateTimeToJson) DateTime get periodStart;@JsonKey(fromJson: firestoreDateTimeFromJson, toJson: firestoreDateTimeToJson) DateTime get periodEnd;@JsonKey(fromJson: looseDoubleFromJson) double get baseAmount;@JsonKey(fromJson: looseDoubleFromJson) double get commissionAmount;@JsonKey(fromJson: looseDoubleFromJson) double get totalSales;@JsonKey(fromJson: looseDoubleFromJson) double get commissionRate;@JsonKey(fromJson: looseDoubleFromJson) double get bonusAmount;@JsonKey(fromJson: looseDoubleFromJson) double get deductionAmount;@JsonKey(fromJson: looseDoubleFromJson) double get manualDeductionAmount;@JsonKey(fromJson: PayrollDeductionLine.listFromJson) List<PayrollDeductionLine> get deductionLines;@JsonKey(fromJson: looseDoubleFromJson) double get netAmount;@JsonKey(fromJson: _statusFromJson) String get status;@JsonKey(fromJson: looseIntFromJson) int get month;@JsonKey(fromJson: looseIntFromJson) int get year;@JsonKey(fromJson: nullableLooseStringFromJson) String? get notes;@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? get paidAt;@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? get createdAt;@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? get updatedAt;
/// Create a copy of PayrollRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PayrollRecordCopyWith<PayrollRecord> get copyWith => _$PayrollRecordCopyWithImpl<PayrollRecord>(this as PayrollRecord, _$identity);

  /// Serializes this PayrollRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PayrollRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.salonId, salonId) || other.salonId == salonId)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.employeeName, employeeName) || other.employeeName == employeeName)&&(identical(other.periodStart, periodStart) || other.periodStart == periodStart)&&(identical(other.periodEnd, periodEnd) || other.periodEnd == periodEnd)&&(identical(other.baseAmount, baseAmount) || other.baseAmount == baseAmount)&&(identical(other.commissionAmount, commissionAmount) || other.commissionAmount == commissionAmount)&&(identical(other.totalSales, totalSales) || other.totalSales == totalSales)&&(identical(other.commissionRate, commissionRate) || other.commissionRate == commissionRate)&&(identical(other.bonusAmount, bonusAmount) || other.bonusAmount == bonusAmount)&&(identical(other.deductionAmount, deductionAmount) || other.deductionAmount == deductionAmount)&&(identical(other.manualDeductionAmount, manualDeductionAmount) || other.manualDeductionAmount == manualDeductionAmount)&&const DeepCollectionEquality().equals(other.deductionLines, deductionLines)&&(identical(other.netAmount, netAmount) || other.netAmount == netAmount)&&(identical(other.status, status) || other.status == status)&&(identical(other.month, month) || other.month == month)&&(identical(other.year, year) || other.year == year)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,salonId,employeeId,employeeName,periodStart,periodEnd,baseAmount,commissionAmount,totalSales,commissionRate,bonusAmount,deductionAmount,manualDeductionAmount,const DeepCollectionEquality().hash(deductionLines),netAmount,status,month,year,notes,paidAt,createdAt,updatedAt]);

@override
String toString() {
  return 'PayrollRecord(id: $id, salonId: $salonId, employeeId: $employeeId, employeeName: $employeeName, periodStart: $periodStart, periodEnd: $periodEnd, baseAmount: $baseAmount, commissionAmount: $commissionAmount, totalSales: $totalSales, commissionRate: $commissionRate, bonusAmount: $bonusAmount, deductionAmount: $deductionAmount, manualDeductionAmount: $manualDeductionAmount, deductionLines: $deductionLines, netAmount: $netAmount, status: $status, month: $month, year: $year, notes: $notes, paidAt: $paidAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $PayrollRecordCopyWith<$Res>  {
  factory $PayrollRecordCopyWith(PayrollRecord value, $Res Function(PayrollRecord) _then) = _$PayrollRecordCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: looseStringFromJson) String id,@JsonKey(fromJson: looseStringFromJson) String salonId,@JsonKey(fromJson: looseStringFromJson) String employeeId,@JsonKey(fromJson: looseStringFromJson) String employeeName,@JsonKey(fromJson: firestoreDateTimeFromJson, toJson: firestoreDateTimeToJson) DateTime periodStart,@JsonKey(fromJson: firestoreDateTimeFromJson, toJson: firestoreDateTimeToJson) DateTime periodEnd,@JsonKey(fromJson: looseDoubleFromJson) double baseAmount,@JsonKey(fromJson: looseDoubleFromJson) double commissionAmount,@JsonKey(fromJson: looseDoubleFromJson) double totalSales,@JsonKey(fromJson: looseDoubleFromJson) double commissionRate,@JsonKey(fromJson: looseDoubleFromJson) double bonusAmount,@JsonKey(fromJson: looseDoubleFromJson) double deductionAmount,@JsonKey(fromJson: looseDoubleFromJson) double manualDeductionAmount,@JsonKey(fromJson: PayrollDeductionLine.listFromJson) List<PayrollDeductionLine> deductionLines,@JsonKey(fromJson: looseDoubleFromJson) double netAmount,@JsonKey(fromJson: _statusFromJson) String status,@JsonKey(fromJson: looseIntFromJson) int month,@JsonKey(fromJson: looseIntFromJson) int year,@JsonKey(fromJson: nullableLooseStringFromJson) String? notes,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? paidAt,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? createdAt,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? updatedAt
});




}
/// @nodoc
class _$PayrollRecordCopyWithImpl<$Res>
    implements $PayrollRecordCopyWith<$Res> {
  _$PayrollRecordCopyWithImpl(this._self, this._then);

  final PayrollRecord _self;
  final $Res Function(PayrollRecord) _then;

/// Create a copy of PayrollRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? salonId = null,Object? employeeId = null,Object? employeeName = null,Object? periodStart = null,Object? periodEnd = null,Object? baseAmount = null,Object? commissionAmount = null,Object? totalSales = null,Object? commissionRate = null,Object? bonusAmount = null,Object? deductionAmount = null,Object? manualDeductionAmount = null,Object? deductionLines = null,Object? netAmount = null,Object? status = null,Object? month = null,Object? year = null,Object? notes = freezed,Object? paidAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,salonId: null == salonId ? _self.salonId : salonId // ignore: cast_nullable_to_non_nullable
as String,employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String,employeeName: null == employeeName ? _self.employeeName : employeeName // ignore: cast_nullable_to_non_nullable
as String,periodStart: null == periodStart ? _self.periodStart : periodStart // ignore: cast_nullable_to_non_nullable
as DateTime,periodEnd: null == periodEnd ? _self.periodEnd : periodEnd // ignore: cast_nullable_to_non_nullable
as DateTime,baseAmount: null == baseAmount ? _self.baseAmount : baseAmount // ignore: cast_nullable_to_non_nullable
as double,commissionAmount: null == commissionAmount ? _self.commissionAmount : commissionAmount // ignore: cast_nullable_to_non_nullable
as double,totalSales: null == totalSales ? _self.totalSales : totalSales // ignore: cast_nullable_to_non_nullable
as double,commissionRate: null == commissionRate ? _self.commissionRate : commissionRate // ignore: cast_nullable_to_non_nullable
as double,bonusAmount: null == bonusAmount ? _self.bonusAmount : bonusAmount // ignore: cast_nullable_to_non_nullable
as double,deductionAmount: null == deductionAmount ? _self.deductionAmount : deductionAmount // ignore: cast_nullable_to_non_nullable
as double,manualDeductionAmount: null == manualDeductionAmount ? _self.manualDeductionAmount : manualDeductionAmount // ignore: cast_nullable_to_non_nullable
as double,deductionLines: null == deductionLines ? _self.deductionLines : deductionLines // ignore: cast_nullable_to_non_nullable
as List<PayrollDeductionLine>,netAmount: null == netAmount ? _self.netAmount : netAmount // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PayrollRecord].
extension PayrollRecordPatterns on PayrollRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PayrollRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PayrollRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PayrollRecord value)  $default,){
final _that = this;
switch (_that) {
case _PayrollRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PayrollRecord value)?  $default,){
final _that = this;
switch (_that) {
case _PayrollRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: looseStringFromJson)  String id, @JsonKey(fromJson: looseStringFromJson)  String salonId, @JsonKey(fromJson: looseStringFromJson)  String employeeId, @JsonKey(fromJson: looseStringFromJson)  String employeeName, @JsonKey(fromJson: firestoreDateTimeFromJson, toJson: firestoreDateTimeToJson)  DateTime periodStart, @JsonKey(fromJson: firestoreDateTimeFromJson, toJson: firestoreDateTimeToJson)  DateTime periodEnd, @JsonKey(fromJson: looseDoubleFromJson)  double baseAmount, @JsonKey(fromJson: looseDoubleFromJson)  double commissionAmount, @JsonKey(fromJson: looseDoubleFromJson)  double totalSales, @JsonKey(fromJson: looseDoubleFromJson)  double commissionRate, @JsonKey(fromJson: looseDoubleFromJson)  double bonusAmount, @JsonKey(fromJson: looseDoubleFromJson)  double deductionAmount, @JsonKey(fromJson: looseDoubleFromJson)  double manualDeductionAmount, @JsonKey(fromJson: PayrollDeductionLine.listFromJson)  List<PayrollDeductionLine> deductionLines, @JsonKey(fromJson: looseDoubleFromJson)  double netAmount, @JsonKey(fromJson: _statusFromJson)  String status, @JsonKey(fromJson: looseIntFromJson)  int month, @JsonKey(fromJson: looseIntFromJson)  int year, @JsonKey(fromJson: nullableLooseStringFromJson)  String? notes, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? paidAt, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? createdAt, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PayrollRecord() when $default != null:
return $default(_that.id,_that.salonId,_that.employeeId,_that.employeeName,_that.periodStart,_that.periodEnd,_that.baseAmount,_that.commissionAmount,_that.totalSales,_that.commissionRate,_that.bonusAmount,_that.deductionAmount,_that.manualDeductionAmount,_that.deductionLines,_that.netAmount,_that.status,_that.month,_that.year,_that.notes,_that.paidAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: looseStringFromJson)  String id, @JsonKey(fromJson: looseStringFromJson)  String salonId, @JsonKey(fromJson: looseStringFromJson)  String employeeId, @JsonKey(fromJson: looseStringFromJson)  String employeeName, @JsonKey(fromJson: firestoreDateTimeFromJson, toJson: firestoreDateTimeToJson)  DateTime periodStart, @JsonKey(fromJson: firestoreDateTimeFromJson, toJson: firestoreDateTimeToJson)  DateTime periodEnd, @JsonKey(fromJson: looseDoubleFromJson)  double baseAmount, @JsonKey(fromJson: looseDoubleFromJson)  double commissionAmount, @JsonKey(fromJson: looseDoubleFromJson)  double totalSales, @JsonKey(fromJson: looseDoubleFromJson)  double commissionRate, @JsonKey(fromJson: looseDoubleFromJson)  double bonusAmount, @JsonKey(fromJson: looseDoubleFromJson)  double deductionAmount, @JsonKey(fromJson: looseDoubleFromJson)  double manualDeductionAmount, @JsonKey(fromJson: PayrollDeductionLine.listFromJson)  List<PayrollDeductionLine> deductionLines, @JsonKey(fromJson: looseDoubleFromJson)  double netAmount, @JsonKey(fromJson: _statusFromJson)  String status, @JsonKey(fromJson: looseIntFromJson)  int month, @JsonKey(fromJson: looseIntFromJson)  int year, @JsonKey(fromJson: nullableLooseStringFromJson)  String? notes, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? paidAt, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? createdAt, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _PayrollRecord():
return $default(_that.id,_that.salonId,_that.employeeId,_that.employeeName,_that.periodStart,_that.periodEnd,_that.baseAmount,_that.commissionAmount,_that.totalSales,_that.commissionRate,_that.bonusAmount,_that.deductionAmount,_that.manualDeductionAmount,_that.deductionLines,_that.netAmount,_that.status,_that.month,_that.year,_that.notes,_that.paidAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: looseStringFromJson)  String id, @JsonKey(fromJson: looseStringFromJson)  String salonId, @JsonKey(fromJson: looseStringFromJson)  String employeeId, @JsonKey(fromJson: looseStringFromJson)  String employeeName, @JsonKey(fromJson: firestoreDateTimeFromJson, toJson: firestoreDateTimeToJson)  DateTime periodStart, @JsonKey(fromJson: firestoreDateTimeFromJson, toJson: firestoreDateTimeToJson)  DateTime periodEnd, @JsonKey(fromJson: looseDoubleFromJson)  double baseAmount, @JsonKey(fromJson: looseDoubleFromJson)  double commissionAmount, @JsonKey(fromJson: looseDoubleFromJson)  double totalSales, @JsonKey(fromJson: looseDoubleFromJson)  double commissionRate, @JsonKey(fromJson: looseDoubleFromJson)  double bonusAmount, @JsonKey(fromJson: looseDoubleFromJson)  double deductionAmount, @JsonKey(fromJson: looseDoubleFromJson)  double manualDeductionAmount, @JsonKey(fromJson: PayrollDeductionLine.listFromJson)  List<PayrollDeductionLine> deductionLines, @JsonKey(fromJson: looseDoubleFromJson)  double netAmount, @JsonKey(fromJson: _statusFromJson)  String status, @JsonKey(fromJson: looseIntFromJson)  int month, @JsonKey(fromJson: looseIntFromJson)  int year, @JsonKey(fromJson: nullableLooseStringFromJson)  String? notes, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? paidAt, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? createdAt, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _PayrollRecord() when $default != null:
return $default(_that.id,_that.salonId,_that.employeeId,_that.employeeName,_that.periodStart,_that.periodEnd,_that.baseAmount,_that.commissionAmount,_that.totalSales,_that.commissionRate,_that.bonusAmount,_that.deductionAmount,_that.manualDeductionAmount,_that.deductionLines,_that.netAmount,_that.status,_that.month,_that.year,_that.notes,_that.paidAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PayrollRecord extends PayrollRecord {
  const _PayrollRecord({@JsonKey(fromJson: looseStringFromJson) required this.id, @JsonKey(fromJson: looseStringFromJson) required this.salonId, @JsonKey(fromJson: looseStringFromJson) required this.employeeId, @JsonKey(fromJson: looseStringFromJson) required this.employeeName, @JsonKey(fromJson: firestoreDateTimeFromJson, toJson: firestoreDateTimeToJson) required this.periodStart, @JsonKey(fromJson: firestoreDateTimeFromJson, toJson: firestoreDateTimeToJson) required this.periodEnd, @JsonKey(fromJson: looseDoubleFromJson) required this.baseAmount, @JsonKey(fromJson: looseDoubleFromJson) required this.commissionAmount, @JsonKey(fromJson: looseDoubleFromJson) this.totalSales = 0, @JsonKey(fromJson: looseDoubleFromJson) this.commissionRate = 0, @JsonKey(fromJson: looseDoubleFromJson) required this.bonusAmount, @JsonKey(fromJson: looseDoubleFromJson) required this.deductionAmount, @JsonKey(fromJson: looseDoubleFromJson) this.manualDeductionAmount = 0, @JsonKey(fromJson: PayrollDeductionLine.listFromJson) final  List<PayrollDeductionLine> deductionLines = const <PayrollDeductionLine>[], @JsonKey(fromJson: looseDoubleFromJson) required this.netAmount, @JsonKey(fromJson: _statusFromJson) required this.status, @JsonKey(fromJson: looseIntFromJson) this.month = 0, @JsonKey(fromJson: looseIntFromJson) this.year = 0, @JsonKey(fromJson: nullableLooseStringFromJson) this.notes, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) this.paidAt, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) this.createdAt, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) this.updatedAt}): _deductionLines = deductionLines,super._();
  factory _PayrollRecord.fromJson(Map<String, dynamic> json) => _$PayrollRecordFromJson(json);

@override@JsonKey(fromJson: looseStringFromJson) final  String id;
@override@JsonKey(fromJson: looseStringFromJson) final  String salonId;
@override@JsonKey(fromJson: looseStringFromJson) final  String employeeId;
@override@JsonKey(fromJson: looseStringFromJson) final  String employeeName;
@override@JsonKey(fromJson: firestoreDateTimeFromJson, toJson: firestoreDateTimeToJson) final  DateTime periodStart;
@override@JsonKey(fromJson: firestoreDateTimeFromJson, toJson: firestoreDateTimeToJson) final  DateTime periodEnd;
@override@JsonKey(fromJson: looseDoubleFromJson) final  double baseAmount;
@override@JsonKey(fromJson: looseDoubleFromJson) final  double commissionAmount;
@override@JsonKey(fromJson: looseDoubleFromJson) final  double totalSales;
@override@JsonKey(fromJson: looseDoubleFromJson) final  double commissionRate;
@override@JsonKey(fromJson: looseDoubleFromJson) final  double bonusAmount;
@override@JsonKey(fromJson: looseDoubleFromJson) final  double deductionAmount;
@override@JsonKey(fromJson: looseDoubleFromJson) final  double manualDeductionAmount;
 final  List<PayrollDeductionLine> _deductionLines;
@override@JsonKey(fromJson: PayrollDeductionLine.listFromJson) List<PayrollDeductionLine> get deductionLines {
  if (_deductionLines is EqualUnmodifiableListView) return _deductionLines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_deductionLines);
}

@override@JsonKey(fromJson: looseDoubleFromJson) final  double netAmount;
@override@JsonKey(fromJson: _statusFromJson) final  String status;
@override@JsonKey(fromJson: looseIntFromJson) final  int month;
@override@JsonKey(fromJson: looseIntFromJson) final  int year;
@override@JsonKey(fromJson: nullableLooseStringFromJson) final  String? notes;
@override@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) final  DateTime? paidAt;
@override@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) final  DateTime? createdAt;
@override@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) final  DateTime? updatedAt;

/// Create a copy of PayrollRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PayrollRecordCopyWith<_PayrollRecord> get copyWith => __$PayrollRecordCopyWithImpl<_PayrollRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PayrollRecordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PayrollRecord&&(identical(other.id, id) || other.id == id)&&(identical(other.salonId, salonId) || other.salonId == salonId)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.employeeName, employeeName) || other.employeeName == employeeName)&&(identical(other.periodStart, periodStart) || other.periodStart == periodStart)&&(identical(other.periodEnd, periodEnd) || other.periodEnd == periodEnd)&&(identical(other.baseAmount, baseAmount) || other.baseAmount == baseAmount)&&(identical(other.commissionAmount, commissionAmount) || other.commissionAmount == commissionAmount)&&(identical(other.totalSales, totalSales) || other.totalSales == totalSales)&&(identical(other.commissionRate, commissionRate) || other.commissionRate == commissionRate)&&(identical(other.bonusAmount, bonusAmount) || other.bonusAmount == bonusAmount)&&(identical(other.deductionAmount, deductionAmount) || other.deductionAmount == deductionAmount)&&(identical(other.manualDeductionAmount, manualDeductionAmount) || other.manualDeductionAmount == manualDeductionAmount)&&const DeepCollectionEquality().equals(other._deductionLines, _deductionLines)&&(identical(other.netAmount, netAmount) || other.netAmount == netAmount)&&(identical(other.status, status) || other.status == status)&&(identical(other.month, month) || other.month == month)&&(identical(other.year, year) || other.year == year)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,salonId,employeeId,employeeName,periodStart,periodEnd,baseAmount,commissionAmount,totalSales,commissionRate,bonusAmount,deductionAmount,manualDeductionAmount,const DeepCollectionEquality().hash(_deductionLines),netAmount,status,month,year,notes,paidAt,createdAt,updatedAt]);

@override
String toString() {
  return 'PayrollRecord(id: $id, salonId: $salonId, employeeId: $employeeId, employeeName: $employeeName, periodStart: $periodStart, periodEnd: $periodEnd, baseAmount: $baseAmount, commissionAmount: $commissionAmount, totalSales: $totalSales, commissionRate: $commissionRate, bonusAmount: $bonusAmount, deductionAmount: $deductionAmount, manualDeductionAmount: $manualDeductionAmount, deductionLines: $deductionLines, netAmount: $netAmount, status: $status, month: $month, year: $year, notes: $notes, paidAt: $paidAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PayrollRecordCopyWith<$Res> implements $PayrollRecordCopyWith<$Res> {
  factory _$PayrollRecordCopyWith(_PayrollRecord value, $Res Function(_PayrollRecord) _then) = __$PayrollRecordCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: looseStringFromJson) String id,@JsonKey(fromJson: looseStringFromJson) String salonId,@JsonKey(fromJson: looseStringFromJson) String employeeId,@JsonKey(fromJson: looseStringFromJson) String employeeName,@JsonKey(fromJson: firestoreDateTimeFromJson, toJson: firestoreDateTimeToJson) DateTime periodStart,@JsonKey(fromJson: firestoreDateTimeFromJson, toJson: firestoreDateTimeToJson) DateTime periodEnd,@JsonKey(fromJson: looseDoubleFromJson) double baseAmount,@JsonKey(fromJson: looseDoubleFromJson) double commissionAmount,@JsonKey(fromJson: looseDoubleFromJson) double totalSales,@JsonKey(fromJson: looseDoubleFromJson) double commissionRate,@JsonKey(fromJson: looseDoubleFromJson) double bonusAmount,@JsonKey(fromJson: looseDoubleFromJson) double deductionAmount,@JsonKey(fromJson: looseDoubleFromJson) double manualDeductionAmount,@JsonKey(fromJson: PayrollDeductionLine.listFromJson) List<PayrollDeductionLine> deductionLines,@JsonKey(fromJson: looseDoubleFromJson) double netAmount,@JsonKey(fromJson: _statusFromJson) String status,@JsonKey(fromJson: looseIntFromJson) int month,@JsonKey(fromJson: looseIntFromJson) int year,@JsonKey(fromJson: nullableLooseStringFromJson) String? notes,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? paidAt,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? createdAt,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? updatedAt
});




}
/// @nodoc
class __$PayrollRecordCopyWithImpl<$Res>
    implements _$PayrollRecordCopyWith<$Res> {
  __$PayrollRecordCopyWithImpl(this._self, this._then);

  final _PayrollRecord _self;
  final $Res Function(_PayrollRecord) _then;

/// Create a copy of PayrollRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? salonId = null,Object? employeeId = null,Object? employeeName = null,Object? periodStart = null,Object? periodEnd = null,Object? baseAmount = null,Object? commissionAmount = null,Object? totalSales = null,Object? commissionRate = null,Object? bonusAmount = null,Object? deductionAmount = null,Object? manualDeductionAmount = null,Object? deductionLines = null,Object? netAmount = null,Object? status = null,Object? month = null,Object? year = null,Object? notes = freezed,Object? paidAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_PayrollRecord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,salonId: null == salonId ? _self.salonId : salonId // ignore: cast_nullable_to_non_nullable
as String,employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String,employeeName: null == employeeName ? _self.employeeName : employeeName // ignore: cast_nullable_to_non_nullable
as String,periodStart: null == periodStart ? _self.periodStart : periodStart // ignore: cast_nullable_to_non_nullable
as DateTime,periodEnd: null == periodEnd ? _self.periodEnd : periodEnd // ignore: cast_nullable_to_non_nullable
as DateTime,baseAmount: null == baseAmount ? _self.baseAmount : baseAmount // ignore: cast_nullable_to_non_nullable
as double,commissionAmount: null == commissionAmount ? _self.commissionAmount : commissionAmount // ignore: cast_nullable_to_non_nullable
as double,totalSales: null == totalSales ? _self.totalSales : totalSales // ignore: cast_nullable_to_non_nullable
as double,commissionRate: null == commissionRate ? _self.commissionRate : commissionRate // ignore: cast_nullable_to_non_nullable
as double,bonusAmount: null == bonusAmount ? _self.bonusAmount : bonusAmount // ignore: cast_nullable_to_non_nullable
as double,deductionAmount: null == deductionAmount ? _self.deductionAmount : deductionAmount // ignore: cast_nullable_to_non_nullable
as double,manualDeductionAmount: null == manualDeductionAmount ? _self.manualDeductionAmount : manualDeductionAmount // ignore: cast_nullable_to_non_nullable
as double,deductionLines: null == deductionLines ? _self._deductionLines : deductionLines // ignore: cast_nullable_to_non_nullable
as List<PayrollDeductionLine>,netAmount: null == netAmount ? _self.netAmount : netAmount // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
