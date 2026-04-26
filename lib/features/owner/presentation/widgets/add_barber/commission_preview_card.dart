import 'package:flutter/material.dart';

import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';

class CommissionPreviewCard extends StatelessWidget {
  const CommissionPreviewCard({
    super.key,
    required this.title,
    required this.equationLine,
    required this.disclaimer,
    required this.sampleNote,
  });

  final String title;
  final String equationLine;
  final String disclaimer;
  final String sampleNote;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.primaryContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.12)),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.all(AppSpacing.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: scheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: AppSpacing.small),
            Text(
              equationLine,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurface,
                height: 1.35,
              ),
            ),
            const SizedBox(height: AppSpacing.small),
            Text(
              disclaimer,
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              sampleNote,
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
                fontStyle: FontStyle.italic,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
