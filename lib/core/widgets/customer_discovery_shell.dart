import 'package:flutter/material.dart';

import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';

/// Local [Theme] overrides for customer discovery (chips, density) without
/// changing app-wide [ThemeData].
class CustomerDiscoveryShell extends StatelessWidget {
  const CustomerDiscoveryShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Theme(
      data: theme.copyWith(
        chipTheme: ChipThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.large),
            side: BorderSide(color: scheme.outline.withValues(alpha: 0.22)),
          ),
          showCheckmark: false,
          labelPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.small,
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.small),
          side: BorderSide(color: scheme.outline.withValues(alpha: 0.2)),
          backgroundColor: scheme.surface.withValues(alpha: 0.92),
          selectedColor: scheme.primaryContainer,
          disabledColor: scheme.surfaceContainerHighest,
          labelStyle: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          secondaryLabelStyle: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      child: child,
    );
  }
}
