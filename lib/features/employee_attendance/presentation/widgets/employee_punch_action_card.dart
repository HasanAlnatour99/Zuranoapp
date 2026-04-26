import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../employee_dashboard/domain/enums/attendance_punch_type.dart';
import '../../../employee_today/data/models/et_attendance_day.dart';
import '../../../employee_today/data/models/et_attendance_settings.dart';
import '../../../employee_today/presentation/employee_today_theme.dart';
import 'employee_attendance_shell.dart';

class EmployeePunchActionCard extends StatelessWidget {
  const EmployeePunchActionCard({
    super.key,
    required this.settings,
    required this.day,
    required this.busyType,
    required this.onPunch,
    required this.onCorrection,
    required this.correctionAllowed,
  });

  final EtAttendanceSettings settings;
  final EtAttendanceDay? day;
  final AttendancePunchType? busyType;
  final void Function(AttendancePunchType type) onPunch;
  final VoidCallback onCorrection;
  final bool correctionAllowed;

  String _label(AppLocalizations l10n, AttendancePunchType t) {
    switch (t) {
      case AttendancePunchType.punchIn:
        return l10n.employeeTodayPunchIn;
      case AttendancePunchType.punchOut:
        return l10n.employeeTodayPunchOut;
      case AttendancePunchType.breakOut:
        return l10n.employeeTodayBreakOut;
      case AttendancePunchType.breakIn:
        return l10n.employeeTodayBreakIn;
    }
  }

  IconData _icon(AttendancePunchType t) {
    switch (t) {
      case AttendancePunchType.punchIn:
        return Icons.login_rounded;
      case AttendancePunchType.punchOut:
        return Icons.logout_rounded;
      case AttendancePunchType.breakOut:
        return Icons.free_breakfast_outlined;
      case AttendancePunchType.breakIn:
        return Icons.coffee_rounded;
    }
  }

  String _helper(
    AppLocalizations l10n,
    AttendancePunchType? next, {
    required bool missing,
  }) {
    if (missing && correctionAllowed) {
      return l10n.employeePunchMissingDetectedWithCorrection;
    }
    if (next == null) {
      return l10n.employeePunchDoneForToday;
    }
    switch (next) {
      case AttendancePunchType.punchIn:
        return settings.gpsRequired
            ? l10n.employeePunchMustBeInZone
            : l10n.employeePunchTapWhenArrive;
      case AttendancePunchType.breakOut:
        return l10n.employeePunchBreakLimitMinutes(
          settings.maxBreakMinutesPerDay,
        );
      case AttendancePunchType.breakIn:
        return l10n.employeePunchReturnFromBreak;
      case AttendancePunchType.punchOut:
        return l10n.employeePunchEndWorkingDay;
    }
  }

  List<Widget> _actions(AppLocalizations l10n) {
    final seq = day?.punchSequence ?? const <String>[];
    final missing = day?.hasMissingPunch == true;

    if (missing) {
      if (correctionAllowed) {
        return [
          _GradientButton(
            label: l10n.employeePunchSubmitCorrection,
            icon: Icons.edit_calendar_rounded,
            loading: false,
            onPressed: onCorrection,
          ),
        ];
      }
      return [
        Text(
          l10n.employeePunchMissingAskAdmin,
          style: const TextStyle(
            color: EmployeeTodayColors.mutedText,
            height: 1.35,
          ),
        ),
      ];
    }

    if (seq.isEmpty) {
      return [
        _GradientButton(
          label: _label(l10n, AttendancePunchType.punchIn),
          icon: _icon(AttendancePunchType.punchIn),
          loading: busyType == AttendancePunchType.punchIn,
          onPressed: () => onPunch(AttendancePunchType.punchIn),
        ),
      ];
    }
    if (seq.last == AttendancePunchType.punchOut.name) {
      return [
        Text(
          l10n.employeePunchCompletedTodayTitle,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 16,
            color: EmployeeTodayColors.deepText,
          ),
        ),
      ];
    }
    if (seq.last == AttendancePunchType.breakOut.name) {
      return [
        _GradientButton(
          label: _label(l10n, AttendancePunchType.breakIn),
          icon: _icon(AttendancePunchType.breakIn),
          loading: busyType == AttendancePunchType.breakIn,
          onPressed: () => onPunch(AttendancePunchType.breakIn),
        ),
      ];
    }
    return [
      _GradientButton(
        label: _label(l10n, AttendancePunchType.punchOut),
        icon: _icon(AttendancePunchType.punchOut),
        loading: busyType == AttendancePunchType.punchOut,
        onPressed: () => onPunch(AttendancePunchType.punchOut),
      ),
      const SizedBox(height: 10),
      OutlinedButton.icon(
        onPressed: busyType != null
            ? null
            : () => onPunch(AttendancePunchType.breakOut),
        icon: const Icon(Icons.free_breakfast_outlined),
        label: Text(_label(l10n, AttendancePunchType.breakOut)),
      ),
    ];
  }

  AttendancePunchType? _nextType() {
    final seq = day?.punchSequence ?? const <String>[];
    if (day?.hasMissingPunch == true) {
      return null;
    }
    if (seq.isEmpty) {
      return AttendancePunchType.punchIn;
    }
    if (seq.last == AttendancePunchType.punchOut.name) {
      return null;
    }
    if (seq.last == AttendancePunchType.breakOut.name) {
      return AttendancePunchType.breakIn;
    }
    return AttendancePunchType.punchOut;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final next = _nextType();
    final missing = day?.hasMissingPunch == true;

    return Container(
      decoration: zuranoAttendanceCardDecoration(),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.employeePunchNextAction,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: EmployeeTodayColors.deepText,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _helper(l10n, next, missing: missing),
            style: const TextStyle(
              color: EmployeeTodayColors.mutedText,
              fontSize: 13,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          ..._actions(l10n),
        ],
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.label,
    required this.icon,
    required this.loading,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final bool loading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            EmployeeTodayColors.heroGradientStart,
            EmployeeTodayColors.heroGradientEnd,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: EmployeeTodayColors.primaryPurple.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: loading ? null : onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (loading)
                  const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                else ...[
                  Icon(icon, color: Colors.white),
                  const SizedBox(width: 10),
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
