import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/firestore/firestore_json_helpers.dart';

/// Single line on a payslip (`payroll` doc `deductionLines` array).
part 'payroll_deduction_line.freezed.dart';
part 'payroll_deduction_line.g.dart';

@freezed
abstract class PayrollDeductionLine with _$PayrollDeductionLine {
  const factory PayrollDeductionLine({
    @JsonKey(fromJson: _kindFromJson) required String kind,
    @JsonKey(fromJson: looseDoubleFromJson) required double amount,
    @JsonKey(fromJson: nullableLooseStringFromJson) String? violationId,
    @JsonKey(fromJson: nullableLooseStringFromJson) String? bookingId,
    @JsonKey(fromJson: nullableLooseStringFromJson) String? label,
  }) = _PayrollDeductionLine;

  /// e.g. `violation`, `manual`
  factory PayrollDeductionLine.fromJson(Map<String, dynamic> json) =>
      _$PayrollDeductionLineFromJson(json);

  static List<PayrollDeductionLine> listFromJson(Object? raw) {
    if (raw is! List) {
      return const [];
    }
    return raw
        .whereType<Map>()
        .map((e) => PayrollDeductionLine.fromJson(Map<String, dynamic>.from(e)))
        .toList(growable: false);
  }
}

String _kindFromJson(Object? value) =>
    nullableLooseStringFromJson(value) ?? 'violation';
