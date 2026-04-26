import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

/// Rounded guidance block for field hints and microcopy.
class AppTipCallout extends StatelessWidget {
  const AppTipCallout({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppBrandColors.tipsBackground,
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              AppIcons.tips_and_updates_outlined,
              size: 20,
              color: AppBrandColors.onTipsBackground.withValues(alpha: 0.92),
            ),
            const SizedBox(width: AppSpacing.small),
            Expanded(
              child: Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppBrandColors.onTipsBackground,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
