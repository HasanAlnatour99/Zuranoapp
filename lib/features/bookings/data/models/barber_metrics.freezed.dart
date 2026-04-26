// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'barber_metrics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BarberMetrics {

@JsonKey(fromJson: looseStringFromJson) String get employeeId;@JsonKey(fromJson: looseStringFromJson) String get salonId;@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? get updatedAt;@JsonKey(fromJson: _windowDaysFromJson) int get windowDays;@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? get periodEndAt;@JsonKey(fromJson: looseIntFromJson) int get completedCount;@JsonKey(fromJson: looseIntFromJson) int get cancelledCount;@JsonKey(fromJson: looseIntFromJson) int get noShowCount;@JsonKey(fromJson: looseDoubleFromJson) double get completionRate;@JsonKey(fromJson: looseDoubleFromJson) double get cancellationRate;@JsonKey(fromJson: looseDoubleFromJson) double get noShowRate;@JsonKey(fromJson: stringIntMapFromJson, toJson: stringIntMapToJson) Map<String, int> get serviceCompletedCounts;@JsonKey(fromJson: looseIntFromJson) int get activeBookingMinutesInWindow;
/// Create a copy of BarberMetrics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BarberMetricsCopyWith<BarberMetrics> get copyWith => _$BarberMetricsCopyWithImpl<BarberMetrics>(this as BarberMetrics, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BarberMetrics&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.salonId, salonId) || other.salonId == salonId)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.windowDays, windowDays) || other.windowDays == windowDays)&&(identical(other.periodEndAt, periodEndAt) || other.periodEndAt == periodEndAt)&&(identical(other.completedCount, completedCount) || other.completedCount == completedCount)&&(identical(other.cancelledCount, cancelledCount) || other.cancelledCount == cancelledCount)&&(identical(other.noShowCount, noShowCount) || other.noShowCount == noShowCount)&&(identical(other.completionRate, completionRate) || other.completionRate == completionRate)&&(identical(other.cancellationRate, cancellationRate) || other.cancellationRate == cancellationRate)&&(identical(other.noShowRate, noShowRate) || other.noShowRate == noShowRate)&&const DeepCollectionEquality().equals(other.serviceCompletedCounts, serviceCompletedCounts)&&(identical(other.activeBookingMinutesInWindow, activeBookingMinutesInWindow) || other.activeBookingMinutesInWindow == activeBookingMinutesInWindow));
}


@override
int get hashCode => Object.hash(runtimeType,employeeId,salonId,updatedAt,windowDays,periodEndAt,completedCount,cancelledCount,noShowCount,completionRate,cancellationRate,noShowRate,const DeepCollectionEquality().hash(serviceCompletedCounts),activeBookingMinutesInWindow);

@override
String toString() {
  return 'BarberMetrics(employeeId: $employeeId, salonId: $salonId, updatedAt: $updatedAt, windowDays: $windowDays, periodEndAt: $periodEndAt, completedCount: $completedCount, cancelledCount: $cancelledCount, noShowCount: $noShowCount, completionRate: $completionRate, cancellationRate: $cancellationRate, noShowRate: $noShowRate, serviceCompletedCounts: $serviceCompletedCounts, activeBookingMinutesInWindow: $activeBookingMinutesInWindow)';
}


}

/// @nodoc
abstract mixin class $BarberMetricsCopyWith<$Res>  {
  factory $BarberMetricsCopyWith(BarberMetrics value, $Res Function(BarberMetrics) _then) = _$BarberMetricsCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: looseStringFromJson) String employeeId,@JsonKey(fromJson: looseStringFromJson) String salonId,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? updatedAt,@JsonKey(fromJson: _windowDaysFromJson) int windowDays,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? periodEndAt,@JsonKey(fromJson: looseIntFromJson) int completedCount,@JsonKey(fromJson: looseIntFromJson) int cancelledCount,@JsonKey(fromJson: looseIntFromJson) int noShowCount,@JsonKey(fromJson: looseDoubleFromJson) double completionRate,@JsonKey(fromJson: looseDoubleFromJson) double cancellationRate,@JsonKey(fromJson: looseDoubleFromJson) double noShowRate,@JsonKey(fromJson: stringIntMapFromJson, toJson: stringIntMapToJson) Map<String, int> serviceCompletedCounts,@JsonKey(fromJson: looseIntFromJson) int activeBookingMinutesInWindow
});




}
/// @nodoc
class _$BarberMetricsCopyWithImpl<$Res>
    implements $BarberMetricsCopyWith<$Res> {
  _$BarberMetricsCopyWithImpl(this._self, this._then);

  final BarberMetrics _self;
  final $Res Function(BarberMetrics) _then;

/// Create a copy of BarberMetrics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? employeeId = null,Object? salonId = null,Object? updatedAt = freezed,Object? windowDays = null,Object? periodEndAt = freezed,Object? completedCount = null,Object? cancelledCount = null,Object? noShowCount = null,Object? completionRate = null,Object? cancellationRate = null,Object? noShowRate = null,Object? serviceCompletedCounts = null,Object? activeBookingMinutesInWindow = null,}) {
  return _then(_self.copyWith(
employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String,salonId: null == salonId ? _self.salonId : salonId // ignore: cast_nullable_to_non_nullable
as String,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,windowDays: null == windowDays ? _self.windowDays : windowDays // ignore: cast_nullable_to_non_nullable
as int,periodEndAt: freezed == periodEndAt ? _self.periodEndAt : periodEndAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedCount: null == completedCount ? _self.completedCount : completedCount // ignore: cast_nullable_to_non_nullable
as int,cancelledCount: null == cancelledCount ? _self.cancelledCount : cancelledCount // ignore: cast_nullable_to_non_nullable
as int,noShowCount: null == noShowCount ? _self.noShowCount : noShowCount // ignore: cast_nullable_to_non_nullable
as int,completionRate: null == completionRate ? _self.completionRate : completionRate // ignore: cast_nullable_to_non_nullable
as double,cancellationRate: null == cancellationRate ? _self.cancellationRate : cancellationRate // ignore: cast_nullable_to_non_nullable
as double,noShowRate: null == noShowRate ? _self.noShowRate : noShowRate // ignore: cast_nullable_to_non_nullable
as double,serviceCompletedCounts: null == serviceCompletedCounts ? _self.serviceCompletedCounts : serviceCompletedCounts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,activeBookingMinutesInWindow: null == activeBookingMinutesInWindow ? _self.activeBookingMinutesInWindow : activeBookingMinutesInWindow // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BarberMetrics].
extension BarberMetricsPatterns on BarberMetrics {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BarberMetrics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BarberMetrics() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BarberMetrics value)  $default,){
final _that = this;
switch (_that) {
case _BarberMetrics():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BarberMetrics value)?  $default,){
final _that = this;
switch (_that) {
case _BarberMetrics() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: looseStringFromJson)  String employeeId, @JsonKey(fromJson: looseStringFromJson)  String salonId, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? updatedAt, @JsonKey(fromJson: _windowDaysFromJson)  int windowDays, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? periodEndAt, @JsonKey(fromJson: looseIntFromJson)  int completedCount, @JsonKey(fromJson: looseIntFromJson)  int cancelledCount, @JsonKey(fromJson: looseIntFromJson)  int noShowCount, @JsonKey(fromJson: looseDoubleFromJson)  double completionRate, @JsonKey(fromJson: looseDoubleFromJson)  double cancellationRate, @JsonKey(fromJson: looseDoubleFromJson)  double noShowRate, @JsonKey(fromJson: stringIntMapFromJson, toJson: stringIntMapToJson)  Map<String, int> serviceCompletedCounts, @JsonKey(fromJson: looseIntFromJson)  int activeBookingMinutesInWindow)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BarberMetrics() when $default != null:
return $default(_that.employeeId,_that.salonId,_that.updatedAt,_that.windowDays,_that.periodEndAt,_that.completedCount,_that.cancelledCount,_that.noShowCount,_that.completionRate,_that.cancellationRate,_that.noShowRate,_that.serviceCompletedCounts,_that.activeBookingMinutesInWindow);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: looseStringFromJson)  String employeeId, @JsonKey(fromJson: looseStringFromJson)  String salonId, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? updatedAt, @JsonKey(fromJson: _windowDaysFromJson)  int windowDays, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? periodEndAt, @JsonKey(fromJson: looseIntFromJson)  int completedCount, @JsonKey(fromJson: looseIntFromJson)  int cancelledCount, @JsonKey(fromJson: looseIntFromJson)  int noShowCount, @JsonKey(fromJson: looseDoubleFromJson)  double completionRate, @JsonKey(fromJson: looseDoubleFromJson)  double cancellationRate, @JsonKey(fromJson: looseDoubleFromJson)  double noShowRate, @JsonKey(fromJson: stringIntMapFromJson, toJson: stringIntMapToJson)  Map<String, int> serviceCompletedCounts, @JsonKey(fromJson: looseIntFromJson)  int activeBookingMinutesInWindow)  $default,) {final _that = this;
switch (_that) {
case _BarberMetrics():
return $default(_that.employeeId,_that.salonId,_that.updatedAt,_that.windowDays,_that.periodEndAt,_that.completedCount,_that.cancelledCount,_that.noShowCount,_that.completionRate,_that.cancellationRate,_that.noShowRate,_that.serviceCompletedCounts,_that.activeBookingMinutesInWindow);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: looseStringFromJson)  String employeeId, @JsonKey(fromJson: looseStringFromJson)  String salonId, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? updatedAt, @JsonKey(fromJson: _windowDaysFromJson)  int windowDays, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson)  DateTime? periodEndAt, @JsonKey(fromJson: looseIntFromJson)  int completedCount, @JsonKey(fromJson: looseIntFromJson)  int cancelledCount, @JsonKey(fromJson: looseIntFromJson)  int noShowCount, @JsonKey(fromJson: looseDoubleFromJson)  double completionRate, @JsonKey(fromJson: looseDoubleFromJson)  double cancellationRate, @JsonKey(fromJson: looseDoubleFromJson)  double noShowRate, @JsonKey(fromJson: stringIntMapFromJson, toJson: stringIntMapToJson)  Map<String, int> serviceCompletedCounts, @JsonKey(fromJson: looseIntFromJson)  int activeBookingMinutesInWindow)?  $default,) {final _that = this;
switch (_that) {
case _BarberMetrics() when $default != null:
return $default(_that.employeeId,_that.salonId,_that.updatedAt,_that.windowDays,_that.periodEndAt,_that.completedCount,_that.cancelledCount,_that.noShowCount,_that.completionRate,_that.cancellationRate,_that.noShowRate,_that.serviceCompletedCounts,_that.activeBookingMinutesInWindow);case _:
  return null;

}
}

}

/// @nodoc


class _BarberMetrics implements BarberMetrics {
  const _BarberMetrics({@JsonKey(fromJson: looseStringFromJson) required this.employeeId, @JsonKey(fromJson: looseStringFromJson) required this.salonId, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) this.updatedAt, @JsonKey(fromJson: _windowDaysFromJson) this.windowDays = 30, @JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) this.periodEndAt, @JsonKey(fromJson: looseIntFromJson) this.completedCount = 0, @JsonKey(fromJson: looseIntFromJson) this.cancelledCount = 0, @JsonKey(fromJson: looseIntFromJson) this.noShowCount = 0, @JsonKey(fromJson: looseDoubleFromJson) this.completionRate = 0, @JsonKey(fromJson: looseDoubleFromJson) this.cancellationRate = 0, @JsonKey(fromJson: looseDoubleFromJson) this.noShowRate = 0, @JsonKey(fromJson: stringIntMapFromJson, toJson: stringIntMapToJson) final  Map<String, int> serviceCompletedCounts = const <String, int>{}, @JsonKey(fromJson: looseIntFromJson) this.activeBookingMinutesInWindow = 0}): _serviceCompletedCounts = serviceCompletedCounts;
  

@override@JsonKey(fromJson: looseStringFromJson) final  String employeeId;
@override@JsonKey(fromJson: looseStringFromJson) final  String salonId;
@override@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) final  DateTime? updatedAt;
@override@JsonKey(fromJson: _windowDaysFromJson) final  int windowDays;
@override@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) final  DateTime? periodEndAt;
@override@JsonKey(fromJson: looseIntFromJson) final  int completedCount;
@override@JsonKey(fromJson: looseIntFromJson) final  int cancelledCount;
@override@JsonKey(fromJson: looseIntFromJson) final  int noShowCount;
@override@JsonKey(fromJson: looseDoubleFromJson) final  double completionRate;
@override@JsonKey(fromJson: looseDoubleFromJson) final  double cancellationRate;
@override@JsonKey(fromJson: looseDoubleFromJson) final  double noShowRate;
 final  Map<String, int> _serviceCompletedCounts;
@override@JsonKey(fromJson: stringIntMapFromJson, toJson: stringIntMapToJson) Map<String, int> get serviceCompletedCounts {
  if (_serviceCompletedCounts is EqualUnmodifiableMapView) return _serviceCompletedCounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_serviceCompletedCounts);
}

@override@JsonKey(fromJson: looseIntFromJson) final  int activeBookingMinutesInWindow;

/// Create a copy of BarberMetrics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BarberMetricsCopyWith<_BarberMetrics> get copyWith => __$BarberMetricsCopyWithImpl<_BarberMetrics>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BarberMetrics&&(identical(other.employeeId, employeeId) || other.employeeId == employeeId)&&(identical(other.salonId, salonId) || other.salonId == salonId)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.windowDays, windowDays) || other.windowDays == windowDays)&&(identical(other.periodEndAt, periodEndAt) || other.periodEndAt == periodEndAt)&&(identical(other.completedCount, completedCount) || other.completedCount == completedCount)&&(identical(other.cancelledCount, cancelledCount) || other.cancelledCount == cancelledCount)&&(identical(other.noShowCount, noShowCount) || other.noShowCount == noShowCount)&&(identical(other.completionRate, completionRate) || other.completionRate == completionRate)&&(identical(other.cancellationRate, cancellationRate) || other.cancellationRate == cancellationRate)&&(identical(other.noShowRate, noShowRate) || other.noShowRate == noShowRate)&&const DeepCollectionEquality().equals(other._serviceCompletedCounts, _serviceCompletedCounts)&&(identical(other.activeBookingMinutesInWindow, activeBookingMinutesInWindow) || other.activeBookingMinutesInWindow == activeBookingMinutesInWindow));
}


@override
int get hashCode => Object.hash(runtimeType,employeeId,salonId,updatedAt,windowDays,periodEndAt,completedCount,cancelledCount,noShowCount,completionRate,cancellationRate,noShowRate,const DeepCollectionEquality().hash(_serviceCompletedCounts),activeBookingMinutesInWindow);

@override
String toString() {
  return 'BarberMetrics(employeeId: $employeeId, salonId: $salonId, updatedAt: $updatedAt, windowDays: $windowDays, periodEndAt: $periodEndAt, completedCount: $completedCount, cancelledCount: $cancelledCount, noShowCount: $noShowCount, completionRate: $completionRate, cancellationRate: $cancellationRate, noShowRate: $noShowRate, serviceCompletedCounts: $serviceCompletedCounts, activeBookingMinutesInWindow: $activeBookingMinutesInWindow)';
}


}

/// @nodoc
abstract mixin class _$BarberMetricsCopyWith<$Res> implements $BarberMetricsCopyWith<$Res> {
  factory _$BarberMetricsCopyWith(_BarberMetrics value, $Res Function(_BarberMetrics) _then) = __$BarberMetricsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: looseStringFromJson) String employeeId,@JsonKey(fromJson: looseStringFromJson) String salonId,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? updatedAt,@JsonKey(fromJson: _windowDaysFromJson) int windowDays,@JsonKey(fromJson: nullableFirestoreDateTimeFromJson, toJson: nullableFirestoreDateTimeToJson) DateTime? periodEndAt,@JsonKey(fromJson: looseIntFromJson) int completedCount,@JsonKey(fromJson: looseIntFromJson) int cancelledCount,@JsonKey(fromJson: looseIntFromJson) int noShowCount,@JsonKey(fromJson: looseDoubleFromJson) double completionRate,@JsonKey(fromJson: looseDoubleFromJson) double cancellationRate,@JsonKey(fromJson: looseDoubleFromJson) double noShowRate,@JsonKey(fromJson: stringIntMapFromJson, toJson: stringIntMapToJson) Map<String, int> serviceCompletedCounts,@JsonKey(fromJson: looseIntFromJson) int activeBookingMinutesInWindow
});




}
/// @nodoc
class __$BarberMetricsCopyWithImpl<$Res>
    implements _$BarberMetricsCopyWith<$Res> {
  __$BarberMetricsCopyWithImpl(this._self, this._then);

  final _BarberMetrics _self;
  final $Res Function(_BarberMetrics) _then;

/// Create a copy of BarberMetrics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? employeeId = null,Object? salonId = null,Object? updatedAt = freezed,Object? windowDays = null,Object? periodEndAt = freezed,Object? completedCount = null,Object? cancelledCount = null,Object? noShowCount = null,Object? completionRate = null,Object? cancellationRate = null,Object? noShowRate = null,Object? serviceCompletedCounts = null,Object? activeBookingMinutesInWindow = null,}) {
  return _then(_BarberMetrics(
employeeId: null == employeeId ? _self.employeeId : employeeId // ignore: cast_nullable_to_non_nullable
as String,salonId: null == salonId ? _self.salonId : salonId // ignore: cast_nullable_to_non_nullable
as String,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,windowDays: null == windowDays ? _self.windowDays : windowDays // ignore: cast_nullable_to_non_nullable
as int,periodEndAt: freezed == periodEndAt ? _self.periodEndAt : periodEndAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedCount: null == completedCount ? _self.completedCount : completedCount // ignore: cast_nullable_to_non_nullable
as int,cancelledCount: null == cancelledCount ? _self.cancelledCount : cancelledCount // ignore: cast_nullable_to_non_nullable
as int,noShowCount: null == noShowCount ? _self.noShowCount : noShowCount // ignore: cast_nullable_to_non_nullable
as int,completionRate: null == completionRate ? _self.completionRate : completionRate // ignore: cast_nullable_to_non_nullable
as double,cancellationRate: null == cancellationRate ? _self.cancellationRate : cancellationRate // ignore: cast_nullable_to_non_nullable
as double,noShowRate: null == noShowRate ? _self.noShowRate : noShowRate // ignore: cast_nullable_to_non_nullable
as double,serviceCompletedCounts: null == serviceCompletedCounts ? _self._serviceCompletedCounts : serviceCompletedCounts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,activeBookingMinutesInWindow: null == activeBookingMinutesInWindow ? _self.activeBookingMinutesInWindow : activeBookingMinutesInWindow // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
