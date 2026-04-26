import 'package:flutter/material.dart';

import '../../../../core/formatting/app_money_format.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_surface_card.dart';

class PayrollSummaryCard extends StatelessWidget {
  const PayrollSummaryCard({
    super.key,
    required this.label,
    required this.value,
    this.currencyCode,
  });

  final String label;
  final double value;
  final String? currencyCode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final locale = Localizations.localeOf(context);

    final displayValue = currencyCode == null
        ? value.toStringAsFixed(0)
        : formatAppMoney(value, currencyCode!, locale);

    return AppSurfaceCard(
      borderRadius: AppRadius.large,
      showShadow: false,
      outlineOpacity: 0.18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.small),
          Text(
            displayValue,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
