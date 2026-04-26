import 'package:flutter/material.dart';

import '../theme/team_member_profile_colors.dart';

class SalesKpiCard extends StatelessWidget {
  const SalesKpiCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 116,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: TeamMemberProfileColors.card,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: TeamMemberProfileColors.border),
          boxShadow: [
            BoxShadow(
              color: TeamMemberProfileColors.textPrimary.withValues(
                alpha: 0.05,
              ),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: -18,
              bottom: -22,
              child: Icon(
                Icons.show_chart_rounded,
                size: 78,
                color: TeamMemberProfileColors.primary.withValues(alpha: 0.08),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: TeamMemberProfileColors.softPurple,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    color: TeamMemberProfileColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: TeamMemberProfileColors.textSecondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: TeamMemberProfileColors.textPrimary,
                              fontWeight: FontWeight.w900,
                              fontSize: 22,
                            ),
                      ),
                    ],
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
