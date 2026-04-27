import 'package:flutter/material.dart';

import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import 'app_surface_card.dart';
import '../../features/salon/data/models/salon.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

/// Salon row for discovery — white card, monogram, metadata, chevron.
class CustomerSalonHighlightCard extends StatelessWidget {
  const CustomerSalonHighlightCard({
    super.key,
    required this.salon,
    this.onTap,
    this.badgeLabel,
    this.metadataLine,
    this.metadataIcon = AppIcons.phone_outlined,
  });

  final Salon salon;
  final VoidCallback? onTap;
  final String? badgeLabel;
  final String? metadataLine;
  final IconData metadataIcon;

  static String _initial(String name) {
    final t = name.trim();
    if (t.isEmpty) {
      return '?';
    }
    return t.characters.first.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final category = salon.category?.trim();
    final subtitle = (category != null && category.isNotEmpty)
        ? category
        : salon.address;
    final letter = _initial(salon.name);

    final card = AppSurfaceCard(
      margin: EdgeInsets.zero,
      onTap: onTap,
      borderRadius: AppRadius.xlarge,
      color: scheme.surface,
      showBorder: true,
      outlineOpacity: 0.12,
      shadowOpacity: 0.07,
      shadowBlurRadius: 20,
      shadowYOffset: 8,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: scheme.primaryContainer.withValues(alpha: 0.65),
              border: Border.all(color: scheme.primary.withValues(alpha: 0.2)),
            ),
            alignment: Alignment.center,
            child: Text(
              letter,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: scheme.primary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.medium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        salon.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    if (badgeLabel != null && badgeLabel!.trim().isNotEmpty)
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                          start: AppSpacing.small,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.small,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: scheme.primaryContainer,
                            borderRadius: BorderRadius.circular(
                              AppRadius.large,
                            ),
                          ),
                          child: Text(
                            badgeLabel!.trim(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: scheme.onPrimaryContainer,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.small),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.35,
                  ),
                ),
                if (metadataLine != null &&
                    metadataLine!.trim().isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.small),
                  Row(
                    children: [
                      Icon(metadataIcon, size: 16, color: scheme.primary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          metadataLine!.trim(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.small),
          Icon(AppIcons.chevron_right_rounded, color: scheme.onSurfaceVariant),
        ],
      ),
    );
    if (onTap == null) {
      return card;
    }
    return Semantics(button: true, label: salon.name, child: card);
  }
}
