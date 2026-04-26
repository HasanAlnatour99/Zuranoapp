import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../team_member_profile/presentation/theme/team_member_profile_colors.dart';
import '../../data/models/attendance_record_model.dart';

class RecentAttendanceHistoryCard extends StatelessWidget {
  const RecentAttendanceHistoryCard({
    super.key,
    required this.records,
    required this.emptyMessage,
  });

  final List<AttendanceRecordModel> records;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeTag = Localizations.localeOf(context).toString();
    final timeFormat = DateFormat.jm(localeTag);
    final dateFormat = DateFormat.yMMMEd(localeTag);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TeamMemberProfileColors.card,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: TeamMemberProfileColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.history_rounded,
                color: TeamMemberProfileColors.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.teamMemberAttendanceHistoryTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: TeamMemberProfileColors.textPrimary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Full history route can be wired when a dedicated screen exists.
                },
                child: Text(l10n.teamMemberAttendanceViewAll),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (records.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 26),
              child: Text(
                emptyMessage,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: TeamMemberProfileColors.textSecondary,
                ),
              ),
            )
          else
            ...records.map(
              (record) => _AttendanceHistoryTile(
                record: record,
                dateFormat: dateFormat,
                timeFormat: timeFormat,
              ),
            ),
        ],
      ),
    );
  }
}

class _AttendanceHistoryTile extends StatelessWidget {
  const _AttendanceHistoryTile({
    required this.record,
    required this.dateFormat,
    required this.timeFormat,
  });

  final AttendanceRecordModel record;
  final DateFormat dateFormat;
  final DateFormat timeFormat;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final parsed = DateTime.tryParse(record.attendanceDate);
    final dateLabel = parsed != null
        ? dateFormat.format(parsed.toLocal())
        : record.attendanceDate;

    final statusLabel = _statusLabel(l10n, record.status);
    final statusColor = _statusColor(record.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: TeamMemberProfileColors.softPurple.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today_rounded,
            color: TeamMemberProfileColors.primary,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              dateLabel,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          Flexible(
            child: Text(
              '${_formatTime(record.checkInAt, timeFormat)} · ${_formatTime(record.checkOutAt, timeFormat)}',
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: TeamMemberProfileColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              statusLabel,
              style: TextStyle(
                color: statusColor,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _formatTime(DateTime? value, DateFormat timeFormat) {
    if (value == null) return '--:--';
    return timeFormat.format(value.toLocal());
  }

  static String _statusLabel(AppLocalizations l10n, String status) {
    return switch (status) {
      'present' => l10n.teamMemberAttendanceRecordStatusPresent,
      'late' => l10n.teamMemberAttendanceRecordStatusLate,
      'incomplete' => l10n.teamMemberAttendanceRecordStatusIncomplete,
      'manual' => l10n.teamMemberAttendanceRecordStatusManual,
      'absent' => l10n.teamMemberAttendanceRecordStatusAbsent,
      _ => status,
    };
  }

  static Color _statusColor(String status) {
    return switch (status) {
      'present' => const Color(0xFF16A34A),
      'late' => const Color(0xFFF97316),
      'incomplete' => const Color(0xFFF59E0B),
      'manual' => TeamMemberProfileColors.primary,
      'absent' => const Color(0xFFDC2626),
      _ => TeamMemberProfileColors.textSecondary,
    };
  }
}
