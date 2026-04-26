import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/firestore/firestore_json_helpers.dart';
import '../../../../core/firestore/firestore_serializers.dart';

/// Salon-level penalty configuration (`salons/{salonId}.penaltySettings`).
part 'penalty_settings.freezed.dart';
part 'penalty_settings.g.dart';

@freezed
abstract class PenaltySettings with _$PenaltySettings {
  const factory PenaltySettings({
    @Default(false)
    @JsonKey(fromJson: falseBoolFromJson)
    bool barberLateEnabled,
    @Default(5)
    @JsonKey(fromJson: _lateGraceMinutesFromJson)
    int barberLateGraceMinutes,
    @Default(PenaltyCalculationTypes.flat)
    @JsonKey(fromJson: _lateTypeFromJson)
    String barberLateCalculationType,
    @Default(0) @JsonKey(fromJson: looseDoubleFromJson) double barberLateValue,
    @Default(false)
    @JsonKey(fromJson: falseBoolFromJson)
    bool barberNoShowEnabled,
    @Default(PenaltyCalculationTypes.flat)
    @JsonKey(fromJson: _noShowTypeFromJson)
    String barberNoShowCalculationType,
    @Default(0)
    @JsonKey(fromJson: looseDoubleFromJson)
    double barberNoShowValue,
  }) = _PenaltySettings;

  factory PenaltySettings.fromJson(Object? raw) => raw is! Map
      ? const PenaltySettings()
      : _$PenaltySettingsFromJson(Map<String, dynamic>.from(raw));

  static int _intInRange(int v, int min, int max, int fallback) {
    if (v < min || v > max) {
      return fallback;
    }
    return v;
  }

  static String _lateType(String? raw) {
    final s = raw?.trim() ?? '';
    if (s == PenaltyCalculationTypes.percent ||
        s == PenaltyCalculationTypes.perMinute ||
        s == PenaltyCalculationTypes.flat) {
      return s;
    }
    return PenaltyCalculationTypes.flat;
  }

  static String _noShowType(String? raw) {
    final s = raw?.trim() ?? '';
    if (s == PenaltyCalculationTypes.percent ||
        s == PenaltyCalculationTypes.flat) {
      return s;
    }
    return PenaltyCalculationTypes.flat;
  }
}

int _lateGraceMinutesFromJson(Object? value) {
  return PenaltySettings._intInRange(
    FirestoreSerializers.intValue(value),
    0,
    24 * 60,
    5,
  );
}

String _lateTypeFromJson(Object? value) =>
    PenaltySettings._lateType(FirestoreSerializers.string(value));

String _noShowTypeFromJson(Object? value) =>
    PenaltySettings._noShowType(FirestoreSerializers.string(value));

abstract final class PenaltyCalculationTypes {
  static const flat = 'flat';
  static const percent = 'percent';
  static const perMinute = 'per_minute';
}
