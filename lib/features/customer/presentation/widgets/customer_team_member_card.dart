import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../data/models/customer_team_member_public_model.dart';

class CustomerTeamMemberCard extends StatelessWidget {
  const CustomerTeamMemberCard({super.key, required this.member});

  final CustomerTeamMemberPublicModel member;

  @override
  Widget build(BuildContext context) {
    final url = member.profileImageUrl?.trim();
    final spec = member.specialties.isEmpty
        ? member.roleLabel
        : member.specialties.join(' · ');

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.medium),
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.xlarge),
        elevation: 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.xlarge),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.medium),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppBrandColors.secondary,
                  backgroundImage: url != null && url.isNotEmpty
                      ? NetworkImage(url)
                      : null,
                  child: url == null || url.isEmpty
                      ? Icon(
                          Icons.person_rounded,
                          color: AppBrandColors.primary.withValues(alpha: 0.5),
                          size: 32,
                        )
                      : null,
                ),
                const SizedBox(width: AppSpacing.medium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.displayTitle,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        spec,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColorsLight.textSecondary,
                        ),
                      ),
                      if (member.ratingCount > 0) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              size: 18,
                              color: Colors.amber.shade700,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              member.ratingAverage.toStringAsFixed(1),
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '(${member.ratingCount})',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: AppColorsLight.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
