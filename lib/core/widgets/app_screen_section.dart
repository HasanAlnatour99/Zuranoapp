import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// Section title + body with consistent vertical rhythm.
class AppScreenSection extends StatelessWidget {
  const AppScreenSection({
    required this.child,
    super.key,
    this.title,
    this.subtitle,
    this.spacingAfterTitle = AppSpacing.medium,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
  });

  final String? title;
  final String? subtitle;
  final Widget child;
  final double spacingAfterTitle;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: theme.textTheme.titleMedium?.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.small),
            Text(
              subtitle!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                height: 1.45,
              ),
            ),
          ],
          SizedBox(height: spacingAfterTitle),
        ],
        child,
      ],
    );
  }
}
