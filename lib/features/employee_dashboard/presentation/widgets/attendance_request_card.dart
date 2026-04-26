import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/zurano_card.dart';
import '../../../../l10n/app_localizations.dart';

class AttendanceRequestCard extends StatelessWidget {
  const AttendanceRequestCard({
    super.key,
    required this.pendingCount,
    required this.allowRequests,
  });

  final int pendingCount;
  final bool allowRequests;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      child: ZuranoCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.edit_note_rounded,
                  color: ZuranoPremiumUiColors.primaryPurple,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l10n.employeeTodayAttendanceRequestTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: ZuranoPremiumUiColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              allowRequests
                  ? l10n.employeeTodayAttendanceRequestSubtitle
                  : l10n.employeeTodayCorrectionRequestsDisabled,
              style: TextStyle(
                color: ZuranoPremiumUiColors.textSecondary,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: allowRequests
                    ? () => context.push(AppRoutes.employeeAttendanceRequest)
                    : null,
                style: OutlinedButton.styleFrom(
                  foregroundColor: ZuranoPremiumUiColors.primaryPurple,
                  side: BorderSide(
                    color: ZuranoPremiumUiColors.primaryPurple.withValues(
                      alpha: 0.7,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(l10n.employeeTodayRequestCorrection),
              ),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: ZuranoPremiumUiColors.softPurple,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    l10n.employeeTodayPendingCount(pendingCount),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: ZuranoPremiumUiColors.primaryPurple,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  pendingCount > 0
                      ? l10n.employeeTodayAwaitingApproval
                      : l10n.employeeTodayNoOpenRequests,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: pendingCount > 0
                        ? const Color(0xFFF97316)
                        : ZuranoPremiumUiColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
