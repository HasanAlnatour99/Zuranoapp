import 'package:flutter/material.dart';

import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import 'app_surface_card.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

/// Vertical tile for horizontal “quick services” carousel.
class CustomerQuickServiceTile extends StatelessWidget {
  const CustomerQuickServiceTile({
    super.key,
    required this.title,
    required this.priceLabel,
    required this.durationLabel,
    this.icon = AppIcons.content_cut_rounded,
    this.onTap,
  });

  final String title;
  final String priceLabel;
  final String durationLabel;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final card = AppSurfaceCard(
      margin: EdgeInsets.zero,
      onTap: onTap,
      borderRadius: AppRadius.xlarge,
      color: scheme.surface,
      showBorder: true,
      outlineOpacity: 0.12,
      shadowOpacity: 0.06,
      shadowBlurRadius: 18,
      shadowYOffset: 8,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.medium,
        vertical: AppSpacing.large,
      ),
      child: SizedBox(
        width: 150,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: AlignmentDirectional.topStart,
                  end: AlignmentDirectional.bottomEnd,
                  colors: [
                    scheme.primary.withValues(alpha: 0.14),
                    scheme.primaryContainer.withValues(alpha: 0.9),
                  ],
                ),
                borderRadius: BorderRadius.circular(AppRadius.large),
              ),
              child: Icon(icon, color: scheme.primary, size: 24),
            ),
            const SizedBox(height: AppSpacing.medium),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
                height: 1.15,
              ),
            ),
            const SizedBox(height: AppSpacing.small),
            Text(
              priceLabel,
              style: theme.textTheme.titleSmall?.copyWith(
                color: scheme.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.small),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  AppIcons.schedule_rounded,
                  size: 14,
                  color: scheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    durationLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    if (onTap == null) {
      return card;
    }
    return Semantics(button: true, label: title, child: card);
  }
}
