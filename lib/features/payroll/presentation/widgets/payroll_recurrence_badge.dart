import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../data/payroll_constants.dart';

class PayrollRecurrenceBadge extends StatelessWidget {
  const PayrollRecurrenceBadge({super.key, required this.recurrenceType});

  final String recurrenceType;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final isRecurring = recurrenceType == PayrollRecurrenceTypes.recurring;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isRecurring
            ? scheme.tertiaryContainer
            : scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          isRecurring
              ? l10n.payrollBadgeRecurring
              : l10n.payrollBadgeNonRecurring,
          style: theme.textTheme.labelMedium?.copyWith(
            color: isRecurring
                ? scheme.onTertiaryContainer
                : scheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
