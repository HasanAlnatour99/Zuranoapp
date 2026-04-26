import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

class CustomerAppFooter extends StatelessWidget {
  const CustomerAppFooter({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.large),
      child: Center(
        child: Text(
          text,
          style: theme.textTheme.labelMedium?.copyWith(
            color: scheme.onSurfaceVariant.withValues(alpha: 0.75),
          ),
        ),
      ),
    );
  }
}
