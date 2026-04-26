import 'package:flutter/material.dart';
import '../../../../core/theme/auth_premium_tokens.dart';

/// Wraps children in a premium auth theme override.
/// Keeps auth surfaces in light mode to match app-wide appearance.
class AuthShell extends StatelessWidget {
  const AuthShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Keep auth shell in light mode while retaining premium accents.
    final authTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: AuthPremiumColors.accent,
        onPrimary: theme.colorScheme.onPrimary,
        primaryContainer: AuthPremiumColors.accent.withValues(alpha: 0.2),
        onPrimaryContainer: theme.colorScheme.onPrimaryContainer,
        secondary: AuthPremiumColors.accentSecondary,
        onSecondary: theme.colorScheme.onSecondary,
        secondaryContainer: AuthPremiumColors.accentSecondary.withValues(
          alpha: 0.15,
        ),
        onSecondaryContainer: theme.colorScheme.onSecondaryContainer,
        surface: theme.colorScheme.surface,
        onSurface: theme.colorScheme.onSurface,
        onSurfaceVariant: theme.colorScheme.onSurfaceVariant,
        surfaceContainer: theme.colorScheme.surfaceContainer,
        surfaceContainerHigh: theme.colorScheme.surfaceContainerHigh,
        surfaceContainerHighest: theme.colorScheme.surfaceContainerHighest,
        outline: theme.colorScheme.outline,
        outlineVariant: theme.colorScheme.outlineVariant,
        error: AuthPremiumColors.error,
      ),
      scaffoldBackgroundColor: Colors.white,
      dividerColor: theme.colorScheme.outlineVariant,
      textTheme: theme.textTheme,
      appBarTheme: theme.appBarTheme.copyWith(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
    );

    return Theme(data: authTheme, child: child);
  }
}
