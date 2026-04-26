import 'package:flutter/material.dart';

enum SmartWorkspaceFlowType {
  payrollSetupWizard('payroll_setup_wizard'),
  addPayrollElement('add_payroll_element'),
  payrollExplanation('payroll_explanation'),
  dynamicAnalytics('dynamic_analytics'),
  attendanceCorrection('attendance_correction'),
  bookingHelper('booking_helper'),
  unknown('unknown');

  const SmartWorkspaceFlowType(this.wireValue);

  final String wireValue;

  static SmartWorkspaceFlowType fromWireValue(String raw) {
    final normalized = raw.trim().toLowerCase();
    return SmartWorkspaceFlowType.values.firstWhere(
      (value) => value.wireValue == normalized,
      orElse: () => SmartWorkspaceFlowType.unknown,
    );
  }
}

enum SmartWorkspaceComponentType {
  summaryCard('summary_card'),
  statusChip('status_chip'),
  employeePicker('employee_picker'),
  payrollElementCard('payroll_element_card'),
  earningsBreakdownCard('earnings_breakdown_card'),
  deductionsBreakdownCard('deductions_breakdown_card'),
  dateRangePicker('date_range_picker'),
  periodSelector('period_selector'),
  actionButtonRow('action_button_row'),
  chartCard('chart_card'),
  emptyStateCard('empty_state_card'),
  confirmationPanel('confirmation_panel');

  const SmartWorkspaceComponentType(this.wireValue);

  final String wireValue;
}

enum SmartWorkspaceActionType {
  navigate('navigate'),
  prompt('prompt'),
  submit('submit'),
  setSelection('set_selection'),
  refresh('refresh');

  const SmartWorkspaceActionType(this.wireValue);

  final String wireValue;
}

enum SmartWorkspaceStatusTone { neutral, positive, warning, danger, info }

class SmartWorkspaceOption {
  const SmartWorkspaceOption({
    required this.id,
    required this.label,
    this.subtitle,
  });

  final String id;
  final String label;
  final String? subtitle;
}

class SmartWorkspaceDataPoint {
  const SmartWorkspaceDataPoint({
    required this.label,
    required this.value,
    this.secondaryValue,
  });

  final String label;
  final double value;
  final double? secondaryValue;
}

class SmartWorkspaceFactLine {
  const SmartWorkspaceFactLine({
    required this.label,
    required this.value,
    this.emphasis = false,
  });

  final String label;
  final String value;
  final bool emphasis;
}

class SmartWorkspaceAction {
  const SmartWorkspaceAction({
    required this.id,
    required this.label,
    required this.type,
    this.route,
    this.prompt,
    this.command,
    this.selectionKey,
    this.selectionValue,
    this.primary = false,
  });

  final String id;
  final String label;
  final SmartWorkspaceActionType type;
  final String? route;
  final String? prompt;
  final String? command;
  final String? selectionKey;
  final String? selectionValue;
  final bool primary;
}

class SmartWorkspaceComponent {
  const SmartWorkspaceComponent({
    required this.id,
    required this.type,
    this.title,
    this.subtitle,
    this.value,
    this.caption,
    this.tone,
    this.options = const [],
    this.lines = const [],
    this.actions = const [],
    this.points = const [],
    this.selectionKey,
    this.selectedOptionId,
    this.period,
    this.startDate,
    this.endDate,
    this.icon,
  });

  final String id;
  final SmartWorkspaceComponentType type;
  final String? title;
  final String? subtitle;
  final String? value;
  final String? caption;
  final SmartWorkspaceStatusTone? tone;
  final List<SmartWorkspaceOption> options;
  final List<SmartWorkspaceFactLine> lines;
  final List<SmartWorkspaceAction> actions;
  final List<SmartWorkspaceDataPoint> points;
  final String? selectionKey;
  final String? selectedOptionId;
  final DateTime? period;
  final DateTime? startDate;
  final DateTime? endDate;
  final IconData? icon;
}

class SmartWorkspaceSurface {
  const SmartWorkspaceSurface({
    required this.surfaceId,
    required this.flow,
    required this.components,
    this.title,
    this.summary,
  });

  final String surfaceId;
  final SmartWorkspaceFlowType flow;
  final String? title;
  final String? summary;
  final List<SmartWorkspaceComponent> components;
}
