// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'employee_element_entry_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EmployeeElementEntryModel {

@JsonKey(fromJson: looseStringFromJson) String get id;@JsonKey(fromJson: looseStringFromJson) String get employeeId;@JsonKey(fromJson: looseStringFromJson) String get employeeName;@JsonKey(fromJson: looseStringFromJson) String get elementCode;@JsonKey(fromJson: looseStringFromJson) String get elementName;@JsonKey(fromJson: _classificationFromJson) String get classification;@JsonKey(fromJson: _recurrenceTypeFromJson) String get recurrenceType;@JsonKey(fromJson: looseDoubleFromJson) double get amount;@JsonKey(fromJson: nullableLooseDoubleFromJson) double? get percentage;@JsonKey(fromJson: nullableStringDynamicMapFromJson, toJson: nullableStringDynamicMapToJson) Map<String, dynamic>? get formulaConfig;@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? get startDate;@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? get endDate;@JsonKey(fromJson: nullableLooseIntFromJson) int? get payrollYear;@JsonKey(fromJson: nullableLooseIntFromJson) int? get payrollMonth;@JsonKey(fromJson: _statusFromJson) String get status;@JsonKey(fromJson: nullableLooseStringFromJson) String? get note;@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? get createdAt;@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? get updatedAt;
/// Create a copy of EmployeeElementEntryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmployeeElementEntryModelCopyWith<EmployeeElementEntryModel> get copyWith => _$EmployeeElementEntryModelCopyWithImpl<EmployeeElementEntryModel>(this as EmployeeElementEntryModel, _$identity);

  /// Serializes this EmployeeElementEntryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmployeeElementEntryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.employeeName, employeeName) || other.employeeName == employeeName)&&(identical(other.elementCode, elementCode) || other.elementCode == elementCode)&&(identical(other.elementName, elementName) || other.elementName == elementName)&&(identical(other.classification, classification) || other.classification == classification)&&(identical(other.recurrenceType, recurrenceType) || other.recurrenceType == recurrenceType)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.percentage, percentage) || other.percentage == percentage)&&const DeepCollectionEquality().equals(other.formulaConfig, formulaConfig)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.payrollYear, payrollYear) || other.payrollYear == payrollYear)&&(identical(other.payrollMonth, payrollMonth) || other.payrollMonth == payrollMonth)&&(identical(other.status, status) || other.status == status)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,employeeId,employeeName,elementCode,elementName,classification,recurrenceType,amount,percentage,const DeepCollectionEquality().hash(formulaConfig),startDate,endDate,payrollYear,payrollMonth,status,note,createdAt,updatedAt);

@override
String toString() {
  return 'EmployeeElementEntryModel(id: $id, employeeId: $employeeId, employeeName: $employeeName, elementCode: $elementCode, elementName: $elementName, classification: $classification, recurrenceType: $recurrenceType, amount: $amount, percentage: $percentage, formulaConfig: $formulaConfig, startDate: $startDate, endDate: $endDate, payrollYear: $payrollYear, payrollMonth: $payrollMonth, status: $status, note: $note, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $EmployeeElementEntryModelCopyWith<$Res>  {
  factory $EmployeeElementEntryModelCopyWith(EmployeeElementEntryModel value, $Res Function(EmployeeElementEntryModel) _then) = _$EmployeeElementEntryModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: looseStringFromJson) String id,@JsonKey(fromJson: looseStringFromJson) String employeeId,@JsonKey(fromJson: looseStringFromJson) String employeeName,@JsonKey(fromJson: looseStringFromJson) String elementCode,@JsonKey(fromJson: looseStringFromJson) String elementName,@JsonKey(fromJson: _classificationFromJson) String classification,@JsonKey(fromJson: _recurrenceTypeFromJson) String recurrenceType,@JsonKey(fromJson: looseDoubleFromJson) double amount,@JsonKey(fromJson: nullableLooseDoubleFromJson) double? percentage,@JsonKey(fromJson: nullableStringDynamicMapFromJson, toJson: nullableStringDynamicMapToJson) Map<String, dynamic>? formulaConfig,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? startDate,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? endDate,@JsonKey(fromJson: nullableLooseIntFromJson) int? payrollYear,@JsonKey(fromJson: nullableLooseIntFromJson) int? payrollMonth,@JsonKey(fromJson: _statusFromJson) String status,@JsonKey(fromJson: nullableLooseStringFromJson) String? note,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? createdAt,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? updatedAt
});




}
/// @nodoc
class _$EmployeeElementEntryModelCopyWithImpl<$Res>
    implements $EmployeeElementEntryModelCopyWith<$Res> {
  _$EmployeeElementEntryModelCopyWithImpl(this._self, this._then);

  final EmployeeElementEntryModel _self;
  final $Res Function(EmployeeElementEntryModel) _then;

/// Create a copy of EmployeeElementEntryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? employeeId = null,Object? employeeName = null,Object? elementCode = null,Object? elementName = null,Object? classification = null,Object? recurrenceType = null,Object? amount = null,Object? percentage = freezed,Object? formulaConfig = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? payrollYear = freezed,Object? payrollMonth = freezed,Object? status = null,Object? note = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String,employeeName: null == employeeName ? _self.employeeName : employeeName // ignore: cast_nullable_to_non_nullable
as String,elementCode: null == elementCode ? _self.elementCode : elementCode // ignore: cast_nullable_to_non_nullable
as String,elementName: null == elementName ? _self.elementName : elementName // ignore: cast_nullable_to_non_nullable
as String,classification: null == classification ? _self.classification : classification // ignore: cast_nullable_to_non_nullable
as String,recurrenceType: null == recurrenceType ? _self.recurrenceType : recurrenceType // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,percentage: freezed == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double?,formulaConfig: freezed == formulaConfig ? _self.formulaConfig : formulaConfig // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,payrollYear: freezed == payrollYear ? _self.payrollYear : payrollYear // ignore: cast_nullable_to_non_nullable
as int?,payrollMonth: freezed == payrollMonth ? _self.payrollMonth : payrollMonth // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [EmployeeElementEntryModel].
extension EmployeeElementEntryModelPatterns on EmployeeElementEntryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmployeeElementEntryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmployeeElementEntryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmployeeElementEntryModel value)  $default,){
final _that = this;
switch (_that) {
case _EmployeeElementEntryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmployeeElementEntryModel value)?  $default,){
final _that = this;
switch (_that) {
case _EmployeeElementEntryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: looseStringFromJson)  String id, @JsonKey(fromJson: looseStringFromJson)  String employeeId, @JsonKey(fromJson: looseStringFromJson)  String employeeName, @JsonKey(fromJson: looseStringFromJson)  String elementCode, @JsonKey(fromJson: looseStringFromJson)  String elementName, @JsonKey(fromJson: _classificationFromJson)  String classification, @JsonKey(fromJson: _recurrenceTypeFromJson)  String recurrenceType, @JsonKey(fromJson: looseDoubleFromJson)  double amount, @JsonKey(fromJson: nullableLooseDoubleFromJson)  double? percentage, @JsonKey(fromJson: nullableStringDynamicMapFromJson, toJson: nullableStringDynamicMapToJson)  Map<String, dynamic>? formulaConfig, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? startDate, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? endDate, @JsonKey(fromJson: nullableLooseIntFromJson)  int? payrollYear, @JsonKey(fromJson: nullableLooseIntFromJson)  int? payrollMonth, @JsonKey(fromJson: _statusFromJson)  String status, @JsonKey(fromJson: nullableLooseStringFromJson)  String? note, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? createdAt, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmployeeElementEntryModel() when $default != null:
return $default(_that.id,_that.employeeId,_that.employeeName,_that.elementCode,_that.elementName,_that.classification,_that.recurrenceType,_that.amount,_that.percentage,_that.formulaConfig,_that.startDate,_that.endDate,_that.payrollYear,_that.payrollMonth,_that.status,_that.note,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: looseStringFromJson)  String id, @JsonKey(fromJson: looseStringFromJson)  String employeeId, @JsonKey(fromJson: looseStringFromJson)  String employeeName, @JsonKey(fromJson: looseStringFromJson)  String elementCode, @JsonKey(fromJson: looseStringFromJson)  String elementName, @JsonKey(fromJson: _classificationFromJson)  String classification, @JsonKey(fromJson: _recurrenceTypeFromJson)  String recurrenceType, @JsonKey(fromJson: looseDoubleFromJson)  double amount, @JsonKey(fromJson: nullableLooseDoubleFromJson)  double? percentage, @JsonKey(fromJson: nullableStringDynamicMapFromJson, toJson: nullableStringDynamicMapToJson)  Map<String, dynamic>? formulaConfig, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? startDate, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? endDate, @JsonKey(fromJson: nullableLooseIntFromJson)  int? payrollYear, @JsonKey(fromJson: nullableLooseIntFromJson)  int? payrollMonth, @JsonKey(fromJson: _statusFromJson)  String status, @JsonKey(fromJson: nullableLooseStringFromJson)  String? note, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? createdAt, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _EmployeeElementEntryModel():
return $default(_that.id,_that.employeeId,_that.employeeName,_that.elementCode,_that.elementName,_that.classification,_that.recurrenceType,_that.amount,_that.percentage,_that.formulaConfig,_that.startDate,_that.endDate,_that.payrollYear,_that.payrollMonth,_that.status,_that.note,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: looseStringFromJson)  String id, @JsonKey(fromJson: looseStringFromJson)  String employeeId, @JsonKey(fromJson: looseStringFromJson)  String employeeName, @JsonKey(fromJson: looseStringFromJson)  String elementCode, @JsonKey(fromJson: looseStringFromJson)  String elementName, @JsonKey(fromJson: _classificationFromJson)  String classification, @JsonKey(fromJson: _recurrenceTypeFromJson)  String recurrenceType, @JsonKey(fromJson: looseDoubleFromJson)  double amount, @JsonKey(fromJson: nullableLooseDoubleFromJson)  double? percentage, @JsonKey(fromJson: nullableStringDynamicMapFromJson, toJson: nullableStringDynamicMapToJson)  Map<String, dynamic>? formulaConfig, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? startDate, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? endDate, @JsonKey(fromJson: nullableLooseIntFromJson)  int? payrollYear, @JsonKey(fromJson: nullableLooseIntFromJson)  int? payrollMonth, @JsonKey(fromJson: _statusFromJson)  String status, @JsonKey(fromJson: nullableLooseStringFromJson)  String? note, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? createdAt, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _EmployeeElementEntryModel() when $default != null:
return $default(_that.id,_that.employeeId,_that.employeeName,_that.elementCode,_that.elementName,_that.classification,_that.recurrenceType,_that.amount,_that.percentage,_that.formulaConfig,_that.startDate,_that.endDate,_that.payrollYear,_that.payrollMonth,_that.status,_that.note,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EmployeeElementEntryModel extends EmployeeElementEntryModel {
  const _EmployeeElementEntryModel({@JsonKey(fromJson: looseStringFromJson) required this.id, @JsonKey(fromJson: looseStringFromJson) required this.employeeId, @JsonKey(fromJson: looseStringFromJson) required this.employeeName, @JsonKey(fromJson: looseStringFromJson) required this.elementCode, @JsonKey(fromJson: looseStringFromJson) required this.elementName, @JsonKey(fromJson: _classificationFromJson) required this.classification, @JsonKey(fromJson: _recurrenceTypeFromJson) required this.recurrenceType, @JsonKey(fromJson: looseDoubleFromJson) this.amount = 0, @JsonKey(fromJson: nullableLooseDoubleFromJson) this.percentage, @JsonKey(fromJson: nullableStringDynamicMapFromJson, toJson: nullableStringDynamicMapToJson) final  Map<String, dynamic>? formulaConfig, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) this.startDate, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) this.endDate, @JsonKey(fromJson: nullableLooseIntFromJson) this.payrollYear, @JsonKey(fromJson: nullableLooseIntFromJson) this.payrollMonth, @JsonKey(fromJson: _statusFromJson) this.status = PayrollEntryStatuses.active, @JsonKey(fromJson: nullableLooseStringFromJson) this.note, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) this.createdAt, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) this.updatedAt}): _formulaConfig = formulaConfig,super._();
  factory _EmployeeElementEntryModel.fromJson(Map<String, dynamic> json) => _$EmployeeElementEntryModelFromJson(json);

@override@JsonKey(fromJson: looseStringFromJson) final  String id;
@override@JsonKey(fromJson: looseStringFromJson) final  String employeeId;
@override@JsonKey(fromJson: looseStringFromJson) final  String employeeName;
@override@JsonKey(fromJson: looseStringFromJson) final  String elementCode;
@override@JsonKey(fromJson: looseStringFromJson) final  String elementName;
@override@JsonKey(fromJson: _classificationFromJson) final  String classification;
@override@JsonKey(fromJson: _recurrenceTypeFromJson) final  String recurrenceType;
@override@JsonKey(fromJson: looseDoubleFromJson) final  double amount;
@override@JsonKey(fromJson: nullableLooseDoubleFromJson) final  double? percentage;
 final  Map<String, dynamic>? _formulaConfig;
@override@JsonKey(fromJson: nullableStringDynamicMapFromJson, toJson: nullableStringDynamicMapToJson) Map<String, dynamic>? get formulaConfig {
  final value = _formulaConfig;
  if (value == null) return null;
  if (_formulaConfig is EqualUnmodifiableMapView) return _formulaConfig;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) final  DateTime? startDate;
@override@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) final  DateTime? endDate;
@override@JsonKey(fromJson: nullableLooseIntFromJson) final  int? payrollYear;
@override@JsonKey(fromJson: nullableLooseIntFromJson) final  int? payrollMonth;
@override@JsonKey(fromJson: _statusFromJson) final  String status;
@override@JsonKey(fromJson: nullableLooseStringFromJson) final  String? note;
@override@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) final  DateTime? createdAt;
@override@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) final  DateTime? updatedAt;

/// Create a copy of EmployeeElementEntryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmployeeElementEntryModelCopyWith<_EmployeeElementEntryModel> get copyWith => __$EmployeeElementEntryModelCopyWithImpl<_EmployeeElementEntryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EmployeeElementEntryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmployeeElementEntryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.employeeName, employeeName) || other.employeeName == employeeName)&&(identical(other.elementCode, elementCode) || other.elementCode == elementCode)&&(identical(other.elementName, elementName) || other.elementName == elementName)&&(identical(other.classification, classification) || other.classification == classification)&&(identical(other.recurrenceType, recurrenceType) || other.recurrenceType == recurrenceType)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.percentage, percentage) || other.percentage == percentage)&&const DeepCollectionEquality().equals(other._formulaConfig, _formulaConfig)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.payrollYear, payrollYear) || other.payrollYear == payrollYear)&&(identical(other.payrollMonth, payrollMonth) || other.payrollMonth == payrollMonth)&&(identical(other.status, status) || other.status == status)&&(identical(other.note, note) || other.note == note)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,employeeId,employeeName,elementCode,elementName,classification,recurrenceType,amount,percentage,const DeepCollectionEquality().hash(_formulaConfig),startDate,endDate,payrollYear,payrollMonth,status,note,createdAt,updatedAt);

@override
String toString() {
  return 'EmployeeElementEntryModel(id: $id, employeeId: $employeeId, employeeName: $employeeName, elementCode: $elementCode, elementName: $elementName, classification: $classification, recurrenceType: $recurrenceType, amount: $amount, percentage: $percentage, formulaConfig: $formulaConfig, startDate: $startDate, endDate: $endDate, payrollYear: $payrollYear, payrollMonth: $payrollMonth, status: $status, note: $note, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$EmployeeElementEntryModelCopyWith<$Res> implements $EmployeeElementEntryModelCopyWith<$Res> {
  factory _$EmployeeElementEntryModelCopyWith(_EmployeeElementEntryModel value, $Res Function(_EmployeeElementEntryModel) _then) = __$EmployeeElementEntryModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: looseStringFromJson) String id,@JsonKey(fromJson: looseStringFromJson) String employeeId,@JsonKey(fromJson: looseStringFromJson) String employeeName,@JsonKey(fromJson: looseStringFromJson) String elementCode,@JsonKey(fromJson: looseStringFromJson) String elementName,@JsonKey(fromJson: _classificationFromJson) String classification,@JsonKey(fromJson: _recurrenceTypeFromJson) String recurrenceType,@JsonKey(fromJson: looseDoubleFromJson) double amount,@JsonKey(fromJson: nullableLooseDoubleFromJson) double? percentage,@JsonKey(fromJson: nullableStringDynamicMapFromJson, toJson: nullableStringDynamicMapToJson) Map<String, dynamic>? formulaConfig,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? startDate,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? endDate,@JsonKey(fromJson: nullableLooseIntFromJson) int? payrollYear,@JsonKey(fromJson: nullableLooseIntFromJson) int? payrollMonth,@JsonKey(fromJson: _statusFromJson) String status,@JsonKey(fromJson: nullableLooseStringFromJson) String? note,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? createdAt,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? updatedAt
});




}
/// @nodoc
class __$EmployeeElementEntryModelCopyWithImpl<$Res>
    implements _$EmployeeElementEntryModelCopyWith<$Res> {
  __$EmployeeElementEntryModelCopyWithImpl(this._self, this._then);

  final _EmployeeElementEntryModel _self;
  final $Res Function(_EmployeeElementEntryModel) _then;

/// Create a copy of EmployeeElementEntryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? employeeId = null,Object? employeeName = null,Object? elementCode = null,Object? elementName = null,Object? classification = null,Object? recurrenceType = null,Object? amount = null,Object? percentage = freezed,Object? formulaConfig = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? payrollYear = freezed,Object? payrollMonth = freezed,Object? status = null,Object? note = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_EmployeeElementEntryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String,employeeName: null == employeeName ? _self.employeeName : employeeName // ignore: cast_nullable_to_non_nullable
as String,elementCode: null == elementCode ? _self.elementCode : elementCode // ignore: cast_nullable_to_non_nullable
as String,elementName: null == elementName ? _self.elementName : elementName // ignore: cast_nullable_to_non_nullable
as String,classification: null == classification ? _self.classification : classification // ignore: cast_nullable_to_non_nullable
as String,recurrenceType: null == recurrenceType ? _self.recurrenceType : recurrenceType // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,percentage: freezed == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double?,formulaConfig: freezed == formulaConfig ? _self._formulaConfig : formulaConfig // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,payrollYear: freezed == payrollYear ? _self.payrollYear : payrollYear // ignore: cast_nullable_to_non_nullable
as int?,payrollMonth: freezed == payrollMonth ? _self.payrollMonth : payrollMonth // ignore: cast_nullable_to_non_nullable
as int?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
