// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'penalty_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PenaltySettings _$PenaltySettingsFromJson(Map<String, dynamic> json) =>
    _PenaltySettings(
      barberLateEnabled: json['barberLateEnabled'] == null
          ? false
          : falseBoolFromJson(json['barberLateEnabled']),
      barberLateGraceMinutes: json['barberLateGraceMinutes'] == null
          ? 5
          : _lateGraceMinutesFromJson(json['barberLateGraceMinutes']),
      barberLateCalculationType: json['barberLateCalculationType'] == null
          ? PenaltyCalculationTypes.flat
          : _lateTypeFromJson(json['barberLateCalculationType']),
      barberLateValue: json['barberLateValue'] == null
          ? 0
          : looseDoubleFromJson(json['barberLateValue']),
      barberNoShowEnabled: json['barberNoShowEnabled'] == null
          ? false
          : falseBoolFromJson(json['barberNoShowEnabled']),
      barberNoShowCalculationType: json['barberNoShowCalculationType'] == null
          ? PenaltyCalculationTypes.flat
          : _noShowTypeFromJson(json['barberNoShowCalculationType']),
      barberNoShowValue: json['barberNoShowValue'] == null
          ? 0
          : looseDoubleFromJson(json['barberNoShowValue']),
    );

Map<String, dynamic> _$PenaltySettingsToJson(_PenaltySettings instance) =>
    <String, dynamic>{
      'barberLateEnabled': instance.barberLateEnabled,
      'barberLateGraceMinutes': instance.barberLateGraceMinutes,
      'barberLateCalculationType': instance.barberLateCalculationType,
      'barberLateValue': instance.barberLateValue,
      'barberNoShowEnabled': instance.barberNoShowEnabled,
      'barberNoShowCalculationType': instance.barberNoShowCalculationType,
      'barberNoShowValue': instance.barberNoShowValue,
    };
