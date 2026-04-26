import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../team_member_profile/presentation/theme/team_member_profile_colors.dart';
import '../../application/team_member_attendance_providers.dart';
import '../../data/models/attendance_correction_request_model.dart';
import 'correction_review_sheet.dart';

class AttendanceCorrectionRequestsCard extends StatelessWidget {
  const AttendanceCorrectionRequestsCard({
    super.key,
    required this.requests,
    required this.salonId,
    required this.canManageAttendance,
    required this.args,
  });

  final List<AttendanceCorrectionRequestModel> requests;
  final String salonId;
  final bool canManageAttendance;
  final TeamMemberAttendanceArgs args;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pending = requests.where((r) => r.status == 'pending').toList();
    final visibleRequests = pending.isNotEmpty
        ? pending
        : requests.take(3).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.assignment_rounded,
                color: TeamMemberProfileColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.teamMemberAttendanceCorrectionsTitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: TeamMemberProfileColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (visibleRequests.isEmpty)
            _EmptyState(
              title: l10n.teamMemberAttendanceCorrectionEmptyTitle,
              subtitle: l10n.teamMemberAttendanceCorrectionEmptySubtitle,
            )
          else
            ...visibleRequests.map(
              (request) => _RequestTile(
                request: request,
                canManageAttendance: canManageAttendance,
                salonId: salonId,
                args: args,
              ),
            ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
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
    );
  }
}

class _RequestTile extends StatelessWidget {
  const _RequestTile({
    required this.request,
    required this.canManageAttendance,
    required this.salonId,
    required this.args,
  });

  final AttendanceCorrectionRequestModel request;
  final bool canManageAttendance;
  final String salonId;
  final TeamMemberAttendanceArgs args;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isPending = request.status == 'pending';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: TeamMemberProfileColors.softPurple.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.history_toggle_off_rounded,
                color: TeamMemberProfileColors.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _requestTypeLabel(context, request.requestType),
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
              _StatusChip(status: request.status),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            request.reason.isEmpty
                ? l10n.teamMemberAttendanceNoReason
                : request.reason,
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: TeamMemberProfileColors.textSecondary,
              height: 1.4,
            ),
          ),
          if (isPending && canManageAttendance) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => CorrectionReviewSheet(
                          salonId: salonId,
                          request: request,
                          intent: CorrectionReviewIntent.reject,
                          args: args,
                        ),
                      );
                    },
                    child: Text(l10n.teamMemberAttendanceReject),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: TeamMemberProfileColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      showModalBottomSheet<void>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => CorrectionReviewSheet(
                          salonId: salonId,
                          request: request,
                          intent: CorrectionReviewIntent.approve,
                          args: args,
                        ),
                      );
                    },
                    child: Text(l10n.teamMemberAttendanceApprove),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  static String _requestTypeLabel(BuildContext context, String value) {
    final l10n = AppLocalizations.of(context)!;
    return switch (value) {
      'missing_check_in' => l10n.teamMemberAttendanceRequestTypeMissingCheckIn,
      'missing_checkout' => l10n.teamMemberAttendanceRequestTypeMissingCheckout,
      'wrong_check_in' => l10n.teamMemberAttendanceRequestTypeWrongCheckIn,
      'wrong_check_out' => l10n.teamMemberAttendanceRequestTypeWrongCheckOut,
      'absence_correction' => l10n.teamMemberAttendanceRequestTypeAbsence,
      _ => l10n.teamMemberAttendanceRequestTypeGeneric,
    };
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final label = switch (status) {
      'approved' => l10n.teamMemberAttendanceStatusApproved,
      'rejected' => l10n.teamMemberAttendanceStatusRejected,
      'pending' => l10n.teamMemberAttendanceStatusPending,
      _ => status,
    };

    final color = switch (status) {
      'approved' => const Color(0xFF16A34A),
      'rejected' => const Color(0xFFDC2626),
      'pending' => const Color(0xFFF59E0B),
      _ => TeamMemberProfileColors.textSecondary,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w800,
          fontSize: 11,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Icon(
            Icons.assignment_turned_in_rounded,
            color: TeamMemberProfileColors.primary.withValues(alpha: 0.45),
            size: 42,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: TeamMemberProfileColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
