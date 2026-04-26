// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Expense {

@JsonKey(fromJson: looseStringFromJson) String get id;@JsonKey(fromJson: looseStringFromJson) String get salonId;@JsonKey(fromJson: looseStringFromJson) String get title;@JsonKey(fromJson: looseStringFromJson) String get category;@JsonKey(fromJson: looseDoubleFromJson) double get amount;@JsonKey(fromJson: firestoreDateTimeFromJson, toJson: firestoreDateTimeToJson) DateTime get incurredAt;@JsonKey(fromJson: looseStringFromJson) String get createdByUid;@JsonKey(fromJson: looseStringFromJson) String get createdByName;@JsonKey(fromJson: looseIntFromJson) int get reportYear;@JsonKey(fromJson: looseIntFromJson) int get reportMonth;@JsonKey(fromJson: _paymentMethodFromJson) String get paymentMethod;@JsonKey(fromJson: nullableLooseStringFromJson) String? get linkedEmployeeId;@JsonKey(fromJson: nullableLooseStringFromJson) String? get linkedSupplierName;@JsonKey(fromJson: nullableLooseStringFromJson) String? get vendorName;@JsonKey(fromJson: nullableLooseStringFromJson) String? get notes;@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? get createdAt;@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? get updatedAt;@JsonKey(fromJson: falseBoolFromJson) bool get isDeleted;
/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpenseCopyWith<Expense> get copyWith => _$ExpenseCopyWithImpl<Expense>(this as Expense, _$identity);

  /// Serializes this Expense to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Expense&&(identical(other.id, id) || other.id == id)&&(identical(other.salonId, salonId) || other.salonId == salonId)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.incurredAt, incurredAt) || other.incurredAt == incurredAt)&&(identical(other.createdByUid, createdByUid) || other.createdByUid == createdByUid)&&(identical(other.createdByName, createdByName) || other.createdByName == createdByName)&&(identical(other.reportYear, reportYear) || other.reportYear == reportYear)&&(identical(other.reportMonth, reportMonth) || other.reportMonth == reportMonth)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.linkedEmployeeId, linkedEmployeeId) || other.linkedEmployeeId == linkedEmployeeId)&&(identical(other.linkedSupplierName, linkedSupplierName) || other.linkedSupplierName == linkedSupplierName)&&(identical(other.vendorName, vendorName) || other.vendorName == vendorName)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,salonId,title,category,amount,incurredAt,createdByUid,createdByName,reportYear,reportMonth,paymentMethod,linkedEmployeeId,linkedSupplierName,vendorName,notes,createdAt,updatedAt,isDeleted);

@override
String toString() {
  return 'Expense(id: $id, salonId: $salonId, title: $title, category: $category, amount: $amount, incurredAt: $incurredAt, createdByUid: $createdByUid, createdByName: $createdByName, reportYear: $reportYear, reportMonth: $reportMonth, paymentMethod: $paymentMethod, linkedEmployeeId: $linkedEmployeeId, linkedSupplierName: $linkedSupplierName, vendorName: $vendorName, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, isDeleted: $isDeleted)';
}


}

/// @nodoc
abstract mixin class $ExpenseCopyWith<$Res>  {
  factory $ExpenseCopyWith(Expense value, $Res Function(Expense) _then) = _$ExpenseCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: looseStringFromJson) String id,@JsonKey(fromJson: looseStringFromJson) String salonId,@JsonKey(fromJson: looseStringFromJson) String title,@JsonKey(fromJson: looseStringFromJson) String category,@JsonKey(fromJson: looseDoubleFromJson) double amount,@JsonKey(fromJson: firestoreDateTimeFromJson, toJson: firestoreDateTimeToJson) DateTime incurredAt,@JsonKey(fromJson: looseStringFromJson) String createdByUid,@JsonKey(fromJson: looseStringFromJson) String createdByName,@JsonKey(fromJson: looseIntFromJson) int reportYear,@JsonKey(fromJson: looseIntFromJson) int reportMonth,@JsonKey(fromJson: _paymentMethodFromJson) String paymentMethod,@JsonKey(fromJson: nullableLooseStringFromJson) String? linkedEmployeeId,@JsonKey(fromJson: nullableLooseStringFromJson) String? linkedSupplierName,@JsonKey(fromJson: nullableLooseStringFromJson) String? vendorName,@JsonKey(fromJson: nullableLooseStringFromJson) String? notes,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? createdAt,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? updatedAt,@JsonKey(fromJson: falseBoolFromJson) bool isDeleted
});




}
/// @nodoc
class _$ExpenseCopyWithImpl<$Res>
    implements $ExpenseCopyWith<$Res> {
  _$ExpenseCopyWithImpl(this._self, this._then);

  final Expense _self;
  final $Res Function(Expense) _then;

/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? salonId = null,Object? title = null,Object? category = null,Object? amount = null,Object? incurredAt = null,Object? createdByUid = null,Object? createdByName = null,Object? reportYear = null,Object? reportMonth = null,Object? paymentMethod = null,Object? linkedEmployeeId = freezed,Object? linkedSupplierName = freezed,Object? vendorName = freezed,Object? notes = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? isDeleted = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,salonId: null == salonId ? _self.salonId : salonId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,incurredAt: null == incurredAt ? _self.incurredAt : incurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdByUid: null == createdByUid ? _self.createdByUid : createdByUid // ignore: cast_nullable_to_non_nullable
as String,createdByName: null == createdByName ? _self.createdByName : createdByName // ignore: cast_nullable_to_non_nullable
as String,reportYear: null == reportYear ? _self.reportYear : reportYear // ignore: cast_nullable_to_non_nullable
as int,reportMonth: null == reportMonth ? _self.reportMonth : reportMonth // ignore: cast_nullable_to_non_nullable
as int,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,linkedEmployeeId: freezed == linkedEmployeeId ? _self.linkedEmployeeId : linkedEmployeeId // ignore: cast_nullable_to_non_nullable
as String?,linkedSupplierName: freezed == linkedSupplierName ? _self.linkedSupplierName : linkedSupplierName // ignore: cast_nullable_to_non_nullable
as String?,vendorName: freezed == vendorName ? _self.vendorName : vendorName // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Expense].
extension ExpensePatterns on Expense {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Expense value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Expense() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Expense value)  $default,){
final _that = this;
switch (_that) {
case _Expense():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Expense value)?  $default,){
final _that = this;
switch (_that) {
case _Expense() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: looseStringFromJson)  String id, @JsonKey(fromJson: looseStringFromJson)  String salonId, @JsonKey(fromJson: looseStringFromJson)  String title, @JsonKey(fromJson: looseStringFromJson)  String category, @JsonKey(fromJson: looseDoubleFromJson)  double amount, @JsonKey(fromJson: firestoreDateTimeFromJson, toJson: firestoreDateTimeToJson)  DateTime incurredAt, @JsonKey(fromJson: looseStringFromJson)  String createdByUid, @JsonKey(fromJson: looseStringFromJson)  String createdByName, @JsonKey(fromJson: looseIntFromJson)  int reportYear, @JsonKey(fromJson: looseIntFromJson)  int reportMonth, @JsonKey(fromJson: _paymentMethodFromJson)  String paymentMethod, @JsonKey(fromJson: nullableLooseStringFromJson)  String? linkedEmployeeId, @JsonKey(fromJson: nullableLooseStringFromJson)  String? linkedSupplierName, @JsonKey(fromJson: nullableLooseStringFromJson)  String? vendorName, @JsonKey(fromJson: nullableLooseStringFromJson)  String? notes, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? createdAt, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? updatedAt, @JsonKey(fromJson: falseBoolFromJson)  bool isDeleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Expense() when $default != null:
return $default(_that.id,_that.salonId,_that.title,_that.category,_that.amount,_that.incurredAt,_that.createdByUid,_that.createdByName,_that.reportYear,_that.reportMonth,_that.paymentMethod,_that.linkedEmployeeId,_that.linkedSupplierName,_that.vendorName,_that.notes,_that.createdAt,_that.updatedAt,_that.isDeleted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: looseStringFromJson)  String id, @JsonKey(fromJson: looseStringFromJson)  String salonId, @JsonKey(fromJson: looseStringFromJson)  String title, @JsonKey(fromJson: looseStringFromJson)  String category, @JsonKey(fromJson: looseDoubleFromJson)  double amount, @JsonKey(fromJson: firestoreDateTimeFromJson, toJson: firestoreDateTimeToJson)  DateTime incurredAt, @JsonKey(fromJson: looseStringFromJson)  String createdByUid, @JsonKey(fromJson: looseStringFromJson)  String createdByName, @JsonKey(fromJson: looseIntFromJson)  int reportYear, @JsonKey(fromJson: looseIntFromJson)  int reportMonth, @JsonKey(fromJson: _paymentMethodFromJson)  String paymentMethod, @JsonKey(fromJson: nullableLooseStringFromJson)  String? linkedEmployeeId, @JsonKey(fromJson: nullableLooseStringFromJson)  String? linkedSupplierName, @JsonKey(fromJson: nullableLooseStringFromJson)  String? vendorName, @JsonKey(fromJson: nullableLooseStringFromJson)  String? notes, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? createdAt, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? updatedAt, @JsonKey(fromJson: falseBoolFromJson)  bool isDeleted)  $default,) {final _that = this;
switch (_that) {
case _Expense():
return $default(_that.id,_that.salonId,_that.title,_that.category,_that.amount,_that.incurredAt,_that.createdByUid,_that.createdByName,_that.reportYear,_that.reportMonth,_that.paymentMethod,_that.linkedEmployeeId,_that.linkedSupplierName,_that.vendorName,_that.notes,_that.createdAt,_that.updatedAt,_that.isDeleted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: looseStringFromJson)  String id, @JsonKey(fromJson: looseStringFromJson)  String salonId, @JsonKey(fromJson: looseStringFromJson)  String title, @JsonKey(fromJson: looseStringFromJson)  String category, @JsonKey(fromJson: looseDoubleFromJson)  double amount, @JsonKey(fromJson: firestoreDateTimeFromJson, toJson: firestoreDateTimeToJson)  DateTime incurredAt, @JsonKey(fromJson: looseStringFromJson)  String createdByUid, @JsonKey(fromJson: looseStringFromJson)  String createdByName, @JsonKey(fromJson: looseIntFromJson)  int reportYear, @JsonKey(fromJson: looseIntFromJson)  int reportMonth, @JsonKey(fromJson: _paymentMethodFromJson)  String paymentMethod, @JsonKey(fromJson: nullableLooseStringFromJson)  String? linkedEmployeeId, @JsonKey(fromJson: nullableLooseStringFromJson)  String? linkedSupplierName, @JsonKey(fromJson: nullableLooseStringFromJson)  String? vendorName, @JsonKey(fromJson: nullableLooseStringFromJson)  String? notes, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? createdAt, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? updatedAt, @JsonKey(fromJson: falseBoolFromJson)  bool isDeleted)?  $default,) {final _that = this;
switch (_that) {
case _Expense() when $default != null:
return $default(_that.id,_that.salonId,_that.title,_that.category,_that.amount,_that.incurredAt,_that.createdByUid,_that.createdByName,_that.reportYear,_that.reportMonth,_that.paymentMethod,_that.linkedEmployeeId,_that.linkedSupplierName,_that.vendorName,_that.notes,_that.createdAt,_that.updatedAt,_that.isDeleted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Expense extends Expense {
  const _Expense({@JsonKey(fromJson: looseStringFromJson) required this.id, @JsonKey(fromJson: looseStringFromJson) required this.salonId, @JsonKey(fromJson: looseStringFromJson) required this.title, @JsonKey(fromJson: looseStringFromJson) required this.category, @JsonKey(fromJson: looseDoubleFromJson) required this.amount, @JsonKey(fromJson: firestoreDateTimeFromJson, toJson: firestoreDateTimeToJson) required this.incurredAt, @JsonKey(fromJson: looseStringFromJson) required this.createdByUid, @JsonKey(fromJson: looseStringFromJson) required this.createdByName, @JsonKey(fromJson: looseIntFromJson) this.reportYear = 0, @JsonKey(fromJson: looseIntFromJson) this.reportMonth = 0, @JsonKey(fromJson: _paymentMethodFromJson) this.paymentMethod = SalePaymentMethods.cash, @JsonKey(fromJson: nullableLooseStringFromJson) this.linkedEmployeeId, @JsonKey(fromJson: nullableLooseStringFromJson) this.linkedSupplierName, @JsonKey(fromJson: nullableLooseStringFromJson) this.vendorName, @JsonKey(fromJson: nullableLooseStringFromJson) this.notes, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) this.createdAt, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) this.updatedAt, @JsonKey(fromJson: falseBoolFromJson) this.isDeleted = false}): super._();
  factory _Expense.fromJson(Map<String, dynamic> json) => _$ExpenseFromJson(json);

@override@JsonKey(fromJson: looseStringFromJson) final  String id;
@override@JsonKey(fromJson: looseStringFromJson) final  String salonId;
@override@JsonKey(fromJson: looseStringFromJson) final  String title;
@override@JsonKey(fromJson: looseStringFromJson) final  String category;
@override@JsonKey(fromJson: looseDoubleFromJson) final  double amount;
@override@JsonKey(fromJson: firestoreDateTimeFromJson, toJson: firestoreDateTimeToJson) final  DateTime incurredAt;
@override@JsonKey(fromJson: looseStringFromJson) final  String createdByUid;
@override@JsonKey(fromJson: looseStringFromJson) final  String createdByName;
@override@JsonKey(fromJson: looseIntFromJson) final  int reportYear;
@override@JsonKey(fromJson: looseIntFromJson) final  int reportMonth;
@override@JsonKey(fromJson: _paymentMethodFromJson) final  String paymentMethod;
@override@JsonKey(fromJson: nullableLooseStringFromJson) final  String? linkedEmployeeId;
@override@JsonKey(fromJson: nullableLooseStringFromJson) final  String? linkedSupplierName;
@override@JsonKey(fromJson: nullableLooseStringFromJson) final  String? vendorName;
@override@JsonKey(fromJson: nullableLooseStringFromJson) final  String? notes;
@override@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) final  DateTime? createdAt;
@override@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) final  DateTime? updatedAt;
@override@JsonKey(fromJson: falseBoolFromJson) final  bool isDeleted;

/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpenseCopyWith<_Expense> get copyWith => __$ExpenseCopyWithImpl<_Expense>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExpenseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Expense&&(identical(other.id, id) || other.id == id)&&(identical(other.salonId, salonId) || other.salonId == salonId)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.incurredAt, incurredAt) || other.incurredAt == incurredAt)&&(identical(other.createdByUid, createdByUid) || other.createdByUid == createdByUid)&&(identical(other.createdByName, createdByName) || other.createdByName == createdByName)&&(identical(other.reportYear, reportYear) || other.reportYear == reportYear)&&(identical(other.reportMonth, reportMonth) || other.reportMonth == reportMonth)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.linkedEmployeeId, linkedEmployeeId) || other.linkedEmployeeId == linkedEmployeeId)&&(identical(other.linkedSupplierName, linkedSupplierName) || other.linkedSupplierName == linkedSupplierName)&&(identical(other.vendorName, vendorName) || other.vendorName == vendorName)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isDeleted, isDeleted) || other.isDeleted == isDeleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,salonId,title,category,amount,incurredAt,createdByUid,createdByName,reportYear,reportMonth,paymentMethod,linkedEmployeeId,linkedSupplierName,vendorName,notes,createdAt,updatedAt,isDeleted);

@override
String toString() {
  return 'Expense(id: $id, salonId: $salonId, title: $title, category: $category, amount: $amount, incurredAt: $incurredAt, createdByUid: $createdByUid, createdByName: $createdByName, reportYear: $reportYear, reportMonth: $reportMonth, paymentMethod: $paymentMethod, linkedEmployeeId: $linkedEmployeeId, linkedSupplierName: $linkedSupplierName, vendorName: $vendorName, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, isDeleted: $isDeleted)';
}


}

/// @nodoc
abstract mixin class _$ExpenseCopyWith<$Res> implements $ExpenseCopyWith<$Res> {
  factory _$ExpenseCopyWith(_Expense value, $Res Function(_Expense) _then) = __$ExpenseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: looseStringFromJson) String id,@JsonKey(fromJson: looseStringFromJson) String salonId,@JsonKey(fromJson: looseStringFromJson) String title,@JsonKey(fromJson: looseStringFromJson) String category,@JsonKey(fromJson: looseDoubleFromJson) double amount,@JsonKey(fromJson: firestoreDateTimeFromJson, toJson: firestoreDateTimeToJson) DateTime incurredAt,@JsonKey(fromJson: looseStringFromJson) String createdByUid,@JsonKey(fromJson: looseStringFromJson) String createdByName,@JsonKey(fromJson: looseIntFromJson) int reportYear,@JsonKey(fromJson: looseIntFromJson) int reportMonth,@JsonKey(fromJson: _paymentMethodFromJson) String paymentMethod,@JsonKey(fromJson: nullableLooseStringFromJson) String? linkedEmployeeId,@JsonKey(fromJson: nullableLooseStringFromJson) String? linkedSupplierName,@JsonKey(fromJson: nullableLooseStringFromJson) String? vendorName,@JsonKey(fromJson: nullableLooseStringFromJson) String? notes,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? createdAt,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? updatedAt,@JsonKey(fromJson: falseBoolFromJson) bool isDeleted
});




}
/// @nodoc
class __$ExpenseCopyWithImpl<$Res>
    implements _$ExpenseCopyWith<$Res> {
  __$ExpenseCopyWithImpl(this._self, this._then);

  final _Expense _self;
  final $Res Function(_Expense) _then;

/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? salonId = null,Object? title = null,Object? category = null,Object? amount = null,Object? incurredAt = null,Object? createdByUid = null,Object? createdByName = null,Object? reportYear = null,Object? reportMonth = null,Object? paymentMethod = null,Object? linkedEmployeeId = freezed,Object? linkedSupplierName = freezed,Object? vendorName = freezed,Object? notes = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? isDeleted = null,}) {
  return _then(_Expense(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,salonId: null == salonId ? _self.salonId : salonId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,incurredAt: null == incurredAt ? _self.incurredAt : incurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdByUid: null == createdByUid ? _self.createdByUid : createdByUid // ignore: cast_nullable_to_non_nullable
as String,createdByName: null == createdByName ? _self.createdByName : createdByName // ignore: cast_nullable_to_non_nullable
as String,reportYear: null == reportYear ? _self.reportYear : reportYear // ignore: cast_nullable_to_non_nullable
as int,reportMonth: null == reportMonth ? _self.reportMonth : reportMonth // ignore: cast_nullable_to_non_nullable
as int,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,linkedEmployeeId: freezed == linkedEmployeeId ? _self.linkedEmployeeId : linkedEmployeeId // ignore: cast_nullable_to_non_nullable
as String?,linkedSupplierName: freezed == linkedSupplierName ? _self.linkedSupplierName : linkedSupplierName // ignore: cast_nullable_to_non_nullable
as String?,vendorName: freezed == vendorName ? _self.vendorName : vendorName // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isDeleted: null == isDeleted ? _self.isDeleted : isDeleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
