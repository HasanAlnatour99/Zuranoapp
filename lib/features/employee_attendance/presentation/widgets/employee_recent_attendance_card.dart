import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../employee_today/data/models/et_attendance_day.dart';
import '../../../employee_today/presentation/employee_today_theme.dart';
import 'employee_attendance_shell.dart';

class EmployeeRecentAttendanceCard extends StatelessWidget {
  const EmployeeRecentAttendanceCard({
    super.key,
    required this.days,
    required this.onOpenDay,
    required this.loading,
    required this.error,
    required this.onRetry,
    required this.onSeeAll,
  });

  final List<EtAttendanceDay> days;
  final void Function(EtAttendanceDay day) onOpenDay;
  final bool loading;
  final Object? error;
  final VoidCallback onRetry;
  final VoidCallback onSeeAll;

  String _statusLabel(AppLocalizations l10n, EtAttendanceDay d) {
    if (d.hasMissingPunch) {
      return l10n.employeeAttendanceStatusMissingPunch;
    }
    if (d.isLateAfterGrace) {
      return l10n.barberAttendanceStatusLate;
    }
    if (d.firstPunchInAt == null) {
      return l10n.barberAttendanceStatusAbsent;
    }
    return l10n.employeeAttendanceStatusOnTime;
  }

  Color _statusColor(EtAttendanceDay d) {
    if (d.hasMissingPunch) {
      return const Color(0xFFF04438);
    }
    if (d.isLateAfterGrace) {
      return EmployeeTodayColors.amber;
    }
    if (d.firstPunchInAt == null) {
      return EmployeeTodayColors.mutedText;
    }
    return EmployeeTodayColors.success;
  }

  String _worked(EtAttendanceDay d) {
    final m = d.workedMinutes;
    final h = m ~/ 60;
    final r = m % 60;
    return '${h}h ${r}m';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    return Container(
      decoration: zuranoAttendanceCardDecoration(),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.employeeRecentAttendanceTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: EmployeeTodayColors.deepText,
                  ),
                ),
              ),
              TextButton(
                onPressed: onSeeAll,
                child: Text(l10n.employeeAttendanceSeeAll),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (loading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else if (error != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.employeeRecentAttendanceLoadError),
                TextButton(
                  onPressed: onRetry,
                  child: Text(l10n.commonRetry),
                ),
              ],
            )
          else if (days.isEmpty)
            Text(
              l10n.employeeRecentAttendanceEmpty,
              style: const TextStyle(
                color: EmployeeTodayColors.mutedText,
                height: 1.4,
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: days.length,
              separatorBuilder: (_, __) => const Divider(height: 20),
              itemBuilder: (context, i) {
                final d = days[i];
                final dateLine = DateFormat.yMMMd(
                  locale,
                ).format(d.date.toLocal());
                final inT = d.firstPunchInAt != null
                    ? DateFormat.jm().format(d.firstPunchInAt!.toLocal())
                    : '—';
                final outT = d.lastPunchOutAt != null
                    ? DateFormat.jm().format(d.lastPunchOutAt!.toLocal())
                    : '—';
                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => onOpenDay(d),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dateLine,
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$inT – $outT · ${_worked(d)}',
                              style: const TextStyle(
                                color: EmployeeTodayColors.mutedText,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _statusColor(d).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _statusLabel(l10n, d),
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                            color: _statusColor(d),
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: EmployeeTodayColors.mutedText,
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
