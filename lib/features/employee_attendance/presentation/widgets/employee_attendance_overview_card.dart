import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/employee_monthly_attendance_stats.dart';
import '../../../employee_today/presentation/employee_today_theme.dart';
import 'employee_attendance_shell.dart';

class EmployeeAttendanceOverviewCard extends StatelessWidget {
  const EmployeeAttendanceOverviewCard({
    super.key,
    required this.stats,
    required this.onViewCalendar,
    required this.loading,
    required this.error,
    required this.onRetry,
  });

  final EmployeeMonthlyAttendanceStats? stats;
  final VoidCallback onViewCalendar;
  final bool loading;
  final Object? error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                  l10n.employeeAttendanceOverviewTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: EmployeeTodayColors.deepText,
                  ),
                ),
              ),
              TextButton(
                onPressed: onViewCalendar,
                child: Text(l10n.employeeAttendanceViewCalendar),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            l10n.employeeAttendanceOverviewFootnote,
            style: const TextStyle(
              fontSize: 11,
              color: EmployeeTodayColors.mutedText,
            ),
          ),
          const SizedBox(height: 14),
          if (loading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else if (error != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.employeeAttendanceSummaryLoadError),
                TextButton(
                  onPressed: onRetry,
                  child: Text(l10n.commonRetry),
                ),
              ],
            )
          else if (stats == null)
            Text(l10n.employeeAttendanceNoDataYet)
          else
            Row(
              children: [
                Expanded(
                  child: _StatTile(
                    label: l10n.barberAttendanceStatusPresent,
                    value: '${stats!.presentDays}',
                    color: EmployeeTodayColors.success,
                    icon: Icons.check_circle_outline,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatTile(
                    label: l10n.barberAttendanceStatusAbsent,
                    value: '${stats!.absentDays}',
                    color: const Color(0xFFF04438),
                    icon: Icons.cancel_outlined,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatTile(
                    label: l10n.barberAttendanceStatusLate,
                    value: '${stats!.lateDays}',
                    color: EmployeeTodayColors.amber,
                    icon: Icons.schedule_rounded,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatTile(
                    label: l10n.employeeAttendanceOverviewDays,
                    value: '${stats!.totalDaysTracked}',
                    color: EmployeeTodayColors.primaryPurple,
                    icon: Icons.calendar_month_rounded,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  final String label;
  final String value;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
              color: color,
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: EmployeeTodayColors.mutedText,
            ),
          ),
        ],
      ),
    );
  }
}
