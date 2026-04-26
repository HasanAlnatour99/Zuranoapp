// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payroll_element_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PayrollElementModel {

@JsonKey(fromJson: looseStringFromJson) String get id;@JsonKey(fromJson: looseStringFromJson) String get code;@JsonKey(fromJson: looseStringFromJson) String get name;@JsonKey(fromJson: _classificationFromJson) String get classification;@JsonKey(fromJson: _recurrenceTypeFromJson) String get recurrenceType;@JsonKey(fromJson: _calculationMethodFromJson) String get calculationMethod;@JsonKey(fromJson: looseDoubleFromJson) double get defaultAmount;@JsonKey(fromJson: falseBoolFromJson) bool get isSystemElement;@JsonKey(fromJson: trueBoolFromJson) bool get isActive;@JsonKey(fromJson: trueBoolFromJson) bool get affectsNetPay;@JsonKey(fromJson: trueBoolFromJson) bool get visibleOnPayslip;@JsonKey(fromJson: looseIntFromJson) int get displayOrder;@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? get createdAt;@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? get updatedAt;
/// Create a copy of PayrollElementModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PayrollElementModelCopyWith<PayrollElementModel> get copyWith => _$PayrollElementModelCopyWithImpl<PayrollElementModel>(this as PayrollElementModel, _$identity);

  /// Serializes this PayrollElementModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PayrollElementModel&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.classification, classification) || other.classification == classification)&&(identical(other.recurrenceType, recurrenceType) || other.recurrenceType == recurrenceType)&&(identical(other.calculationMethod, calculationMethod) || other.calculationMethod == calculationMethod)&&(identical(other.defaultAmount, defaultAmount) || other.defaultAmount == defaultAmount)&&(identical(other.isSystemElement, isSystemElement) || other.isSystemElement == isSystemElement)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.affectsNetPay, affectsNetPay) || other.affectsNetPay == affectsNetPay)&&(identical(other.visibleOnPayslip, visibleOnPayslip) || other.visibleOnPayslip == visibleOnPayslip)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,name,classification,recurrenceType,calculationMethod,defaultAmount,isSystemElement,isActive,affectsNetPay,visibleOnPayslip,displayOrder,createdAt,updatedAt);

@override
String toString() {
  return 'PayrollElementModel(id: $id, code: $code, name: $name, classification: $classification, recurrenceType: $recurrenceType, calculationMethod: $calculationMethod, defaultAmount: $defaultAmount, isSystemElement: $isSystemElement, isActive: $isActive, affectsNetPay: $affectsNetPay, visibleOnPayslip: $visibleOnPayslip, displayOrder: $displayOrder, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $PayrollElementModelCopyWith<$Res>  {
  factory $PayrollElementModelCopyWith(PayrollElementModel value, $Res Function(PayrollElementModel) _then) = _$PayrollElementModelCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: looseStringFromJson) String id,@JsonKey(fromJson: looseStringFromJson) String code,@JsonKey(fromJson: looseStringFromJson) String name,@JsonKey(fromJson: _classificationFromJson) String classification,@JsonKey(fromJson: _recurrenceTypeFromJson) String recurrenceType,@JsonKey(fromJson: _calculationMethodFromJson) String calculationMethod,@JsonKey(fromJson: looseDoubleFromJson) double defaultAmount,@JsonKey(fromJson: falseBoolFromJson) bool isSystemElement,@JsonKey(fromJson: trueBoolFromJson) bool isActive,@JsonKey(fromJson: trueBoolFromJson) bool affectsNetPay,@JsonKey(fromJson: trueBoolFromJson) bool visibleOnPayslip,@JsonKey(fromJson: looseIntFromJson) int displayOrder,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? createdAt,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? updatedAt
});




}
/// @nodoc
class _$PayrollElementModelCopyWithImpl<$Res>
    implements $PayrollElementModelCopyWith<$Res> {
  _$PayrollElementModelCopyWithImpl(this._self, this._then);

  final PayrollElementModel _self;
  final $Res Function(PayrollElementModel) _then;

/// Create a copy of PayrollElementModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = null,Object? name = null,Object? classification = null,Object? recurrenceType = null,Object? calculationMethod = null,Object? defaultAmount = null,Object? isSystemElement = null,Object? isActive = null,Object? affectsNetPay = null,Object? visibleOnPayslip = null,Object? displayOrder = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,classification: null == classification ? _self.classification : classification // ignore: cast_nullable_to_non_nullable
as String,recurrenceType: null == recurrenceType ? _self.recurrenceType : recurrenceType // ignore: cast_nullable_to_non_nullable
as String,calculationMethod: null == calculationMethod ? _self.calculationMethod : calculationMethod // ignore: cast_nullable_to_non_nullable
as String,defaultAmount: null == defaultAmount ? _self.defaultAmount : defaultAmount // ignore: cast_nullable_to_non_nullable
as double,isSystemElement: null == isSystemElement ? _self.isSystemElement : isSystemElement // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,affectsNetPay: null == affectsNetPay ? _self.affectsNetPay : affectsNetPay // ignore: cast_nullable_to_non_nullable
as bool,visibleOnPayslip: null == visibleOnPayslip ? _self.visibleOnPayslip : visibleOnPayslip // ignore: cast_nullable_to_non_nullable
as bool,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PayrollElementModel].
extension PayrollElementModelPatterns on PayrollElementModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PayrollElementModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PayrollElementModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PayrollElementModel value)  $default,){
final _that = this;
switch (_that) {
case _PayrollElementModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PayrollElementModel value)?  $default,){
final _that = this;
switch (_that) {
case _PayrollElementModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: looseStringFromJson)  String id, @JsonKey(fromJson: looseStringFromJson)  String code, @JsonKey(fromJson: looseStringFromJson)  String name, @JsonKey(fromJson: _classificationFromJson)  String classification, @JsonKey(fromJson: _recurrenceTypeFromJson)  String recurrenceType, @JsonKey(fromJson: _calculationMethodFromJson)  String calculationMethod, @JsonKey(fromJson: looseDoubleFromJson)  double defaultAmount, @JsonKey(fromJson: falseBoolFromJson)  bool isSystemElement, @JsonKey(fromJson: trueBoolFromJson)  bool isActive, @JsonKey(fromJson: trueBoolFromJson)  bool affectsNetPay, @JsonKey(fromJson: trueBoolFromJson)  bool visibleOnPayslip, @JsonKey(fromJson: looseIntFromJson)  int displayOrder, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? createdAt, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PayrollElementModel() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.classification,_that.recurrenceType,_that.calculationMethod,_that.defaultAmount,_that.isSystemElement,_that.isActive,_that.affectsNetPay,_that.visibleOnPayslip,_that.displayOrder,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: looseStringFromJson)  String id, @JsonKey(fromJson: looseStringFromJson)  String code, @JsonKey(fromJson: looseStringFromJson)  String name, @JsonKey(fromJson: _classificationFromJson)  String classification, @JsonKey(fromJson: _recurrenceTypeFromJson)  String recurrenceType, @JsonKey(fromJson: _calculationMethodFromJson)  String calculationMethod, @JsonKey(fromJson: looseDoubleFromJson)  double defaultAmount, @JsonKey(fromJson: falseBoolFromJson)  bool isSystemElement, @JsonKey(fromJson: trueBoolFromJson)  bool isActive, @JsonKey(fromJson: trueBoolFromJson)  bool affectsNetPay, @JsonKey(fromJson: trueBoolFromJson)  bool visibleOnPayslip, @JsonKey(fromJson: looseIntFromJson)  int displayOrder, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? createdAt, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _PayrollElementModel():
return $default(_that.id,_that.code,_that.name,_that.classification,_that.recurrenceType,_that.calculationMethod,_that.defaultAmount,_that.isSystemElement,_that.isActive,_that.affectsNetPay,_that.visibleOnPayslip,_that.displayOrder,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: looseStringFromJson)  String id, @JsonKey(fromJson: looseStringFromJson)  String code, @JsonKey(fromJson: looseStringFromJson)  String name, @JsonKey(fromJson: _classificationFromJson)  String classification, @JsonKey(fromJson: _recurrenceTypeFromJson)  String recurrenceType, @JsonKey(fromJson: _calculationMethodFromJson)  String calculationMethod, @JsonKey(fromJson: looseDoubleFromJson)  double defaultAmount, @JsonKey(fromJson: falseBoolFromJson)  bool isSystemElement, @JsonKey(fromJson: trueBoolFromJson)  bool isActive, @JsonKey(fromJson: trueBoolFromJson)  bool affectsNetPay, @JsonKey(fromJson: trueBoolFromJson)  bool visibleOnPayslip, @JsonKey(fromJson: looseIntFromJson)  int displayOrder, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? createdAt, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _PayrollElementModel() when $default != null:
return $default(_that.id,_that.code,_that.name,_that.classification,_that.recurrenceType,_that.calculationMethod,_that.defaultAmount,_that.isSystemElement,_that.isActive,_that.affectsNetPay,_that.visibleOnPayslip,_that.displayOrder,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PayrollElementModel implements PayrollElementModel {
  const _PayrollElementModel({@JsonKey(fromJson: looseStringFromJson) required this.id, @JsonKey(fromJson: looseStringFromJson) required this.code, @JsonKey(fromJson: looseStringFromJson) required this.name, @JsonKey(fromJson: _classificationFromJson) required this.classification, @JsonKey(fromJson: _recurrenceTypeFromJson) required this.recurrenceType, @JsonKey(fromJson: _calculationMethodFromJson) required this.calculationMethod, @JsonKey(fromJson: looseDoubleFromJson) this.defaultAmount = 0, @JsonKey(fromJson: falseBoolFromJson) this.isSystemElement = false, @JsonKey(fromJson: trueBoolFromJson) this.isActive = true, @JsonKey(fromJson: trueBoolFromJson) this.affectsNetPay = true, @JsonKey(fromJson: trueBoolFromJson) this.visibleOnPayslip = true, @JsonKey(fromJson: looseIntFromJson) this.displayOrder = 0, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) this.createdAt, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) this.updatedAt});
  factory _PayrollElementModel.fromJson(Map<String, dynamic> json) => _$PayrollElementModelFromJson(json);

@override@JsonKey(fromJson: looseStringFromJson) final  String id;
@override@JsonKey(fromJson: looseStringFromJson) final  String code;
@override@JsonKey(fromJson: looseStringFromJson) final  String name;
@override@JsonKey(fromJson: _classificationFromJson) final  String classification;
@override@JsonKey(fromJson: _recurrenceTypeFromJson) final  String recurrenceType;
@override@JsonKey(fromJson: _calculationMethodFromJson) final  String calculationMethod;
@override@JsonKey(fromJson: looseDoubleFromJson) final  double defaultAmount;
@override@JsonKey(fromJson: falseBoolFromJson) final  bool isSystemElement;
@override@JsonKey(fromJson: trueBoolFromJson) final  bool isActive;
@override@JsonKey(fromJson: trueBoolFromJson) final  bool affectsNetPay;
@override@JsonKey(fromJson: trueBoolFromJson) final  bool visibleOnPayslip;
@override@JsonKey(fromJson: looseIntFromJson) final  int displayOrder;
@override@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) final  DateTime? createdAt;
@override@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) final  DateTime? updatedAt;

/// Create a copy of PayrollElementModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PayrollElementModelCopyWith<_PayrollElementModel> get copyWith => __$PayrollElementModelCopyWithImpl<_PayrollElementModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PayrollElementModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PayrollElementModel&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code)&&(identical(other.name, name) || other.name == name)&&(identical(other.classification, classification) || other.classification == classification)&&(identical(other.recurrenceType, recurrenceType) || other.recurrenceType == recurrenceType)&&(identical(other.calculationMethod, calculationMethod) || other.calculationMethod == calculationMethod)&&(identical(other.defaultAmount, defaultAmount) || other.defaultAmount == defaultAmount)&&(identical(other.isSystemElement, isSystemElement) || other.isSystemElement == isSystemElement)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.affectsNetPay, affectsNetPay) || other.affectsNetPay == affectsNetPay)&&(identical(other.visibleOnPayslip, visibleOnPayslip) || other.visibleOnPayslip == visibleOnPayslip)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,code,name,classification,recurrenceType,calculationMethod,defaultAmount,isSystemElement,isActive,affectsNetPay,visibleOnPayslip,displayOrder,createdAt,updatedAt);

@override
String toString() {
  return 'PayrollElementModel(id: $id, code: $code, name: $name, classification: $classification, recurrenceType: $recurrenceType, calculationMethod: $calculationMethod, defaultAmount: $defaultAmount, isSystemElement: $isSystemElement, isActive: $isActive, affectsNetPay: $affectsNetPay, visibleOnPayslip: $visibleOnPayslip, displayOrder: $displayOrder, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PayrollElementModelCopyWith<$Res> implements $PayrollElementModelCopyWith<$Res> {
  factory _$PayrollElementModelCopyWith(_PayrollElementModel value, $Res Function(_PayrollElementModel) _then) = __$PayrollElementModelCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: looseStringFromJson) String id,@JsonKey(fromJson: looseStringFromJson) String code,@JsonKey(fromJson: looseStringFromJson) String name,@JsonKey(fromJson: _classificationFromJson) String classification,@JsonKey(fromJson: _recurrenceTypeFromJson) String recurrenceType,@JsonKey(fromJson: _calculationMethodFromJson) String calculationMethod,@JsonKey(fromJson: looseDoubleFromJson) double defaultAmount,@JsonKey(fromJson: falseBoolFromJson) bool isSystemElement,@JsonKey(fromJson: trueBoolFromJson) bool isActive,@JsonKey(fromJson: trueBoolFromJson) bool affectsNetPay,@JsonKey(fromJson: trueBoolFromJson) bool visibleOnPayslip,@JsonKey(fromJson: looseIntFromJson) int displayOrder,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? createdAt,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? updatedAt
});




}
/// @nodoc
class __$PayrollElementModelCopyWithImpl<$Res>
    implements _$PayrollElementModelCopyWith<$Res> {
  __$PayrollElementModelCopyWithImpl(this._self, this._then);

  final _PayrollElementModel _self;
  final $Res Function(_PayrollElementModel) _then;

/// Create a copy of PayrollElementModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = null,Object? name = null,Object? classification = null,Object? recurrenceType = null,Object? calculationMethod = null,Object? defaultAmount = null,Object? isSystemElement = null,Object? isActive = null,Object? affectsNetPay = null,Object? visibleOnPayslip = null,Object? displayOrder = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_PayrollElementModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,classification: null == classification ? _self.classification : classification // ignore: cast_nullable_to_non_nullable
as String,recurrenceType: null == recurrenceType ? _self.recurrenceType : recurrenceType // ignore: cast_nullable_to_non_nullable
as String,calculationMethod: null == calculationMethod ? _self.calculationMethod : calculationMethod // ignore: cast_nullable_to_non_nullable
as String,defaultAmount: null == defaultAmount ? _self.defaultAmount : defaultAmount // ignore: cast_nullable_to_non_nullable
as double,isSystemElement: null == isSystemElement ? _self.isSystemElement : isSystemElement // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,affectsNetPay: null == affectsNetPay ? _self.affectsNetPay : affectsNetPay // ignore: cast_nullable_to_non_nullable
as bool,visibleOnPayslip: null == visibleOnPayslip ? _self.visibleOnPayslip : visibleOnPayslip // ignore: cast_nullable_to_non_nullable
as bool,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
