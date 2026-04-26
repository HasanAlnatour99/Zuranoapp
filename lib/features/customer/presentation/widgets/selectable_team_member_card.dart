import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/customer_team_member_public_model.dart';

class SelectableTeamMemberCard extends StatelessWidget {
  const SelectableTeamMemberCard({
    super.key,
    required this.member,
    required this.selected,
    required this.onTap,
  });

  final CustomerTeamMemberPublicModel member;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final imageUrl = member.profileImageUrl?.trim();
    final specialtyLine = member.specialties.isEmpty
        ? member.roleLabel
        : member.specialties.join(' · ');

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.small),
      child: Material(
        color: selected
            ? AppBrandColors.primary.withValues(alpha: 0.07)
            : scheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.xlarge),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.xlarge),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: const EdgeInsets.all(AppSpacing.medium),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.xlarge),
              border: Border.all(
                color: selected
                    ? AppBrandColors.primary
                    : scheme.outlineVariant.withValues(alpha: 0.45),
                width: selected ? 1.6 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: selected ? 0.08 : 0.04),
                  blurRadius: selected ? 18 : 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppBrandColors.secondary,
                  backgroundImage: imageUrl != null && imageUrl.isNotEmpty
                      ? NetworkImage(imageUrl)
                      : null,
                  child: imageUrl == null || imageUrl.isEmpty
                      ? Icon(
                          Icons.person_rounded,
                          color: AppBrandColors.primary.withValues(alpha: 0.5),
                          size: 30,
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
                          fontWeight: FontWeight.w800,
                          color: AppColorsLight.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        specialtyLine,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColorsLight.textSecondary,
                          height: 1.3,
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
                              l10n.customerTeamSelectionRating(
                                member.ratingAverage.toStringAsFixed(1),
                                member.ratingCount,
                              ),
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: AppColorsLight.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.small),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? AppBrandColors.primary : Colors.white,
                    border: Border.all(
                      color: selected
                          ? AppBrandColors.primary
                          : AppColorsLight.border,
                    ),
                  ),
                  child: selected
                      ? const Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 19,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
