import 'package:json_schema_builder/json_schema_builder.dart';

abstract final class SmartWorkspaceIntentJsonSchema {
  static final Schema schema = Schema.object(
    title: 'SmartWorkspaceIntent',
    description:
        'Strict intent for the barber shop smart workspace assistant. This is not UI.',
    properties: {
      'flow': Schema.string(
        enumValues: const [
          'payroll_setup_wizard',
          'add_payroll_element',
          'payroll_explanation',
          'dynamic_analytics',
          'attendance_correction',
          'booking_helper',
          'unknown',
        ],
      ),
      'employeeQuery': Schema.string(),
      'elementName': Schema.string(),
      'elementClassification': Schema.string(
        enumValues: const ['earning', 'deduction', 'information'],
      ),
      'elementRecurrenceType': Schema.string(
        enumValues: const ['recurring', 'nonrecurring'],
      ),
      'elementCalculationMethod': Schema.string(
        enumValues: const ['fixed', 'percentage', 'derived'],
      ),
      'elementDefaultAmount': Schema.number(),
      'year': Schema.integer(),
      'month': Schema.integer(),
      'startDate': Schema.string(),
      'endDate': Schema.string(),
      'attendanceStatus': Schema.string(),
      'checkInTime': Schema.string(),
      'checkOutTime': Schema.string(),
      'note': Schema.string(),
    },
    required: const ['flow'],
  );

  static Map<String, Object?> get json => schema.value;
}
