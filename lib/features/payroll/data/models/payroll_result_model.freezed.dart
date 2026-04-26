// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payroll_result_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PayrollResultModel {

@JsonKey(fromJson: looseStringFromJson) String get id;@JsonKey(fromJson: looseStringFromJson) String get payrollRunId;@JsonKey(fromJson: looseStringFromJson) String get employeeId;@JsonKey(fromJson: looseStringFromJson) String get employeeName;@JsonKey(fromJson: looseStringFromJson) String get elementCode;@JsonKey(fromJson: looseStringFromJson) String get elementName;@JsonKey(fromJson: _classificationFromJson) String get classification;@JsonKey(fromJson: _recurrenceTypeFromJson) String get recurrenceType;@JsonKey(fromJson: looseDoubleFromJson) double get amount;@JsonKey(fromJson: nullableLooseDoubleFromJson) double? get quantity;@JsonKey(fromJson: nullableLooseDoubleFromJson) double? get rate;@JsonKey(fromJson: _sourceTypeFromJson) String get sourceType;@JsonKey(fromJson: stringListFromJson) List<String> get sourceRefIds;@JsonKey(fromJson: trueBoolFromJson) bool get visibleOnPayslip;@JsonKey(fromJson: looseIntFromJson) int get displayOrder;@JsonKey(fromJson: nullableLooseStringFromJson) String? get calculationSource;@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? get createdAt;
/// Create a copy of PayrollResultModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PayrollResultModelCopyWith<PayrollResultModel> get copyWith => _$PayrollResultModelCopyWithImpl<PayrollResultModel>(this as PayrollResultModel, _$identity);

  /// Serializes this PayrollResultModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PayrollResultModel&&(identical(other.id, id) || other.id == id)&&(identical(other.payrollRunId, payrollRunId) || other.payrollRunId == payrollRunId)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.employeeName, employeeName) || other.employeeName == employeeName)&&(identical(other.elementCode, elementCode) || other.elementCode == elementCode)&&(identical(other.elementName, elementName) || other.elementName == elementName)&&(identical(other.classification, classification) || other.classification == classification)&&(identical(other.recurrenceType, recurrenceType) || other.recurrenceType == recurrenceType)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.rate, rate) || other.rate == rate)&&(identical(other.sourceType, sourceType) || other.sourceType == sourceType)&&const DeepCollectionEquality().equals(other.sourceRefIds, sourceRefIds)&&(identical(other.visibleOnPayslip, visibleOnPayslip) || other.visibleOnPayslip == visibleOnPayslip)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder)&&(identical(other.calculationSource, calculationSource) || other.calculationSource == calculationSource)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,payrollRunId,employeeId,employeeName,elementCode,elementName,classification,recurrenceType,amount,quantity,rate,sourceType,const DeepCollectionEquality().hash(sourceRefIds),visibleOnPayslip,displayOrder,calculationSource,createdAt);

@override
String toString() {
  return 'PayrollResultModel(id: $id, payrollRunId: $payrollRunId, employeeId: $employeeId, employeeName: $employeeName, elementCode: $elementCode, elementName: $elementName, classification: $classification, recurrenceType: $recurrenceType, amount: $amount, quantity: $quantity, rate: $rate, sourceType: $sourceType, sourceRefIds: $sourceRefIds, visibleOnPayslip: $visibleOnPayslip, displayOrder: $displayOrder, calculationSource: $calculationSource, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $PayrollResultModelCopyWith<$Res>  {
  factory $PayrollResultModelCopyWith(PayrollResultModel value, $Res Function(PayrollResultModel) _then) = _$PayrollResultModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: looseStringFromJson) String id,@JsonKey(fromJson: looseStringFromJson) String payrollRunId,@JsonKey(fromJson: looseStringFromJson) String employeeId,@JsonKey(fromJson: looseStringFromJson) String employeeName,@JsonKey(fromJson: looseStringFromJson) String elementCode,@JsonKey(fromJson: looseStringFromJson) String elementName,@JsonKey(fromJson: _classificationFromJson) String classification,@JsonKey(fromJson: _recurrenceTypeFromJson) String recurrenceType,@JsonKey(fromJson: looseDoubleFromJson) double amount,@JsonKey(fromJson: nullableLooseDoubleFromJson) double? quantity,@JsonKey(fromJson: nullableLooseDoubleFromJson) double? rate,@JsonKey(fromJson: _sourceTypeFromJson) String sourceType,@JsonKey(fromJson: stringListFromJson) List<String> sourceRefIds,@JsonKey(fromJson: trueBoolFromJson) bool visibleOnPayslip,@JsonKey(fromJson: looseIntFromJson) int displayOrder,@JsonKey(fromJson: nullableLooseStringFromJson) String? calculationSource,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? createdAt
});




}
/// @nodoc
class _$PayrollResultModelCopyWithImpl<$Res>
    implements $PayrollResultModelCopyWith<$Res> {
  _$PayrollResultModelCopyWithImpl(this._self, this._then);

  final PayrollResultModel _self;
  final $Res Function(PayrollResultModel) _then;

/// Create a copy of PayrollResultModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? payrollRunId = null,Object? employeeId = null,Object? employeeName = null,Object? elementCode = null,Object? elementName = null,Object? classification = null,Object? recurrenceType = null,Object? amount = null,Object? quantity = freezed,Object? rate = freezed,Object? sourceType = null,Object? sourceRefIds = null,Object? visibleOnPayslip = null,Object? displayOrder = null,Object? calculationSource = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,payrollRunId: null == payrollRunId ? _self.payrollRunId : payrollRunId // ignore: cast_nullable_to_non_nullable
as String,employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String,employeeName: null == employeeName ? _self.employeeName : employeeName // ignore: cast_nullable_to_non_nullable
as String,elementCode: null == elementCode ? _self.elementCode : elementCode // ignore: cast_nullable_to_non_nullable
as String,elementName: null == elementName ? _self.elementName : elementName // ignore: cast_nullable_to_non_nullable
as String,classification: null == classification ? _self.classification : classification // ignore: cast_nullable_to_non_nullable
as String,recurrenceType: null == recurrenceType ? _self.recurrenceType : recurrenceType // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double?,rate: freezed == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as double?,sourceType: null == sourceType ? _self.sourceType : sourceType // ignore: cast_nullable_to_non_nullable
as String,sourceRefIds: null == sourceRefIds ? _self.sourceRefIds : sourceRefIds // ignore: cast_nullable_to_non_nullable
as List<String>,visibleOnPayslip: null == visibleOnPayslip ? _self.visibleOnPayslip : visibleOnPayslip // ignore: cast_nullable_to_non_nullable
as bool,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,calculationSource: freezed == calculationSource ? _self.calculationSource : calculationSource // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PayrollResultModel].
extension PayrollResultModelPatterns on PayrollResultModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PayrollResultModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PayrollResultModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PayrollResultModel value)  $default,){
final _that = this;
switch (_that) {
case _PayrollResultModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PayrollResultModel value)?  $default,){
final _that = this;
switch (_that) {
case _PayrollResultModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: looseStringFromJson)  String id, @JsonKey(fromJson: looseStringFromJson)  String payrollRunId, @JsonKey(fromJson: looseStringFromJson)  String employeeId, @JsonKey(fromJson: looseStringFromJson)  String employeeName, @JsonKey(fromJson: looseStringFromJson)  String elementCode, @JsonKey(fromJson: looseStringFromJson)  String elementName, @JsonKey(fromJson: _classificationFromJson)  String classification, @JsonKey(fromJson: _recurrenceTypeFromJson)  String recurrenceType, @JsonKey(fromJson: looseDoubleFromJson)  double amount, @JsonKey(fromJson: nullableLooseDoubleFromJson)  double? quantity, @JsonKey(fromJson: nullableLooseDoubleFromJson)  double? rate, @JsonKey(fromJson: _sourceTypeFromJson)  String sourceType, @JsonKey(fromJson: stringListFromJson)  List<String> sourceRefIds, @JsonKey(fromJson: trueBoolFromJson)  bool visibleOnPayslip, @JsonKey(fromJson: looseIntFromJson)  int displayOrder, @JsonKey(fromJson: nullableLooseStringFromJson)  String? calculationSource, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PayrollResultModel() when $default != null:
return $default(_that.id,_that.payrollRunId,_that.employeeId,_that.employeeName,_that.elementCode,_that.elementName,_that.classification,_that.recurrenceType,_that.amount,_that.quantity,_that.rate,_that.sourceType,_that.sourceRefIds,_that.visibleOnPayslip,_that.displayOrder,_that.calculationSource,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: looseStringFromJson)  String id, @JsonKey(fromJson: looseStringFromJson)  String payrollRunId, @JsonKey(fromJson: looseStringFromJson)  String employeeId, @JsonKey(fromJson: looseStringFromJson)  String employeeName, @JsonKey(fromJson: looseStringFromJson)  String elementCode, @JsonKey(fromJson: looseStringFromJson)  String elementName, @JsonKey(fromJson: _classificationFromJson)  String classification, @JsonKey(fromJson: _recurrenceTypeFromJson)  String recurrenceType, @JsonKey(fromJson: looseDoubleFromJson)  double amount, @JsonKey(fromJson: nullableLooseDoubleFromJson)  double? quantity, @JsonKey(fromJson: nullableLooseDoubleFromJson)  double? rate, @JsonKey(fromJson: _sourceTypeFromJson)  String sourceType, @JsonKey(fromJson: stringListFromJson)  List<String> sourceRefIds, @JsonKey(fromJson: trueBoolFromJson)  bool visibleOnPayslip, @JsonKey(fromJson: looseIntFromJson)  int displayOrder, @JsonKey(fromJson: nullableLooseStringFromJson)  String? calculationSource, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _PayrollResultModel():
return $default(_that.id,_that.payrollRunId,_that.employeeId,_that.employeeName,_that.elementCode,_that.elementName,_that.classification,_that.recurrenceType,_that.amount,_that.quantity,_that.rate,_that.sourceType,_that.sourceRefIds,_that.visibleOnPayslip,_that.displayOrder,_that.calculationSource,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: looseStringFromJson)  String id, @JsonKey(fromJson: looseStringFromJson)  String payrollRunId, @JsonKey(fromJson: looseStringFromJson)  String employeeId, @JsonKey(fromJson: looseStringFromJson)  String employeeName, @JsonKey(fromJson: looseStringFromJson)  String elementCode, @JsonKey(fromJson: looseStringFromJson)  String elementName, @JsonKey(fromJson: _classificationFromJson)  String classification, @JsonKey(fromJson: _recurrenceTypeFromJson)  String recurrenceType, @JsonKey(fromJson: looseDoubleFromJson)  double amount, @JsonKey(fromJson: nullableLooseDoubleFromJson)  double? quantity, @JsonKey(fromJson: nullableLooseDoubleFromJson)  double? rate, @JsonKey(fromJson: _sourceTypeFromJson)  String sourceType, @JsonKey(fromJson: stringListFromJson)  List<String> sourceRefIds, @JsonKey(fromJson: trueBoolFromJson)  bool visibleOnPayslip, @JsonKey(fromJson: looseIntFromJson)  int displayOrder, @JsonKey(fromJson: nullableLooseStringFromJson)  String? calculationSource, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _PayrollResultModel() when $default != null:
return $default(_that.id,_that.payrollRunId,_that.employeeId,_that.employeeName,_that.elementCode,_that.elementName,_that.classification,_that.recurrenceType,_that.amount,_that.quantity,_that.rate,_that.sourceType,_that.sourceRefIds,_that.visibleOnPayslip,_that.displayOrder,_that.calculationSource,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PayrollResultModel implements PayrollResultModel {
  const _PayrollResultModel({@JsonKey(fromJson: looseStringFromJson) required this.id, @JsonKey(fromJson: looseStringFromJson) required this.payrollRunId, @JsonKey(fromJson: looseStringFromJson) required this.employeeId, @JsonKey(fromJson: looseStringFromJson) required this.employeeName, @JsonKey(fromJson: looseStringFromJson) required this.elementCode, @JsonKey(fromJson: looseStringFromJson) required this.elementName, @JsonKey(fromJson: _classificationFromJson) required this.classification, @JsonKey(fromJson: _recurrenceTypeFromJson) required this.recurrenceType, @JsonKey(fromJson: looseDoubleFromJson) required this.amount, @JsonKey(fromJson: nullableLooseDoubleFromJson) this.quantity, @JsonKey(fromJson: nullableLooseDoubleFromJson) this.rate, @JsonKey(fromJson: _sourceTypeFromJson) required this.sourceType, @JsonKey(fromJson: stringListFromJson) final  List<String> sourceRefIds = const <String>[], @JsonKey(fromJson: trueBoolFromJson) this.visibleOnPayslip = true, @JsonKey(fromJson: looseIntFromJson) this.displayOrder = 0, @JsonKey(fromJson: nullableLooseStringFromJson) this.calculationSource, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) this.createdAt}): _sourceRefIds = sourceRefIds;
  factory _PayrollResultModel.fromJson(Map<String, dynamic> json) => _$PayrollResultModelFromJson(json);

@override@JsonKey(fromJson: looseStringFromJson) final  String id;
@override@JsonKey(fromJson: looseStringFromJson) final  String payrollRunId;
@override@JsonKey(fromJson: looseStringFromJson) final  String employeeId;
@override@JsonKey(fromJson: looseStringFromJson) final  String employeeName;
@override@JsonKey(fromJson: looseStringFromJson) final  String elementCode;
@override@JsonKey(fromJson: looseStringFromJson) final  String elementName;
@override@JsonKey(fromJson: _classificationFromJson) final  String classification;
@override@JsonKey(fromJson: _recurrenceTypeFromJson) final  String recurrenceType;
@override@JsonKey(fromJson: looseDoubleFromJson) final  double amount;
@override@JsonKey(fromJson: nullableLooseDoubleFromJson) final  double? quantity;
@override@JsonKey(fromJson: nullableLooseDoubleFromJson) final  double? rate;
@override@JsonKey(fromJson: _sourceTypeFromJson) final  String sourceType;
 final  List<String> _sourceRefIds;
@override@JsonKey(fromJson: stringListFromJson) List<String> get sourceRefIds {
  if (_sourceRefIds is EqualUnmodifiableListView) return _sourceRefIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sourceRefIds);
}

@override@JsonKey(fromJson: trueBoolFromJson) final  bool visibleOnPayslip;
@override@JsonKey(fromJson: looseIntFromJson) final  int displayOrder;
@override@JsonKey(fromJson: nullableLooseStringFromJson) final  String? calculationSource;
@override@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) final  DateTime? createdAt;

/// Create a copy of PayrollResultModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PayrollResultModelCopyWith<_PayrollResultModel> get copyWith => __$PayrollResultModelCopyWithImpl<_PayrollResultModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PayrollResultModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PayrollResultModel&&(identical(other.id, id) || other.id == id)&&(identical(other.payrollRunId, payrollRunId) || other.payrollRunId == payrollRunId)&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.employeeName, employeeName) || other.employeeName == employeeName)&&(identical(other.elementCode, elementCode) || other.elementCode == elementCode)&&(identical(other.elementName, elementName) || other.elementName == elementName)&&(identical(other.classification, classification) || other.classification == classification)&&(identical(other.recurrenceType, recurrenceType) || other.recurrenceType == recurrenceType)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.rate, rate) || other.rate == rate)&&(identical(other.sourceType, sourceType) || other.sourceType == sourceType)&&const DeepCollectionEquality().equals(other._sourceRefIds, _sourceRefIds)&&(identical(other.visibleOnPayslip, visibleOnPayslip) || other.visibleOnPayslip == visibleOnPayslip)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder)&&(identical(other.calculationSource, calculationSource) || other.calculationSource == calculationSource)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,payrollRunId,employeeId,employeeName,elementCode,elementName,classification,recurrenceType,amount,quantity,rate,sourceType,const DeepCollectionEquality().hash(_sourceRefIds),visibleOnPayslip,displayOrder,calculationSource,createdAt);

@override
String toString() {
  return 'PayrollResultModel(id: $id, payrollRunId: $payrollRunId, employeeId: $employeeId, employeeName: $employeeName, elementCode: $elementCode, elementName: $elementName, classification: $classification, recurrenceType: $recurrenceType, amount: $amount, quantity: $quantity, rate: $rate, sourceType: $sourceType, sourceRefIds: $sourceRefIds, visibleOnPayslip: $visibleOnPayslip, displayOrder: $displayOrder, calculationSource: $calculationSource, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PayrollResultModelCopyWith<$Res> implements $PayrollResultModelCopyWith<$Res> {
  factory _$PayrollResultModelCopyWith(_PayrollResultModel value, $Res Function(_PayrollResultModel) _then) = __$PayrollResultModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: looseStringFromJson) String id,@JsonKey(fromJson: looseStringFromJson) String payrollRunId,@JsonKey(fromJson: looseStringFromJson) String employeeId,@JsonKey(fromJson: looseStringFromJson) String employeeName,@JsonKey(fromJson: looseStringFromJson) String elementCode,@JsonKey(fromJson: looseStringFromJson) String elementName,@JsonKey(fromJson: _classificationFromJson) String classification,@JsonKey(fromJson: _recurrenceTypeFromJson) String recurrenceType,@JsonKey(fromJson: looseDoubleFromJson) double amount,@JsonKey(fromJson: nullableLooseDoubleFromJson) double? quantity,@JsonKey(fromJson: nullableLooseDoubleFromJson) double? rate,@JsonKey(fromJson: _sourceTypeFromJson) String sourceType,@JsonKey(fromJson: stringListFromJson) List<String> sourceRefIds,@JsonKey(fromJson: trueBoolFromJson) bool visibleOnPayslip,@JsonKey(fromJson: looseIntFromJson) int displayOrder,@JsonKey(fromJson: nullableLooseStringFromJson) String? calculationSource,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? createdAt
});




}
/// @nodoc
class __$PayrollResultModelCopyWithImpl<$Res>
    implements _$PayrollResultModelCopyWith<$Res> {
  __$PayrollResultModelCopyWithImpl(this._self, this._then);

  final _PayrollResultModel _self;
  final $Res Function(_PayrollResultModel) _then;

/// Create a copy of PayrollResultModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? payrollRunId = null,Object? employeeId = null,Object? employeeName = null,Object? elementCode = null,Object? elementName = null,Object? classification = null,Object? recurrenceType = null,Object? amount = null,Object? quantity = freezed,Object? rate = freezed,Object? sourceType = null,Object? sourceRefIds = null,Object? visibleOnPayslip = null,Object? displayOrder = null,Object? calculationSource = freezed,Object? createdAt = freezed,}) {
  return _then(_PayrollResultModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,payrollRunId: null == payrollRunId ? _self.payrollRunId : payrollRunId // ignore: cast_nullable_to_non_nullable
as String,employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String,employeeName: null == employeeName ? _self.employeeName : employeeName // ignore: cast_nullable_to_non_nullable
as String,elementCode: null == elementCode ? _self.elementCode : elementCode // ignore: cast_nullable_to_non_nullable
as String,elementName: null == elementName ? _self.elementName : elementName // ignore: cast_nullable_to_non_nullable
as String,classification: null == classification ? _self.classification : classification // ignore: cast_nullable_to_non_nullable
as String,recurrenceType: null == recurrenceType ? _self.recurrenceType : recurrenceType // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,quantity: freezed == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double?,rate: freezed == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as double?,sourceType: null == sourceType ? _self.sourceType : sourceType // ignore: cast_nullable_to_non_nullable
as String,sourceRefIds: null == sourceRefIds ? _self._sourceRefIds : sourceRefIds // ignore: cast_nullable_to_non_nullable
as List<String>,visibleOnPayslip: null == visibleOnPayslip ? _self.visibleOnPayslip : visibleOnPayslip // ignore: cast_nullable_to_non_nullable
as bool,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,calculationSource: freezed == calculationSource ? _self.calculationSource : calculationSource // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
