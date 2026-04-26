// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'retention_insight_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RetentionInsightPayload _$RetentionInsightPayloadFromJson(
  Map<String, dynamic> json,
) => _RetentionInsightPayload(
  timeZone: _timeZoneFromJson(json['timeZone']),
  calendarYear: looseIntFromJson(json['calendarYear']),
  calendarMonth: looseIntFromJson(json['calendarMonth']),
  repeatCustomersThisMonth: looseIntFromJson(json['repeatCustomersThisMonth']),
  firstTimeCustomersThisMonth: looseIntFromJson(
    json['firstTimeCustomersThisMonth'],
  ),
  distinctCustomersCompletedThisMonth: looseIntFromJson(
    json['distinctCustomersCompletedThisMonth'],
  ),
  returningCustomersThisMonth: looseIntFromJson(
    json['returningCustomersThisMonth'],
  ),
  retentionRate: looseDoubleFromJson(json['retentionRate']),
  customersWithNoVisit30Days: looseIntFromJson(
    json['customersWithNoVisit30Days'],
  ),
  noShowCountLastLocalWeek: looseIntFromJson(json['noShowCountLastLocalWeek']),
  noShowCountPreviousLocalWeek: looseIntFromJson(
    json['noShowCountPreviousLocalWeek'],
  ),
  noShowDeltaLastVsPrevious: looseIntFromJson(
    json['noShowDeltaLastVsPrevious'],
  ),
);

Map<String, dynamic> _$RetentionInsightPayloadToJson(
  _RetentionInsightPayload instance,
) => <String, dynamic>{
  'timeZone': instance.timeZone,
  'calendarYear': instance.calendarYear,
  'calendarMonth': instance.calendarMonth,
  'repeatCustomersThisMonth': instance.repeatCustomersThisMonth,
  'firstTimeCustomersThisMonth': instance.firstTimeCustomersThisMonth,
  'distinctCustomersCompletedThisMonth':
      instance.distinctCustomersCompletedThisMonth,
  'returningCustomersThisMonth': instance.returningCustomersThisMonth,
  'retentionRate': instance.retentionRate,
  'customersWithNoVisit30Days': instance.customersWithNoVisit30Days,
  'noShowCountLastLocalWeek': instance.noShowCountLastLocalWeek,
  'noShowCountPreviousLocalWeek': instance.noShowCountPreviousLocalWeek,
  'noShowDeltaLastVsPrevious': instance.noShowDeltaLastVsPrevious,
};
