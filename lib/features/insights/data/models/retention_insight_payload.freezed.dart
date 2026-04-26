// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'retention_insight_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RetentionInsightPayload {

@JsonKey(fromJson: _timeZoneFromJson) String get timeZone;@JsonKey(fromJson: looseIntFromJson) int get calendarYear;@JsonKey(fromJson: looseIntFromJson) int get calendarMonth;@JsonKey(fromJson: looseIntFromJson) int get repeatCustomersThisMonth;@JsonKey(fromJson: looseIntFromJson) int get firstTimeCustomersThisMonth;@JsonKey(fromJson: looseIntFromJson) int get distinctCustomersCompletedThisMonth;@JsonKey(fromJson: looseIntFromJson) int get returningCustomersThisMonth;@JsonKey(fromJson: looseDoubleFromJson) double get retentionRate;@JsonKey(fromJson: looseIntFromJson) int get customersWithNoVisit30Days;@JsonKey(fromJson: looseIntFromJson) int get noShowCountLastLocalWeek;@JsonKey(fromJson: looseIntFromJson) int get noShowCountPreviousLocalWeek;@JsonKey(fromJson: looseIntFromJson) int get noShowDeltaLastVsPrevious;
/// Create a copy of RetentionInsightPayload
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RetentionInsightPayloadCopyWith<RetentionInsightPayload> get copyWith => _$RetentionInsightPayloadCopyWithImpl<RetentionInsightPayload>(this as RetentionInsightPayload, _$identity);

  /// Serializes this RetentionInsightPayload to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RetentionInsightPayload&&(identical(other.timeZone, timeZone) || other.timeZone == timeZone)&&(identical(other.calendarYear, calendarYear) || other.calendarYear == calendarYear)&&(identical(other.calendarMonth, calendarMonth) || other.calendarMonth == calendarMonth)&&(identical(other.repeatCustomersThisMonth, repeatCustomersThisMonth) || other.repeatCustomersThisMonth == repeatCustomersThisMonth)&&(identical(other.firstTimeCustomersThisMonth, firstTimeCustomersThisMonth) || other.firstTimeCustomersThisMonth == firstTimeCustomersThisMonth)&&(identical(other.distinctCustomersCompletedThisMonth, distinctCustomersCompletedThisMonth) || other.distinctCustomersCompletedThisMonth == distinctCustomersCompletedThisMonth)&&(identical(other.returningCustomersThisMonth, returningCustomersThisMonth) || other.returningCustomersThisMonth == returningCustomersThisMonth)&&(identical(other.retentionRate, retentionRate) || other.retentionRate == retentionRate)&&(identical(other.customersWithNoVisit30Days, customersWithNoVisit30Days) || other.customersWithNoVisit30Days == customersWithNoVisit30Days)&&(identical(other.noShowCountLastLocalWeek, noShowCountLastLocalWeek) || other.noShowCountLastLocalWeek == noShowCountLastLocalWeek)&&(identical(other.noShowCountPreviousLocalWeek, noShowCountPreviousLocalWeek) || other.noShowCountPreviousLocalWeek == noShowCountPreviousLocalWeek)&&(identical(other.noShowDeltaLastVsPrevious, noShowDeltaLastVsPrevious) || other.noShowDeltaLastVsPrevious == noShowDeltaLastVsPrevious));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,timeZone,calendarYear,calendarMonth,repeatCustomersThisMonth,firstTimeCustomersThisMonth,distinctCustomersCompletedThisMonth,returningCustomersThisMonth,retentionRate,customersWithNoVisit30Days,noShowCountLastLocalWeek,noShowCountPreviousLocalWeek,noShowDeltaLastVsPrevious);

@override
String toString() {
  return 'RetentionInsightPayload(timeZone: $timeZone, calendarYear: $calendarYear, calendarMonth: $calendarMonth, repeatCustomersThisMonth: $repeatCustomersThisMonth, firstTimeCustomersThisMonth: $firstTimeCustomersThisMonth, distinctCustomersCompletedThisMonth: $distinctCustomersCompletedThisMonth, returningCustomersThisMonth: $returningCustomersThisMonth, retentionRate: $retentionRate, customersWithNoVisit30Days: $customersWithNoVisit30Days, noShowCountLastLocalWeek: $noShowCountLastLocalWeek, noShowCountPreviousLocalWeek: $noShowCountPreviousLocalWeek, noShowDeltaLastVsPrevious: $noShowDeltaLastVsPrevious)';
}


}

/// @nodoc
abstract mixin class $RetentionInsightPayloadCopyWith<$Res>  {
  factory $RetentionInsightPayloadCopyWith(RetentionInsightPayload value, $Res Function(RetentionInsightPayload) _then) = _$RetentionInsightPayloadCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _timeZoneFromJson) String timeZone,@JsonKey(fromJson: looseIntFromJson) int calendarYear,@JsonKey(fromJson: looseIntFromJson) int calendarMonth,@JsonKey(fromJson: looseIntFromJson) int repeatCustomersThisMonth,@JsonKey(fromJson: looseIntFromJson) int firstTimeCustomersThisMonth,@JsonKey(fromJson: looseIntFromJson) int distinctCustomersCompletedThisMonth,@JsonKey(fromJson: looseIntFromJson) int returningCustomersThisMonth,@JsonKey(fromJson: looseDoubleFromJson) double retentionRate,@JsonKey(fromJson: looseIntFromJson) int customersWithNoVisit30Days,@JsonKey(fromJson: looseIntFromJson) int noShowCountLastLocalWeek,@JsonKey(fromJson: looseIntFromJson) int noShowCountPreviousLocalWeek,@JsonKey(fromJson: looseIntFromJson) int noShowDeltaLastVsPrevious
});




}
/// @nodoc
class _$RetentionInsightPayloadCopyWithImpl<$Res>
    implements $RetentionInsightPayloadCopyWith<$Res> {
  _$RetentionInsightPayloadCopyWithImpl(this._self, this._then);

  final RetentionInsightPayload _self;
  final $Res Function(RetentionInsightPayload) _then;

/// Create a copy of RetentionInsightPayload
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? timeZone = null,Object? calendarYear = null,Object? calendarMonth = null,Object? repeatCustomersThisMonth = null,Object? firstTimeCustomersThisMonth = null,Object? distinctCustomersCompletedThisMonth = null,Object? returningCustomersThisMonth = null,Object? retentionRate = null,Object? customersWithNoVisit30Days = null,Object? noShowCountLastLocalWeek = null,Object? noShowCountPreviousLocalWeek = null,Object? noShowDeltaLastVsPrevious = null,}) {
  return _then(_self.copyWith(
timeZone: null == timeZone ? _self.timeZone : timeZone // ignore: cast_nullable_to_non_nullable
as String,calendarYear: null == calendarYear ? _self.calendarYear : calendarYear // ignore: cast_nullable_to_non_nullable
as int,calendarMonth: null == calendarMonth ? _self.calendarMonth : calendarMonth // ignore: cast_nullable_to_non_nullable
as int,repeatCustomersThisMonth: null == repeatCustomersThisMonth ? _self.repeatCustomersThisMonth : repeatCustomersThisMonth // ignore: cast_nullable_to_non_nullable
as int,firstTimeCustomersThisMonth: null == firstTimeCustomersThisMonth ? _self.firstTimeCustomersThisMonth : firstTimeCustomersThisMonth // ignore: cast_nullable_to_non_nullable
as int,distinctCustomersCompletedThisMonth: null == distinctCustomersCompletedThisMonth ? _self.distinctCustomersCompletedThisMonth : distinctCustomersCompletedThisMonth // ignore: cast_nullable_to_non_nullable
as int,returningCustomersThisMonth: null == returningCustomersThisMonth ? _self.returningCustomersThisMonth : returningCustomersThisMonth // ignore: cast_nullable_to_non_nullable
as int,retentionRate: null == retentionRate ? _self.retentionRate : retentionRate // ignore: cast_nullable_to_non_nullable
as double,customersWithNoVisit30Days: null == customersWithNoVisit30Days ? _self.customersWithNoVisit30Days : customersWithNoVisit30Days // ignore: cast_nullable_to_non_nullable
as int,noShowCountLastLocalWeek: null == noShowCountLastLocalWeek ? _self.noShowCountLastLocalWeek : noShowCountLastLocalWeek // ignore: cast_nullable_to_non_nullable
as int,noShowCountPreviousLocalWeek: null == noShowCountPreviousLocalWeek ? _self.noShowCountPreviousLocalWeek : noShowCountPreviousLocalWeek // ignore: cast_nullable_to_non_nullable
as int,noShowDeltaLastVsPrevious: null == noShowDeltaLastVsPrevious ? _self.noShowDeltaLastVsPrevious : noShowDeltaLastVsPrevious // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RetentionInsightPayload].
extension RetentionInsightPayloadPatterns on RetentionInsightPayload {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RetentionInsightPayload value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RetentionInsightPayload() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RetentionInsightPayload value)  $default,){
final _that = this;
switch (_that) {
case _RetentionInsightPayload():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RetentionInsightPayload value)?  $default,){
final _that = this;
switch (_that) {
case _RetentionInsightPayload() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _timeZoneFromJson)  String timeZone, @JsonKey(fromJson: looseIntFromJson)  int calendarYear, @JsonKey(fromJson: looseIntFromJson)  int calendarMonth, @JsonKey(fromJson: looseIntFromJson)  int repeatCustomersThisMonth, @JsonKey(fromJson: looseIntFromJson)  int firstTimeCustomersThisMonth, @JsonKey(fromJson: looseIntFromJson)  int distinctCustomersCompletedThisMonth, @JsonKey(fromJson: looseIntFromJson)  int returningCustomersThisMonth, @JsonKey(fromJson: looseDoubleFromJson)  double retentionRate, @JsonKey(fromJson: looseIntFromJson)  int customersWithNoVisit30Days, @JsonKey(fromJson: looseIntFromJson)  int noShowCountLastLocalWeek, @JsonKey(fromJson: looseIntFromJson)  int noShowCountPreviousLocalWeek, @JsonKey(fromJson: looseIntFromJson)  int noShowDeltaLastVsPrevious)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RetentionInsightPayload() when $default != null:
return $default(_that.timeZone,_that.calendarYear,_that.calendarMonth,_that.repeatCustomersThisMonth,_that.firstTimeCustomersThisMonth,_that.distinctCustomersCompletedThisMonth,_that.returningCustomersThisMonth,_that.retentionRate,_that.customersWithNoVisit30Days,_that.noShowCountLastLocalWeek,_that.noShowCountPreviousLocalWeek,_that.noShowDeltaLastVsPrevious);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _timeZoneFromJson)  String timeZone, @JsonKey(fromJson: looseIntFromJson)  int calendarYear, @JsonKey(fromJson: looseIntFromJson)  int calendarMonth, @JsonKey(fromJson: looseIntFromJson)  int repeatCustomersThisMonth, @JsonKey(fromJson: looseIntFromJson)  int firstTimeCustomersThisMonth, @JsonKey(fromJson: looseIntFromJson)  int distinctCustomersCompletedThisMonth, @JsonKey(fromJson: looseIntFromJson)  int returningCustomersThisMonth, @JsonKey(fromJson: looseDoubleFromJson)  double retentionRate, @JsonKey(fromJson: looseIntFromJson)  int customersWithNoVisit30Days, @JsonKey(fromJson: looseIntFromJson)  int noShowCountLastLocalWeek, @JsonKey(fromJson: looseIntFromJson)  int noShowCountPreviousLocalWeek, @JsonKey(fromJson: looseIntFromJson)  int noShowDeltaLastVsPrevious)  $default,) {final _that = this;
switch (_that) {
case _RetentionInsightPayload():
return $default(_that.timeZone,_that.calendarYear,_that.calendarMonth,_that.repeatCustomersThisMonth,_that.firstTimeCustomersThisMonth,_that.distinctCustomersCompletedThisMonth,_that.returningCustomersThisMonth,_that.retentionRate,_that.customersWithNoVisit30Days,_that.noShowCountLastLocalWeek,_that.noShowCountPreviousLocalWeek,_that.noShowDeltaLastVsPrevious);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _timeZoneFromJson)  String timeZone, @JsonKey(fromJson: looseIntFromJson)  int calendarYear, @JsonKey(fromJson: looseIntFromJson)  int calendarMonth, @JsonKey(fromJson: looseIntFromJson)  int repeatCustomersThisMonth, @JsonKey(fromJson: looseIntFromJson)  int firstTimeCustomersThisMonth, @JsonKey(fromJson: looseIntFromJson)  int distinctCustomersCompletedThisMonth, @JsonKey(fromJson: looseIntFromJson)  int returningCustomersThisMonth, @JsonKey(fromJson: looseDoubleFromJson)  double retentionRate, @JsonKey(fromJson: looseIntFromJson)  int customersWithNoVisit30Days, @JsonKey(fromJson: looseIntFromJson)  int noShowCountLastLocalWeek, @JsonKey(fromJson: looseIntFromJson)  int noShowCountPreviousLocalWeek, @JsonKey(fromJson: looseIntFromJson)  int noShowDeltaLastVsPrevious)?  $default,) {final _that = this;
switch (_that) {
case _RetentionInsightPayload() when $default != null:
return $default(_that.timeZone,_that.calendarYear,_that.calendarMonth,_that.repeatCustomersThisMonth,_that.firstTimeCustomersThisMonth,_that.distinctCustomersCompletedThisMonth,_that.returningCustomersThisMonth,_that.retentionRate,_that.customersWithNoVisit30Days,_that.noShowCountLastLocalWeek,_that.noShowCountPreviousLocalWeek,_that.noShowDeltaLastVsPrevious);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RetentionInsightPayload implements RetentionInsightPayload {
  const _RetentionInsightPayload({@JsonKey(fromJson: _timeZoneFromJson) required this.timeZone, @JsonKey(fromJson: looseIntFromJson) required this.calendarYear, @JsonKey(fromJson: looseIntFromJson) required this.calendarMonth, @JsonKey(fromJson: looseIntFromJson) required this.repeatCustomersThisMonth, @JsonKey(fromJson: looseIntFromJson) required this.firstTimeCustomersThisMonth, @JsonKey(fromJson: looseIntFromJson) required this.distinctCustomersCompletedThisMonth, @JsonKey(fromJson: looseIntFromJson) required this.returningCustomersThisMonth, @JsonKey(fromJson: looseDoubleFromJson) required this.retentionRate, @JsonKey(fromJson: looseIntFromJson) required this.customersWithNoVisit30Days, @JsonKey(fromJson: looseIntFromJson) required this.noShowCountLastLocalWeek, @JsonKey(fromJson: looseIntFromJson) required this.noShowCountPreviousLocalWeek, @JsonKey(fromJson: looseIntFromJson) required this.noShowDeltaLastVsPrevious});
  factory _RetentionInsightPayload.fromJson(Map<String, dynamic> json) => _$RetentionInsightPayloadFromJson(json);

@override@JsonKey(fromJson: _timeZoneFromJson) final  String timeZone;
@override@JsonKey(fromJson: looseIntFromJson) final  int calendarYear;
@override@JsonKey(fromJson: looseIntFromJson) final  int calendarMonth;
@override@JsonKey(fromJson: looseIntFromJson) final  int repeatCustomersThisMonth;
@override@JsonKey(fromJson: looseIntFromJson) final  int firstTimeCustomersThisMonth;
@override@JsonKey(fromJson: looseIntFromJson) final  int distinctCustomersCompletedThisMonth;
@override@JsonKey(fromJson: looseIntFromJson) final  int returningCustomersThisMonth;
@override@JsonKey(fromJson: looseDoubleFromJson) final  double retentionRate;
@override@JsonKey(fromJson: looseIntFromJson) final  int customersWithNoVisit30Days;
@override@JsonKey(fromJson: looseIntFromJson) final  int noShowCountLastLocalWeek;
@override@JsonKey(fromJson: looseIntFromJson) final  int noShowCountPreviousLocalWeek;
@override@JsonKey(fromJson: looseIntFromJson) final  int noShowDeltaLastVsPrevious;

/// Create a copy of RetentionInsightPayload
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RetentionInsightPayloadCopyWith<_RetentionInsightPayload> get copyWith => __$RetentionInsightPayloadCopyWithImpl<_RetentionInsightPayload>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RetentionInsightPayloadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RetentionInsightPayload&&(identical(other.timeZone, timeZone) || other.timeZone == timeZone)&&(identical(other.calendarYear, calendarYear) || other.calendarYear == calendarYear)&&(identical(other.calendarMonth, calendarMonth) || other.calendarMonth == calendarMonth)&&(identical(other.repeatCustomersThisMonth, repeatCustomersThisMonth) || other.repeatCustomersThisMonth == repeatCustomersThisMonth)&&(identical(other.firstTimeCustomersThisMonth, firstTimeCustomersThisMonth) || other.firstTimeCustomersThisMonth == firstTimeCustomersThisMonth)&&(identical(other.distinctCustomersCompletedThisMonth, distinctCustomersCompletedThisMonth) || other.distinctCustomersCompletedThisMonth == distinctCustomersCompletedThisMonth)&&(identical(other.returningCustomersThisMonth, returningCustomersThisMonth) || other.returningCustomersThisMonth == returningCustomersThisMonth)&&(identical(other.retentionRate, retentionRate) || other.retentionRate == retentionRate)&&(identical(other.customersWithNoVisit30Days, customersWithNoVisit30Days) || other.customersWithNoVisit30Days == customersWithNoVisit30Days)&&(identical(other.noShowCountLastLocalWeek, noShowCountLastLocalWeek) || other.noShowCountLastLocalWeek == noShowCountLastLocalWeek)&&(identical(other.noShowCountPreviousLocalWeek, noShowCountPreviousLocalWeek) || other.noShowCountPreviousLocalWeek == noShowCountPreviousLocalWeek)&&(identical(other.noShowDeltaLastVsPrevious, noShowDeltaLastVsPrevious) || other.noShowDeltaLastVsPrevious == noShowDeltaLastVsPrevious));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,timeZone,calendarYear,calendarMonth,repeatCustomersThisMonth,firstTimeCustomersThisMonth,distinctCustomersCompletedThisMonth,returningCustomersThisMonth,retentionRate,customersWithNoVisit30Days,noShowCountLastLocalWeek,noShowCountPreviousLocalWeek,noShowDeltaLastVsPrevious);

@override
String toString() {
  return 'RetentionInsightPayload(timeZone: $timeZone, calendarYear: $calendarYear, calendarMonth: $calendarMonth, repeatCustomersThisMonth: $repeatCustomersThisMonth, firstTimeCustomersThisMonth: $firstTimeCustomersThisMonth, distinctCustomersCompletedThisMonth: $distinctCustomersCompletedThisMonth, returningCustomersThisMonth: $returningCustomersThisMonth, retentionRate: $retentionRate, customersWithNoVisit30Days: $customersWithNoVisit30Days, noShowCountLastLocalWeek: $noShowCountLastLocalWeek, noShowCountPreviousLocalWeek: $noShowCountPreviousLocalWeek, noShowDeltaLastVsPrevious: $noShowDeltaLastVsPrevious)';
}


}

/// @nodoc
abstract mixin class _$RetentionInsightPayloadCopyWith<$Res> implements $RetentionInsightPayloadCopyWith<$Res> {
  factory _$RetentionInsightPayloadCopyWith(_RetentionInsightPayload value, $Res Function(_RetentionInsightPayload) _then) = __$RetentionInsightPayloadCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _timeZoneFromJson) String timeZone,@JsonKey(fromJson: looseIntFromJson) int calendarYear,@JsonKey(fromJson: looseIntFromJson) int calendarMonth,@JsonKey(fromJson: looseIntFromJson) int repeatCustomersThisMonth,@JsonKey(fromJson: looseIntFromJson) int firstTimeCustomersThisMonth,@JsonKey(fromJson: looseIntFromJson) int distinctCustomersCompletedThisMonth,@JsonKey(fromJson: looseIntFromJson) int returningCustomersThisMonth,@JsonKey(fromJson: looseDoubleFromJson) double retentionRate,@JsonKey(fromJson: looseIntFromJson) int customersWithNoVisit30Days,@JsonKey(fromJson: looseIntFromJson) int noShowCountLastLocalWeek,@JsonKey(fromJson: looseIntFromJson) int noShowCountPreviousLocalWeek,@JsonKey(fromJson: looseIntFromJson) int noShowDeltaLastVsPrevious
});




}
/// @nodoc
class __$RetentionInsightPayloadCopyWithImpl<$Res>
    implements _$RetentionInsightPayloadCopyWith<$Res> {
  __$RetentionInsightPayloadCopyWithImpl(this._self, this._then);

  final _RetentionInsightPayload _self;
  final $Res Function(_RetentionInsightPayload) _then;

/// Create a copy of RetentionInsightPayload
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? timeZone = null,Object? calendarYear = null,Object? calendarMonth = null,Object? repeatCustomersThisMonth = null,Object? firstTimeCustomersThisMonth = null,Object? distinctCustomersCompletedThisMonth = null,Object? returningCustomersThisMonth = null,Object? retentionRate = null,Object? customersWithNoVisit30Days = null,Object? noShowCountLastLocalWeek = null,Object? noShowCountPreviousLocalWeek = null,Object? noShowDeltaLastVsPrevious = null,}) {
  return _then(_RetentionInsightPayload(
timeZone: null == timeZone ? _self.timeZone : timeZone // ignore: cast_nullable_to_non_nullable
as String,calendarYear: null == calendarYear ? _self.calendarYear : calendarYear // ignore: cast_nullable_to_non_nullable
as int,calendarMonth: null == calendarMonth ? _self.calendarMonth : calendarMonth // ignore: cast_nullable_to_non_nullable
as int,repeatCustomersThisMonth: null == repeatCustomersThisMonth ? _self.repeatCustomersThisMonth : repeatCustomersThisMonth // ignore: cast_nullable_to_non_nullable
as int,firstTimeCustomersThisMonth: null == firstTimeCustomersThisMonth ? _self.firstTimeCustomersThisMonth : firstTimeCustomersThisMonth // ignore: cast_nullable_to_non_nullable
as int,distinctCustomersCompletedThisMonth: null == distinctCustomersCompletedThisMonth ? _self.distinctCustomersCompletedThisMonth : distinctCustomersCompletedThisMonth // ignore: cast_nullable_to_non_nullable
as int,returningCustomersThisMonth: null == returningCustomersThisMonth ? _self.returningCustomersThisMonth : returningCustomersThisMonth // ignore: cast_nullable_to_non_nullable
as int,retentionRate: null == retentionRate ? _self.retentionRate : retentionRate // ignore: cast_nullable_to_non_nullable
as double,customersWithNoVisit30Days: null == customersWithNoVisit30Days ? _self.customersWithNoVisit30Days : customersWithNoVisit30Days // ignore: cast_nullable_to_non_nullable
as int,noShowCountLastLocalWeek: null == noShowCountLastLocalWeek ? _self.noShowCountLastLocalWeek : noShowCountLastLocalWeek // ignore: cast_nullable_to_non_nullable
as int,noShowCountPreviousLocalWeek: null == noShowCountPreviousLocalWeek ? _self.noShowCountPreviousLocalWeek : noShowCountPreviousLocalWeek // ignore: cast_nullable_to_non_nullable
as int,noShowDeltaLastVsPrevious: null == noShowDeltaLastVsPrevious ? _self.noShowDeltaLastVsPrevious : noShowDeltaLastVsPrevious // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
