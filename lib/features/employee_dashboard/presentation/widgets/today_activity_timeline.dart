import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../l10n/app_localizations.dart';
import '../../../employee_today/presentation/employee_today_theme.dart';
import '../../data/models/attendance_event_model.dart';
import '../../domain/enums/attendance_punch_type.dart';

class TodayActivityTimeline extends StatelessWidget {
  const TodayActivityTimeline({super.key, required this.events});

  final List<AttendanceEventModel> events;

  static String _formatPunchTime(DateTime dt, Locale locale) {
    if (locale.languageCode == 'ar') {
      return intl.DateFormat.jm('ar').format(dt.toLocal());
    }
    return intl.DateFormat.jm('en').format(dt.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 8, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                l10n.employeeActivityTimelineTitle,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: EmployeeTodayColors.deepText,
                ),
              ),
              const Spacer(),
              Text(
                l10n.employeeActivityTimelineLive,
                style: const TextStyle(
                  fontSize: 13,
                  color: EmployeeTodayColors.primaryPurple,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (events.isEmpty)
            Text(
              l10n.employeeActivityTimelineEmpty,
              style: const TextStyle(color: EmployeeTodayColors.mutedText),
            )
          else
            ...events.map((e) => _Row(e: e, l10n: l10n, locale: locale)),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.e, required this.l10n, required this.locale});

  final AttendanceEventModel e;
  final AppLocalizations l10n;
  final Locale locale;

  String get _label => switch (e.type) {
    AttendancePunchType.punchIn => l10n.employeeTodayPunchIn,
    AttendancePunchType.punchOut => l10n.employeeTodayPunchOut,
    AttendancePunchType.breakOut => l10n.employeeTodayBreakOut,
    AttendancePunchType.breakIn => l10n.employeeTodayBreakIn,
  };

  @override
  Widget build(BuildContext context) {
    final isPunchIn = e.type == AttendancePunchType.punchIn;
    final color = isPunchIn
        ? const Color(0xFF16A34A)
        : EmployeeTodayColors.primaryPurple;
    final timeText = TodayActivityTimeline._formatPunchTime(
      e.createdAt,
      locale,
    );
    final timeDirection = locale.languageCode == 'ar'
        ? TextDirection.rtl
        : TextDirection.ltr;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isPunchIn ? Icons.check_circle : Icons.circle,
            size: 18,
            color: color,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: EmployeeTodayColors.deepText,
                  ),
                ),
                Directionality(
                  textDirection: timeDirection,
                  child: Text(
                    timeText,
                    style: const TextStyle(
                      fontSize: 13,
                      color: EmployeeTodayColors.mutedText,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
