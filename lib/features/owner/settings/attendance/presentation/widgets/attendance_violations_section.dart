import 'package:flutter/material.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../../../settings/presentation/widgets/zurano/settings_section_card.dart';
import '../../domain/models/attendance_settings_model.dart';
import 'attendance_settings_form_helpers.dart';

/// Section 5 — HR violation rules (deductions + monthly allowances).
class AttendanceViolationsSection extends StatelessWidget {
  const AttendanceViolationsSection({
    super.key,
    required this.draft,
    required this.onChanged,
  });

  final AttendanceSettingsModel draft;
  final ValueChanged<AttendanceSettingsModel> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SettingsSectionCard(
      icon: Icons.shield_outlined,
      title: l10n.ownerAttendanceSectionViolations,
      subtitle: l10n.ownerSettingsHrTileSubtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AttendanceSwitchRow(
            label: l10n.ownerAttendanceViolationsAuto,
            subtitle: l10n.ownerAttendanceViolationsAutoHint,
            value: draft.autoCreateViolations,
            onChanged: (v) =>
                onChanged(draft.copyWith(autoCreateViolations: v)),
          ),
          const SizedBox(height: 16),
          AttendanceNumberField(
            label: l10n.ownerAttendanceViolationsMissingCheckoutPercent,
            value: draft.missingCheckoutDeductionPercent,
            min: 0,
            max: 100,
            suffix: '%',
            enabled: draft.autoCreateViolations,
            onChanged: (v) =>
                onChanged(draft.copyWith(missingCheckoutDeductionPercent: v)),
          ),
          const SizedBox(height: 12),
          AttendanceNumberField(
            label: l10n.ownerAttendanceViolationsAbsencePercent,
            value: draft.absenceDeductionPercent,
            min: 0,
            max: 100,
            suffix: '%',
            enabled: draft.autoCreateViolations,
            onChanged: (v) =>
                onChanged(draft.copyWith(absenceDeductionPercent: v)),
          ),
          const SizedBox(height: 12),
          AttendanceNumberField(
            label: l10n.ownerAttendanceViolationsLatePercent,
            value: draft.lateDeductionPercent,
            min: 0,
            max: 100,
            suffix: '%',
            enabled: draft.autoCreateViolations,
            onChanged: (v) =>
                onChanged(draft.copyWith(lateDeductionPercent: v)),
          ),
          const SizedBox(height: 12),
          AttendanceNumberField(
            label: l10n.ownerAttendanceViolationsEarlyExitPercent,
            value: draft.earlyExitDeductionPercent,
            min: 0,
            max: 100,
            suffix: '%',
            enabled: draft.autoCreateViolations,
            onChanged: (v) =>
                onChanged(draft.copyWith(earlyExitDeductionPercent: v)),
          ),
          const SizedBox(height: 16),
          AttendanceNumberField(
            label: l10n.ownerAttendanceViolationsLateAllowance,
            value: draft.allowedLateCountPerMonth,
            min: 0,
            max: 31,
            onChanged: (v) =>
                onChanged(draft.copyWith(allowedLateCountPerMonth: v)),
          ),
          const SizedBox(height: 12),
          AttendanceNumberField(
            label: l10n.ownerAttendanceViolationsEarlyExitAllowance,
            value: draft.allowedEarlyExitCountPerMonth,
            min: 0,
            max: 31,
            onChanged: (v) =>
                onChanged(draft.copyWith(allowedEarlyExitCountPerMonth: v)),
          ),
          const SizedBox(height: 12),
          AttendanceNumberField(
            label: l10n.ownerAttendanceViolationsMissingCheckoutAllowance,
            value: draft.allowedMissingCheckoutCountPerMonth,
            min: 0,
            max: 31,
            onChanged: (v) => onChanged(
              draft.copyWith(allowedMissingCheckoutCountPerMonth: v),
            ),
          ),
        ],
      ),
    );
  }
}
