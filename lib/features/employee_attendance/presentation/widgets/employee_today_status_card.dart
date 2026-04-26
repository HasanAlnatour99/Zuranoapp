import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../employee_today/data/models/et_attendance_day.dart';
import '../../../employee_today/data/models/et_attendance_punch.dart';
import '../../../employee_today/data/models/et_attendance_settings.dart';
import '../../../employee_today/presentation/employee_today_theme.dart';
import 'employee_attendance_shell.dart';

class EmployeeTodayStatusCard extends StatelessWidget {
  const EmployeeTodayStatusCard({
    super.key,
    required this.settings,
    required this.day,
    required this.punches,
    required this.now,
    required this.liveWorkedMinutes,
  });

  final EtAttendanceSettings settings;
  final EtAttendanceDay? day;
  final List<EtAttendancePunch> punches;
  final DateTime now;
  final int liveWorkedMinutes;

  String _fmtTime(BuildContext context, DateTime? t) {
    if (t == null) {
      return '—';
    }
    final loc = Localizations.localeOf(context);
    return loc.languageCode == 'ar'
        ? DateFormat.jm('ar').format(t.toLocal())
        : DateFormat.jm('en').format(t.toLocal());
  }

  String _workedLabel() {
    final m = liveWorkedMinutes;
    final h = m ~/ 60;
    final r = m % 60;
    final s = now.second;
    return '${h.toString().padLeft(2, '0')}:'
        '${r.toString().padLeft(2, '0')}:'
        '${s.toString().padLeft(2, '0')}';
  }

  String _statusTitle(AppLocalizations l10n) {
    final d = day;
    if (d == null) {
      return l10n.employeeAttendanceStatusNotCheckedInTitle;
    }
    switch (d.status) {
      case 'onBreak':
        return l10n.employeeTodayStatusOnBreak;
      case 'checkedOut':
        return l10n.employeeTodayStatusCheckedOut;
      case 'incomplete':
        return d.hasMissingPunch
            ? l10n.employeeAttendanceStatusMissingPunch
            : l10n.employeeAttendanceStatusIncomplete;
      case 'checkedIn':
        return l10n.employeeTodayStatusCheckedIn;
      default:
        return l10n.employeeAttendanceStatusNotCheckedInTitle;
    }
  }

  Color _statusColor() {
    final d = day;
    if (d == null) {
      return EmployeeTodayColors.mutedText;
    }
    if (d.hasMissingPunch) {
      return const Color(0xFFF04438);
    }
    switch (d.status) {
      case 'onBreak':
        return EmployeeTodayColors.amber;
      case 'checkedOut':
        return EmployeeTodayColors.primaryPurple;
      case 'checkedIn':
        return EmployeeTodayColors.success;
      default:
        return EmployeeTodayColors.mutedText;
    }
  }

  DateTime? _statusTime() {
    final d = day;
    if (d == null) {
      return null;
    }
    if (punches.isEmpty) {
      return null;
    }
    return punches.last.punchTime;
  }

  String _expectedCheckout(BuildContext context) {
    final end = settings.standardShiftEnd;
    if (end == null || !end.contains(':')) {
      return '—';
    }
    final parts = end.split(':');
    final h = int.tryParse(parts[0]) ?? 18;
    final mm = int.tryParse(parts[1]) ?? 0;
    final t = DateTime(now.year, now.month, now.day, h, mm);
    final loc = Localizations.localeOf(context);
    return loc.languageCode == 'ar'
        ? DateFormat.jm('ar').format(t.toLocal())
        : DateFormat.jm('en').format(t.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final stColor = _statusColor();
    final statusTime = _statusTime();

    return Container(
      decoration: zuranoAttendanceCardDecoration(),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.employeeTodayStatusCardTitle,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: EmployeeTodayColors.deepText,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _Mini(
                  icon: Icons.verified_rounded,
                  iconColor: stColor,
                  label: _statusTitle(l10n),
                  value: statusTime != null
                      ? _fmtTime(context, statusTime)
                      : '—',
                  valueColor: stColor,
                ),
              ),
              Expanded(
                child: _Mini(
                  icon: Icons.timer_outlined,
                  iconColor: EmployeeTodayColors.primaryPurple,
                  label: l10n.employeeAttendanceWorkedLabel,
                  value: _workedLabel(),
                  valueColor: EmployeeTodayColors.deepText,
                ),
              ),
              Expanded(
                child: _Mini(
                  icon: Icons.logout_rounded,
                  iconColor: const Color(0xFFF97066),
                  label: l10n.employeeAttendanceExpectedCheckoutLabel,
                  value: _expectedCheckout(context),
                  valueColor: EmployeeTodayColors.deepText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Mini extends StatelessWidget {
  const _Mini({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: iconColor),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: EmployeeTodayColors.mutedText,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 13,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
