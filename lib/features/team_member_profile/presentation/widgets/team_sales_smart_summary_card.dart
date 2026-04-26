import 'package:flutter/material.dart';

import '../../data/models/team_sales_insight_model.dart';
import '../../../../l10n/app_localizations.dart';
import '../theme/team_member_profile_colors.dart';

class TeamSalesSmartSummaryCard extends StatelessWidget {
  const TeamSalesSmartSummaryCard({super.key, required this.insight});

  final TeamSalesInsightModel insight;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: TeamMemberProfileColors.card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: TeamMemberProfileColors.border),
        boxShadow: [
          BoxShadow(
            color: TeamMemberProfileColors.textPrimary.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.edit_note_rounded,
                size: 22,
                color: TeamMemberProfileColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.teamMemberSalesSmartSummaryTitle,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: TeamMemberProfileColors.textPrimary,
                ),
              ),
            ],
          ),
          if (insight.statusLabel.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              insight.statusLabel,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: TeamMemberProfileColors.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
          if (insight.shortMessage.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              insight.shortMessage,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: TeamMemberProfileColors.textSecondary,
                height: 1.35,
              ),
            ),
          ],
          if (insight.recommendation.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              insight.recommendation,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: TeamMemberProfileColors.textPrimary,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
