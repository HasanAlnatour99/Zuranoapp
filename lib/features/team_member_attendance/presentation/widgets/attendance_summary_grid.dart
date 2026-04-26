import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../data/models/attendance_summary_model.dart';
import 'attendance_summary_tile.dart';

class AttendanceSummaryGrid extends StatelessWidget {
  const AttendanceSummaryGrid({super.key, required this.summary});

  final AttendanceSummaryModel summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.55,
      children: [
        AttendanceSummaryTile(
          title: l10n.teamMemberAttendanceSummaryWeek,
          value: '${summary.weeklyPresentDays}',
          subtitle: l10n.teamMemberAttendanceSummaryDaysUnit,
          icon: Icons.calendar_month_rounded,
        ),
        AttendanceSummaryTile(
          title: l10n.teamMemberAttendanceSummaryLateMonth,
          value: '${summary.monthlyLateCount}',
          subtitle: l10n.teamMemberAttendanceSummaryLateMonthHint,
          icon: Icons.schedule_rounded,
        ),
        AttendanceSummaryTile(
          title: l10n.teamMemberAttendanceSummaryMissingCheckout,
          value: '${summary.monthlyMissingCheckoutCount}',
          subtitle: l10n.teamMemberAttendanceSummaryMissingCheckoutHint,
          icon: Icons.logout_rounded,
        ),
        AttendanceSummaryTile(
          title: l10n.teamMemberAttendanceSummaryPendingRequests,
          value: '${summary.pendingCorrectionRequests}',
          subtitle: l10n.teamMemberAttendanceSummaryPendingRequestsHint,
          icon: Icons.pending_actions_rounded,
        ),
      ],
    );
  }
}
