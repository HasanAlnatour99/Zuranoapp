import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../team_member_profile/presentation/theme/team_member_profile_colors.dart';
import '../../application/team_member_attendance_providers.dart';
import '../../data/models/attendance_record_model.dart';
import 'manual_attendance_edit_sheet.dart';

class AttendanceTodayAdminCard extends StatelessWidget {
  const AttendanceTodayAdminCard({
    super.key,
    required this.employeeName,
    required this.record,
    required this.canManageAttendance,
    required this.salonId,
    required this.employeeId,
    required this.args,
  });

  final String employeeName;
  final AttendanceRecordModel? record;
  final bool canManageAttendance;
  final String salonId;
  final String employeeId;
  final TeamMemberAttendanceArgs args;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeTag = Localizations.localeOf(context).toString();
    final timeFormat = DateFormat.jm(localeTag);

    final hasRecord = record != null;
    final isOpen = record?.checkInAt != null && record?.checkOutAt == null;

    final title = !hasRecord
        ? l10n.teamMemberAttendanceAdminNoRecordTitle
        : isOpen
        ? l10n.teamMemberAttendanceAdminCheckedInTitle
        : l10n.teamMemberAttendanceAdminCompletedTitle;

    final subtitle = !hasRecord
        ? l10n.teamMemberAttendanceAdminNoRecordSubtitle(employeeName)
        : isOpen
        ? l10n.teamMemberAttendanceAdminCheckedInSubtitle
        : l10n.teamMemberAttendanceAdminCompletedSubtitle;

    final statusColor = !hasRecord
        ? TeamMemberProfileColors.textSecondary
        : isOpen
        ? const Color(0xFF16A34A)
        : TeamMemberProfileColors.primary;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: TeamMemberProfileColors.card,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: TeamMemberProfileColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: TeamMemberProfileColors.softPurple,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  hasRecord
                      ? Icons.fact_check_rounded
                      : Icons.event_busy_rounded,
                  color: TeamMemberProfileColors.primary,
                  size: 30,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: TeamMemberProfileColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        height: 1.5,
                        color: TeamMemberProfileColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  hasRecord
                      ? _statusLabel(context, record!.status)
                      : l10n.teamMemberAttendanceStatusNone,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _TimeBox(
                  label: l10n.teamMemberAttendanceCheckInLabel,
                  value: record?.checkInAt == null
                      ? '--:--'
                      : timeFormat.format(record!.checkInAt!.toLocal()),
                  icon: Icons.login_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _TimeBox(
                  label: l10n.teamMemberAttendanceCheckOutLabel,
                  value: record?.checkOutAt == null
                      ? '--:--'
                      : timeFormat.format(record!.checkOutAt!.toLocal()),
                  icon: Icons.logout_rounded,
                ),
              ),
            ],
          ),
          if (canManageAttendance) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: TeamMemberProfileColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => ManualAttendanceEditSheet(
                      salonId: salonId,
                      employeeId: employeeId,
                      employeeName: employeeName,
                      record: record,
                      args: args,
                    ),
                  );
                },
                icon: Icon(hasRecord ? Icons.edit_rounded : Icons.add_rounded),
                label: Text(
                  hasRecord
                      ? l10n.teamMemberAttendanceEditManual
                      : l10n.teamMemberAttendanceAddManual,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _statusLabel(BuildContext context, String status) {
    final l10n = AppLocalizations.of(context)!;
    return switch (status) {
      'present' => l10n.teamMemberAttendanceRecordStatusPresent,
      'late' => l10n.teamMemberAttendanceRecordStatusLate,
      'incomplete' => l10n.teamMemberAttendanceRecordStatusIncomplete,
      'manual' => l10n.teamMemberAttendanceRecordStatusManual,
      'absent' => l10n.teamMemberAttendanceRecordStatusAbsent,
      'dayOff' => status,
      _ => status,
    };
  }
}

class _TimeBox extends StatelessWidget {
  const _TimeBox({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: TeamMemberProfileColors.softPurple.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: TeamMemberProfileColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: TeamMemberProfileColors.primary, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: TeamMemberProfileColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: TeamMemberProfileColors.textPrimary,
                    fontWeight: FontWeight.w900,
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
