import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../employee_dashboard/domain/enums/attendance_punch_type.dart';
import '../../../employee_today/data/models/et_attendance_day.dart';
import '../../../employee_today/data/models/et_attendance_punch.dart';
import '../../../employee_today/data/models/et_attendance_settings.dart';
import '../../../employee_today/presentation/employee_today_theme.dart';
import 'employee_attendance_shell.dart';

class EmployeeTodayTimelineCard extends StatelessWidget {
  const EmployeeTodayTimelineCard({
    super.key,
    required this.settings,
    required this.day,
    required this.punches,
    required this.onRequestCorrection,
    required this.correctionAllowed,
  });

  final EtAttendanceSettings settings;
  final EtAttendanceDay? day;
  final List<EtAttendancePunch> punches;
  final VoidCallback onRequestCorrection;
  final bool correctionAllowed;

  EtAttendancePunch? _first(AttendancePunchType t) {
    for (final p in punches) {
      if (p.type == t) {
        return p;
      }
    }
    return null;
  }

  String _time(BuildContext context, EtAttendancePunch? p) {
    if (p == null) {
      return '—';
    }
    final locale = Localizations.localeOf(context);
    return locale.languageCode == 'ar'
        ? DateFormat.jm('ar').format(p.punchTime.toLocal())
        : DateFormat.jm('en').format(p.punchTime.toLocal());
  }

  String _shiftLine() {
    final a = settings.standardShiftStart;
    final b = settings.standardShiftEnd;
    if (a == null || b == null || !a.contains(':') || !b.contains(':')) {
      return '';
    }
    return '$a – $b';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pin = _first(AttendancePunchType.punchIn);
    final bout = _first(AttendancePunchType.breakOut);
    final bin = _first(AttendancePunchType.breakIn);
    final pout = _first(AttendancePunchType.punchOut);
    final missing = day?.hasMissingPunch == true;

    return Container(
      decoration: zuranoAttendanceCardDecoration(),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.employeeTimelineTodayTitle,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: EmployeeTodayColors.deepText,
            ),
          ),
          const SizedBox(height: 14),
          _TimelineRow(
            l10n: l10n,
            title: l10n.employeeTodayStatusCheckedIn,
            time: _time(context, pin),
            accent: EmployeeTodayColors.success,
            done: pin != null,
            detail: pin != null && pin.distanceFromSalonMeters != null
                ? '${pin.distanceFromSalonMeters!.round()} m'
                : null,
            inside: pin?.insideZone,
          ),
          _TimelineRow(
            l10n: l10n,
            title: l10n.employeeTimelineBreakOutTitle,
            time: _time(context, bout),
            accent: EmployeeTodayColors.amber,
            done: bout != null,
            detail: bout != null && bout.distanceFromSalonMeters != null
                ? '${bout.distanceFromSalonMeters!.round()} m'
                : null,
            inside: bout?.insideZone,
          ),
          _TimelineRow(
            l10n: l10n,
            title: l10n.employeeTimelineBreakInTitle,
            time: _time(context, bin),
            accent: EmployeeTodayColors.primaryPurple,
            done: bin != null,
            detail: bin != null && bin.distanceFromSalonMeters != null
                ? '${bin.distanceFromSalonMeters!.round()} m'
                : null,
            inside: bin?.insideZone,
          ),
          _TimelineRow(
            l10n: l10n,
            title: l10n.employeeTodayStatusCheckedOut,
            time: _time(context, pout),
            accent: EmployeeTodayColors.mutedText,
            done: pout != null,
            detail: pout != null && pout.distanceFromSalonMeters != null
                ? '${pout.distanceFromSalonMeters!.round()} m'
                : null,
            inside: pout?.insideZone,
            missing: missing && pout == null,
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: EmployeeTodayColors.primaryPurple.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.employeeTimelineWorkingHours,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _shiftLine().isEmpty
                      ? l10n.employeeTimelineShiftNotSet
                      : _shiftLine(),
                  style: const TextStyle(
                    color: EmployeeTodayColors.mutedText,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          if (missing && correctionAllowed) ...[
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onRequestCorrection,
              icon: const Icon(Icons.edit_calendar_outlined),
              label: Text(l10n.employeeTodayRequestCorrection),
            ),
          ],
        ],
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.l10n,
    required this.title,
    required this.time,
    required this.accent,
    required this.done,
    this.detail,
    this.inside,
    this.missing = false,
  });

  final AppLocalizations l10n;
  final String title;
  final String time;
  final Color accent;
  final bool done;
  final String? detail;
  final bool? inside;
  final bool missing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: missing
                      ? const Color(0xFFF04438)
                      : (done ? accent : EmployeeTodayColors.cardBorder),
                  border: Border.all(
                    color: done ? accent : EmployeeTodayColors.mutedText,
                    width: 2,
                  ),
                ),
              ),
              Container(
                width: 2,
                height: 28,
                color: EmployeeTodayColors.cardBorder,
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: const TextStyle(
                    color: EmployeeTodayColors.mutedText,
                    fontSize: 13,
                  ),
                ),
                if (detail != null || inside != null) ...[
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      if (detail != null)
                        Chip(
                          label: Text(detail!),
                          visualDensity: VisualDensity.compact,
                          labelStyle: const TextStyle(fontSize: 11),
                        ),
                      if (inside == true)
                        Chip(
                          label: Text(l10n.employeeAttendanceWithinRange),
                          visualDensity: VisualDensity.compact,
                          labelStyle: const TextStyle(fontSize: 11),
                        ),
                      if (inside == false)
                        Chip(
                          label: Text(l10n.employeeAttendanceOutsideRange),
                          visualDensity: VisualDensity.compact,
                          labelStyle: const TextStyle(fontSize: 11),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
