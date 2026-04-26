import 'package:flutter/material.dart';

import '../theme/team_member_profile_colors.dart';

class SalesEmptyStateCard extends StatelessWidget {
  const SalesEmptyStateCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onAddSale,
  });

  final String title;
  final String subtitle;
  final String actionLabel;
  final VoidCallback onAddSale;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            TeamMemberProfileColors.card,
            TeamMemberProfileColors.softPurple,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: TeamMemberProfileColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: TeamMemberProfileColors.softPurple,
              borderRadius: BorderRadius.circular(32),
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              size: 48,
              color: TeamMemberProfileColors.primary,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              color: TeamMemberProfileColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: TeamMemberProfileColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: onAddSale,
            icon: const Icon(Icons.add_rounded),
            label: Text(actionLabel),
            style: FilledButton.styleFrom(
              backgroundColor: TeamMemberProfileColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
              textStyle: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
