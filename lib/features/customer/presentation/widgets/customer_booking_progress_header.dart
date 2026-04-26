import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

class CustomerBookingProgressHeader extends StatelessWidget {
  const CustomerBookingProgressHeader({
    super.key,
    required this.stepLabel,
    required this.title,
    required this.progress,
  });

  final String stepLabel;
  final String title;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(AppRadius.large),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              stepLabel,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppBrandColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColorsLight.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.medium),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: progress.clamp(0, 1),
                minHeight: 7,
                backgroundColor: AppBrandColors.primary.withValues(alpha: 0.12),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppBrandColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
