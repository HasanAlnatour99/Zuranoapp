import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../employee_today_theme.dart';
import 'employee_today_widgets.dart';

class EtSectionErrorCard extends StatelessWidget {
  const EtSectionErrorCard({super.key, required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return EtPremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            Icons.cloud_off_outlined,
            size: 36,
            color: EmployeeTodayColors.mutedText.withValues(alpha: 0.85),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.employeeTodaySectionLoadFailed,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: EmployeeTodayColors.deepText,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.tonal(
            onPressed: onRetry,
            style: FilledButton.styleFrom(
              foregroundColor: EmployeeTodayColors.primaryPurple,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text(l10n.employeeTodayTryAgain),
          ),
        ],
      ),
    );
  }
}
