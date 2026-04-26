// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payroll_deduction_line.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PayrollDeductionLine {

@JsonKey(fromJson: _kindFromJson) String get kind;@JsonKey(fromJson: looseDoubleFromJson) double get amount;@JsonKey(fromJson: nullableLooseStringFromJson) String? get violationId;@JsonKey(fromJson: nullableLooseStringFromJson) String? get bookingId;@JsonKey(fromJson: nullableLooseStringFromJson) String? get label;
/// Create a copy of PayrollDeductionLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PayrollDeductionLineCopyWith<PayrollDeductionLine> get copyWith => _$PayrollDeductionLineCopyWithImpl<PayrollDeductionLine>(this as PayrollDeductionLine, _$identity);

  /// Serializes this PayrollDeductionLine to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PayrollDeductionLine&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.violationId, violationId) || other.violationId == violationId)&&(identical(other.bookingId, bookingId) || other.bookingId == bookingId)&&(identical(other.label, label) || other.label == label));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,amount,violationId,bookingId,label);

@override
String toString() {
  return 'PayrollDeductionLine(kind: $kind, amount: $amount, violationId: $violationId, bookingId: $bookingId, label: $label)';
}


}

/// @nodoc
abstract mixin class $PayrollDeductionLineCopyWith<$Res>  {
  factory $PayrollDeductionLineCopyWith(PayrollDeductionLine value, $Res Function(PayrollDeductionLine) _then) = _$PayrollDeductionLineCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _kindFromJson) String kind,@JsonKey(fromJson: looseDoubleFromJson) double amount,@JsonKey(fromJson: nullableLooseStringFromJson) String? violationId,@JsonKey(fromJson: nullableLooseStringFromJson) String? bookingId,@JsonKey(fromJson: nullableLooseStringFromJson) String? label
});




}
/// @nodoc
class _$PayrollDeductionLineCopyWithImpl<$Res>
    implements $PayrollDeductionLineCopyWith<$Res> {
  _$PayrollDeductionLineCopyWithImpl(this._self, this._then);

  final PayrollDeductionLine _self;
  final $Res Function(PayrollDeductionLine) _then;

/// Create a copy of PayrollDeductionLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? amount = null,Object? violationId = freezed,Object? bookingId = freezed,Object? label = freezed,}) {
  return _then(_self.copyWith(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,violationId: freezed == violationId ? _self.violationId : violationId // ignore: cast_nullable_to_non_nullable
as String?,bookingId: freezed == bookingId ? _self.bookingId : bookingId // ignore: cast_nullable_to_non_nullable
as String?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PayrollDeductionLine].
extension PayrollDeductionLinePatterns on PayrollDeductionLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PayrollDeductionLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PayrollDeductionLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PayrollDeductionLine value)  $default,){
final _that = this;
switch (_that) {
case _PayrollDeductionLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PayrollDeductionLine value)?  $default,){
final _that = this;
switch (_that) {
case _PayrollDeductionLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _kindFromJson)  String kind, @JsonKey(fromJson: looseDoubleFromJson)  double amount, @JsonKey(fromJson: nullableLooseStringFromJson)  String? violationId, @JsonKey(fromJson: nullableLooseStringFromJson)  String? bookingId, @JsonKey(fromJson: nullableLooseStringFromJson)  String? label)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PayrollDeductionLine() when $default != null:
return $default(_that.kind,_that.amount,_that.violationId,_that.bookingId,_that.label);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _kindFromJson)  String kind, @JsonKey(fromJson: looseDoubleFromJson)  double amount, @JsonKey(fromJson: nullableLooseStringFromJson)  String? violationId, @JsonKey(fromJson: nullableLooseStringFromJson)  String? bookingId, @JsonKey(fromJson: nullableLooseStringFromJson)  String? label)  $default,) {final _that = this;
switch (_that) {
case _PayrollDeductionLine():
return $default(_that.kind,_that.amount,_that.violationId,_that.bookingId,_that.label);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _kindFromJson)  String kind, @JsonKey(fromJson: looseDoubleFromJson)  double amount, @JsonKey(fromJson: nullableLooseStringFromJson)  String? violationId, @JsonKey(fromJson: nullableLooseStringFromJson)  String? bookingId, @JsonKey(fromJson: nullableLooseStringFromJson)  String? label)?  $default,) {final _that = this;
switch (_that) {
case _PayrollDeductionLine() when $default != null:
return $default(_that.kind,_that.amount,_that.violationId,_that.bookingId,_that.label);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PayrollDeductionLine implements PayrollDeductionLine {
  const _PayrollDeductionLine({@JsonKey(fromJson: _kindFromJson) required this.kind, @JsonKey(fromJson: looseDoubleFromJson) required this.amount, @JsonKey(fromJson: nullableLooseStringFromJson) this.violationId, @JsonKey(fromJson: nullableLooseStringFromJson) this.bookingId, @JsonKey(fromJson: nullableLooseStringFromJson) this.label});
  factory _PayrollDeductionLine.fromJson(Map<String, dynamic> json) => _$PayrollDeductionLineFromJson(json);

@override@JsonKey(fromJson: _kindFromJson) final  String kind;
@override@JsonKey(fromJson: looseDoubleFromJson) final  double amount;
@override@JsonKey(fromJson: nullableLooseStringFromJson) final  String? violationId;
@override@JsonKey(fromJson: nullableLooseStringFromJson) final  String? bookingId;
@override@JsonKey(fromJson: nullableLooseStringFromJson) final  String? label;

/// Create a copy of PayrollDeductionLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PayrollDeductionLineCopyWith<_PayrollDeductionLine> get copyWith => __$PayrollDeductionLineCopyWithImpl<_PayrollDeductionLine>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PayrollDeductionLineToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PayrollDeductionLine&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.violationId, violationId) || other.violationId == violationId)&&(identical(other.bookingId, bookingId) || other.bookingId == bookingId)&&(identical(other.label, label) || other.label == label));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,amount,violationId,bookingId,label);

@override
String toString() {
  return 'PayrollDeductionLine(kind: $kind, amount: $amount, violationId: $violationId, bookingId: $bookingId, label: $label)';
}


}

/// @nodoc
abstract mixin class _$PayrollDeductionLineCopyWith<$Res> implements $PayrollDeductionLineCopyWith<$Res> {
  factory _$PayrollDeductionLineCopyWith(_PayrollDeductionLine value, $Res Function(_PayrollDeductionLine) _then) = __$PayrollDeductionLineCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _kindFromJson) String kind,@JsonKey(fromJson: looseDoubleFromJson) double amount,@JsonKey(fromJson: nullableLooseStringFromJson) String? violationId,@JsonKey(fromJson: nullableLooseStringFromJson) String? bookingId,@JsonKey(fromJson: nullableLooseStringFromJson) String? label
});




}
/// @nodoc
class __$PayrollDeductionLineCopyWithImpl<$Res>
    implements _$PayrollDeductionLineCopyWith<$Res> {
  __$PayrollDeductionLineCopyWithImpl(this._self, this._then);

  final _PayrollDeductionLine _self;
  final $Res Function(_PayrollDeductionLine) _then;

/// Create a copy of PayrollDeductionLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? amount = null,Object? violationId = freezed,Object? bookingId = freezed,Object? label = freezed,}) {
  return _then(_PayrollDeductionLine(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,violationId: freezed == violationId ? _self.violationId : violationId // ignore: cast_nullable_to_non_nullable
as String?,bookingId: freezed == bookingId ? _self.bookingId : bookingId // ignore: cast_nullable_to_non_nullable
as String?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
