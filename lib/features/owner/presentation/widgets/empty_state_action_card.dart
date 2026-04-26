import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/ui/app_illustrations.dart';
import '../../../../core/widgets/app_illustration.dart';
import '../../../../core/widgets/app_surface_card.dart';

/// Compact empty state with optional primary action (owner dashboard KPIs).
class EmptyStateActionCard extends StatelessWidget {
  const EmptyStateActionCard({
    super.key,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.illustrationAsset = AppIllustrations.emptyOwnerDashboard,
  });

  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final String? illustrationAsset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final showAction = (actionLabel ?? '').isNotEmpty && onAction != null;

    return AppSurfaceCard(
      borderRadius: AppRadius.medium,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.small,
        vertical: AppSpacing.small,
      ),
      showShadow: false,
      outlineOpacity: 0.22,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if ((illustrationAsset ?? '').isNotEmpty) ...[
            AppIllustration(
              assetName: illustrationAsset!,
              size: AppIllustrationSize.small,
              semanticLabel: title,
              maxWidth: 180,
              maxHeight: 120,
            ),
            const SizedBox(height: AppSpacing.small),
          ],
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelMedium?.copyWith(
              color: scheme.onSurfaceVariant.withValues(alpha: 0.95),
              fontWeight: FontWeight.w600,
              height: 1.25,
            ),
          ),
          if ((message ?? '').isNotEmpty) ...[
            const SizedBox(height: AppSpacing.small / 2),
            Text(
              message!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant.withValues(alpha: 0.85),
                height: 1.2,
              ),
            ),
          ],
          if (showAction) ...[
            const SizedBox(height: AppSpacing.small),
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                foregroundColor: scheme.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.small,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                actionLabel!,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
