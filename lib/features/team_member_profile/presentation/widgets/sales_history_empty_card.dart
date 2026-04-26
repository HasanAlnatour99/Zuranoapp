import 'package:flutter/material.dart';

import '../theme/team_member_profile_colors.dart';

class SalesHistoryEmptyCard extends StatelessWidget {
  const SalesHistoryEmptyCard({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        color: TeamMemberProfileColors.card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: TeamMemberProfileColors.border),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.history_rounded,
            size: 40,
            color: TeamMemberProfileColors.textSecondary,
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: TeamMemberProfileColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: TeamMemberProfileColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
