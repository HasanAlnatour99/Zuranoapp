import '../../../payroll/data/payroll_constants.dart';
import 'smart_workspace_models.dart';

class SmartWorkspaceIntent {
  const SmartWorkspaceIntent({
    required this.flow,
    this.employeeQuery,
    this.elementName,
    this.elementClassification,
    this.elementRecurrenceType,
    this.elementCalculationMethod,
    this.elementDefaultAmount,
    this.year,
    this.month,
    this.startDate,
    this.endDate,
    this.attendanceStatus,
    this.checkInTime,
    this.checkOutTime,
    this.note,
  });

  final SmartWorkspaceFlowType flow;
  final String? employeeQuery;
  final String? elementName;
  final String? elementClassification;
  final String? elementRecurrenceType;
  final String? elementCalculationMethod;
  final double? elementDefaultAmount;
  final int? year;
  final int? month;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? attendanceStatus;
  final String? checkInTime;
  final String? checkOutTime;
  final String? note;

  factory SmartWorkspaceIntent.fromJson(Map<String, dynamic> json) {
    return SmartWorkspaceIntent(
      flow: SmartWorkspaceFlowType.fromWireValue(json['flow'] as String? ?? ''),
      employeeQuery: _nullableString(json['employeeQuery']),
      elementName: _nullableString(json['elementName']),
      elementClassification: _sanitizeClassification(
        _nullableString(json['elementClassification']),
      ),
      elementRecurrenceType: _sanitizeRecurrence(
        _nullableString(json['elementRecurrenceType']),
      ),
      elementCalculationMethod: _sanitizeCalculationMethod(
        _nullableString(json['elementCalculationMethod']),
      ),
      elementDefaultAmount: _nullableDouble(json['elementDefaultAmount']),
      year: _nullableInt(json['year']),
      month: _nullableInt(json['month']),
      startDate: _nullableDate(json['startDate']),
      endDate: _nullableDate(json['endDate']),
      attendanceStatus: _nullableString(json['attendanceStatus']),
      checkInTime: _nullableString(json['checkInTime']),
      checkOutTime: _nullableString(json['checkOutTime']),
      note: _nullableString(json['note']),
    );
  }

  Map<String, Object?> toJson() {
    return {
      'flow': flow.wireValue,
      if (employeeQuery != null) 'employeeQuery': employeeQuery,
      if (elementName != null) 'elementName': elementName,
      if (elementClassification != null)
        'elementClassification': elementClassification,
      if (elementRecurrenceType != null)
        'elementRecurrenceType': elementRecurrenceType,
      if (elementCalculationMethod != null)
        'elementCalculationMethod': elementCalculationMethod,
      if (elementDefaultAmount != null)
        'elementDefaultAmount': elementDefaultAmount,
      if (year != null) 'year': year,
      if (month != null) 'month': month,
      if (startDate != null)
        'startDate': startDate!.toIso8601String().split('T').first,
      if (endDate != null)
        'endDate': endDate!.toIso8601String().split('T').first,
      if (attendanceStatus != null) 'attendanceStatus': attendanceStatus,
      if (checkInTime != null) 'checkInTime': checkInTime,
      if (checkOutTime != null) 'checkOutTime': checkOutTime,
      if (note != null) 'note': note,
    };
  }
}

String? _nullableString(Object? value) {
  if (value is String) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
  return null;
}

double? _nullableDouble(Object? value) {
  return switch (value) {
    num raw => raw.toDouble(),
    String raw => double.tryParse(raw.trim()),
    _ => null,
  };
}

int? _nullableInt(Object? value) {
  return switch (value) {
    int raw => raw,
    num raw => raw.toInt(),
    String raw => int.tryParse(raw.trim()),
    _ => null,
  };
}

DateTime? _nullableDate(Object? value) {
  if (value is! String || value.trim().isEmpty) {
    return null;
  }
  final parsed = DateTime.tryParse(value.trim());
  if (parsed == null) {
    return null;
  }
  return DateTime(parsed.year, parsed.month, parsed.day);
}

String? _sanitizeClassification(String? value) {
  return switch (value) {
    PayrollElementClassifications.earning => value,
    PayrollElementClassifications.deduction => value,
    PayrollElementClassifications.information => value,
    _ => null,
  };
}

String? _sanitizeRecurrence(String? value) {
  return switch (value) {
    PayrollRecurrenceTypes.recurring => value,
    PayrollRecurrenceTypes.nonrecurring => value,
    _ => null,
  };
}

String? _sanitizeCalculationMethod(String? value) {
  return switch (value) {
    PayrollCalculationMethods.fixed => value,
    PayrollCalculationMethods.percentage => value,
    PayrollCalculationMethods.derived => value,
    _ => null,
  };
}
