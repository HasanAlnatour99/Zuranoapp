import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

/// Friendly replacement for raw Firestore permission errors.
class CustomerPermissionError extends StatelessWidget {
  const CustomerPermissionError({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: FinanceDashboardColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColorsLight.error.withValues(alpha: 0.15),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.lock_outline_rounded,
                color: AppColorsLight.error.withValues(alpha: 0.9),
                size: 42,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.customersPermissionErrorTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: FinanceDashboardColors.textPrimary,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.customersPermissionErrorSubtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: FinanceDashboardColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
