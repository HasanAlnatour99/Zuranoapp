// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'salon_insight.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SalonInsight {

@JsonKey(fromJson: looseStringFromJson) String get id;@JsonKey(fromJson: looseStringFromJson) String get type;@JsonKey(fromJson: looseStringFromJson) String get title;@JsonKey(fromJson: looseStringFromJson) String get message;@JsonKey(fromJson: _periodFromJson) String get period;@JsonKey(fromJson: looseDoubleFromJson) double get value;@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? get createdAt;@JsonKey(fromJson: nullableLooseStringFromJson) String? get weekKey;@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? get weekStart;@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? get weekEnd;@JsonKey(fromJson: nullableStringDynamicMapFromJson, toJson: nullableStringDynamicMapToJson) Map<String, dynamic>? get payload;
/// Create a copy of SalonInsight
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SalonInsightCopyWith<SalonInsight> get copyWith => _$SalonInsightCopyWithImpl<SalonInsight>(this as SalonInsight, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SalonInsight&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message)&&(identical(other.period, period) || other.period == period)&&(identical(other.value, value) || other.value == value)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.weekKey, weekKey) || other.weekKey == weekKey)&&(identical(other.weekStart, weekStart) || other.weekStart == weekStart)&&(identical(other.weekEnd, weekEnd) || other.weekEnd == weekEnd)&&const DeepCollectionEquality().equals(other.payload, payload));
}


@override
int get hashCode => Object.hash(runtimeType,id,type,title,message,period,value,createdAt,weekKey,weekStart,weekEnd,const DeepCollectionEquality().hash(payload));

@override
String toString() {
  return 'SalonInsight(id: $id, type: $type, title: $title, message: $message, period: $period, value: $value, createdAt: $createdAt, weekKey: $weekKey, weekStart: $weekStart, weekEnd: $weekEnd, payload: $payload)';
}


}

/// @nodoc
abstract mixin class $SalonInsightCopyWith<$Res>  {
  factory $SalonInsightCopyWith(SalonInsight value, $Res Function(SalonInsight) _then) = _$SalonInsightCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: looseStringFromJson) String id,@JsonKey(fromJson: looseStringFromJson) String type,@JsonKey(fromJson: looseStringFromJson) String title,@JsonKey(fromJson: looseStringFromJson) String message,@JsonKey(fromJson: _periodFromJson) String period,@JsonKey(fromJson: looseDoubleFromJson) double value,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? createdAt,@JsonKey(fromJson: nullableLooseStringFromJson) String? weekKey,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? weekStart,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? weekEnd,@JsonKey(fromJson: nullableStringDynamicMapFromJson, toJson: nullableStringDynamicMapToJson) Map<String, dynamic>? payload
});




}
/// @nodoc
class _$SalonInsightCopyWithImpl<$Res>
    implements $SalonInsightCopyWith<$Res> {
  _$SalonInsightCopyWithImpl(this._self, this._then);

  final SalonInsight _self;
  final $Res Function(SalonInsight) _then;

/// Create a copy of SalonInsight
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? title = null,Object? message = null,Object? period = null,Object? value = null,Object? createdAt = freezed,Object? weekKey = freezed,Object? weekStart = freezed,Object? weekEnd = freezed,Object? payload = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,weekKey: freezed == weekKey ? _self.weekKey : weekKey // ignore: cast_nullable_to_non_nullable
as String?,weekStart: freezed == weekStart ? _self.weekStart : weekStart // ignore: cast_nullable_to_non_nullable
as DateTime?,weekEnd: freezed == weekEnd ? _self.weekEnd : weekEnd // ignore: cast_nullable_to_non_nullable
as DateTime?,payload: freezed == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [SalonInsight].
extension SalonInsightPatterns on SalonInsight {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SalonInsight value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SalonInsight() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SalonInsight value)  $default,){
final _that = this;
switch (_that) {
case _SalonInsight():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SalonInsight value)?  $default,){
final _that = this;
switch (_that) {
case _SalonInsight() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: looseStringFromJson)  String id, @JsonKey(fromJson: looseStringFromJson)  String type, @JsonKey(fromJson: looseStringFromJson)  String title, @JsonKey(fromJson: looseStringFromJson)  String message, @JsonKey(fromJson: _periodFromJson)  String period, @JsonKey(fromJson: looseDoubleFromJson)  double value, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? createdAt, @JsonKey(fromJson: nullableLooseStringFromJson)  String? weekKey, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? weekStart, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? weekEnd, @JsonKey(fromJson: nullableStringDynamicMapFromJson, toJson: nullableStringDynamicMapToJson)  Map<String, dynamic>? payload)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SalonInsight() when $default != null:
return $default(_that.id,_that.type,_that.title,_that.message,_that.period,_that.value,_that.createdAt,_that.weekKey,_that.weekStart,_that.weekEnd,_that.payload);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: looseStringFromJson)  String id, @JsonKey(fromJson: looseStringFromJson)  String type, @JsonKey(fromJson: looseStringFromJson)  String title, @JsonKey(fromJson: looseStringFromJson)  String message, @JsonKey(fromJson: _periodFromJson)  String period, @JsonKey(fromJson: looseDoubleFromJson)  double value, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? createdAt, @JsonKey(fromJson: nullableLooseStringFromJson)  String? weekKey, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? weekStart, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? weekEnd, @JsonKey(fromJson: nullableStringDynamicMapFromJson, toJson: nullableStringDynamicMapToJson)  Map<String, dynamic>? payload)  $default,) {final _that = this;
switch (_that) {
case _SalonInsight():
return $default(_that.id,_that.type,_that.title,_that.message,_that.period,_that.value,_that.createdAt,_that.weekKey,_that.weekStart,_that.weekEnd,_that.payload);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: looseStringFromJson)  String id, @JsonKey(fromJson: looseStringFromJson)  String type, @JsonKey(fromJson: looseStringFromJson)  String title, @JsonKey(fromJson: looseStringFromJson)  String message, @JsonKey(fromJson: _periodFromJson)  String period, @JsonKey(fromJson: looseDoubleFromJson)  double value, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? createdAt, @JsonKey(fromJson: nullableLooseStringFromJson)  String? weekKey, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? weekStart, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? weekEnd, @JsonKey(fromJson: nullableStringDynamicMapFromJson, toJson: nullableStringDynamicMapToJson)  Map<String, dynamic>? payload)?  $default,) {final _that = this;
switch (_that) {
case _SalonInsight() when $default != null:
return $default(_that.id,_that.type,_that.title,_that.message,_that.period,_that.value,_that.createdAt,_that.weekKey,_that.weekStart,_that.weekEnd,_that.payload);case _:
  return null;

}
}

}

/// @nodoc


class _SalonInsight extends SalonInsight {
  const _SalonInsight({@JsonKey(fromJson: looseStringFromJson) required this.id, @JsonKey(fromJson: looseStringFromJson) required this.type, @JsonKey(fromJson: looseStringFromJson) required this.title, @JsonKey(fromJson: looseStringFromJson) required this.message, @JsonKey(fromJson: _periodFromJson) required this.period, @JsonKey(fromJson: looseDoubleFromJson) required this.value, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) required this.createdAt, @JsonKey(fromJson: nullableLooseStringFromJson) this.weekKey, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) this.weekStart, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) this.weekEnd, @JsonKey(fromJson: nullableStringDynamicMapFromJson, toJson: nullableStringDynamicMapToJson) final  Map<String, dynamic>? payload}): _payload = payload,super._();
  

@override@JsonKey(fromJson: looseStringFromJson) final  String id;
@override@JsonKey(fromJson: looseStringFromJson) final  String type;
@override@JsonKey(fromJson: looseStringFromJson) final  String title;
@override@JsonKey(fromJson: looseStringFromJson) final  String message;
@override@JsonKey(fromJson: _periodFromJson) final  String period;
@override@JsonKey(fromJson: looseDoubleFromJson) final  double value;
@override@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) final  DateTime? createdAt;
@override@JsonKey(fromJson: nullableLooseStringFromJson) final  String? weekKey;
@override@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) final  DateTime? weekStart;
@override@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) final  DateTime? weekEnd;
 final  Map<String, dynamic>? _payload;
@override@JsonKey(fromJson: nullableStringDynamicMapFromJson, toJson: nullableStringDynamicMapToJson) Map<String, dynamic>? get payload {
  final value = _payload;
  if (value == null) return null;
  if (_payload is EqualUnmodifiableMapView) return _payload;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of SalonInsight
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SalonInsightCopyWith<_SalonInsight> get copyWith => __$SalonInsightCopyWithImpl<_SalonInsight>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SalonInsight&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.message, message) || other.message == message)&&(identical(other.period, period) || other.period == period)&&(identical(other.value, value) || other.value == value)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.weekKey, weekKey) || other.weekKey == weekKey)&&(identical(other.weekStart, weekStart) || other.weekStart == weekStart)&&(identical(other.weekEnd, weekEnd) || other.weekEnd == weekEnd)&&const DeepCollectionEquality().equals(other._payload, _payload));
}


@override
int get hashCode => Object.hash(runtimeType,id,type,title,message,period,value,createdAt,weekKey,weekStart,weekEnd,const DeepCollectionEquality().hash(_payload));

@override
String toString() {
  return 'SalonInsight(id: $id, type: $type, title: $title, message: $message, period: $period, value: $value, createdAt: $createdAt, weekKey: $weekKey, weekStart: $weekStart, weekEnd: $weekEnd, payload: $payload)';
}


}

/// @nodoc
abstract mixin class _$SalonInsightCopyWith<$Res> implements $SalonInsightCopyWith<$Res> {
  factory _$SalonInsightCopyWith(_SalonInsight value, $Res Function(_SalonInsight) _then) = __$SalonInsightCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: looseStringFromJson) String id,@JsonKey(fromJson: looseStringFromJson) String type,@JsonKey(fromJson: looseStringFromJson) String title,@JsonKey(fromJson: looseStringFromJson) String message,@JsonKey(fromJson: _periodFromJson) String period,@JsonKey(fromJson: looseDoubleFromJson) double value,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? createdAt,@JsonKey(fromJson: nullableLooseStringFromJson) String? weekKey,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? weekStart,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? weekEnd,@JsonKey(fromJson: nullableStringDynamicMapFromJson, toJson: nullableStringDynamicMapToJson) Map<String, dynamic>? payload
});




}
/// @nodoc
class __$SalonInsightCopyWithImpl<$Res>
    implements _$SalonInsightCopyWith<$Res> {
  __$SalonInsightCopyWithImpl(this._self, this._then);

  final _SalonInsight _self;
  final $Res Function(_SalonInsight) _then;

/// Create a copy of SalonInsight
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? title = null,Object? message = null,Object? period = null,Object? value = null,Object? createdAt = freezed,Object? weekKey = freezed,Object? weekStart = freezed,Object? weekEnd = freezed,Object? payload = freezed,}) {
  return _then(_SalonInsight(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,weekKey: freezed == weekKey ? _self.weekKey : weekKey // ignore: cast_nullable_to_non_nullable
as String?,weekStart: freezed == weekStart ? _self.weekStart : weekStart // ignore: cast_nullable_to_non_nullable
as DateTime?,weekEnd: freezed == weekEnd ? _self.weekEnd : weekEnd // ignore: cast_nullable_to_non_nullable
as DateTime?,payload: freezed == payload ? _self._payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on
