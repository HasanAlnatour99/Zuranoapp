import 'package:flutter/material.dart';

import '../../../../core/formatting/app_money_format.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/payroll_result_model.dart';

class PayrollResultLineTile extends StatelessWidget {
  const PayrollResultLineTile({
    super.key,
    required this.result,
    required this.currencyCode,
    this.showMeta = true,
  });

  final PayrollResultModel result;
  final String currencyCode;
  final bool showMeta;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final locale = Localizations.localeOf(context);
    final l10n = AppLocalizations.of(context)!;

    final meta = <String>[
      if (showMeta && result.quantity != null)
        l10n.payrollLineQuantity(result.quantity!.toStringAsFixed(0)),
      if (showMeta && result.rate != null)
        l10n.payrollLineRate(result.rate!.toStringAsFixed(2)),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.small / 1.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.elementName,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (meta.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    meta.join(' • '),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.medium),
          Text(
            formatAppMoney(result.amount, currencyCode, locale),
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
