import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

class ExpensesErrorView extends StatelessWidget {
  const ExpensesErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.large),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  AppIcons.error_outline_rounded,
                  size: 40,
                  color: theme.colorScheme.error,
                ),
                const SizedBox(height: AppSpacing.medium),
                Text(
                  l10n.expensesScreenErrorTitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColorsLight.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.small),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColorsLight.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.large),
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded, size: 20),
                  label: Text(l10n.expensesScreenRetry),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
