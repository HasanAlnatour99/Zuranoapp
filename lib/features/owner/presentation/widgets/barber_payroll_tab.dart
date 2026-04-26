import 'package:flutter/material.dart';

import '../../../../core/formatting/app_money_format.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_surface_card.dart';
import '../../../../l10n/app_localizations.dart';
import '../../logic/team_management_providers.dart';
import 'empty_state_action_card.dart';

class BarberPayrollTab extends StatelessWidget {
  const BarberPayrollTab({
    super.key,
    required this.data,
    required this.currencyCode,
  });

  final BarberDetailsData data;
  final String currencyCode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.large),
      children: [
        Wrap(
          spacing: AppSpacing.small,
          runSpacing: AppSpacing.small,
          children: [
            _PayrollMetricCard(
              label: l10n.teamPayrollCommissionPercentage,
              value: l10n.teamCommissionPercentValue(
                data.employee.commissionValue.toStringAsFixed(0),
              ),
            ),
            _PayrollMetricCard(
              label: l10n.teamPayrollCommissionToday,
              value: formatAppMoney(data.todayCommission, currencyCode, locale),
            ),
            _PayrollMetricCard(
              label: l10n.teamPayrollCommissionMonth,
              value: formatAppMoney(data.monthCommission, currencyCode, locale),
            ),
            _PayrollMetricCard(
              label: l10n.teamPayrollBonusesTotal,
              value: formatAppMoney(data.monthBonuses, currencyCode, locale),
            ),
            _PayrollMetricCard(
              label: l10n.teamPayrollDeductionsTotal,
              value: formatAppMoney(data.monthDeductions, currencyCode, locale),
            ),
            _PayrollMetricCard(
              label: l10n.teamPayrollEstimatedPayout,
              value: formatAppMoney(data.estimatedPayout, currencyCode, locale),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.medium),
        if (data.payrollHistory.isEmpty)
          EmptyStateActionCard(
            title: l10n.teamPayrollHistoryEmptyTitle,
            message: l10n.teamPayrollHistoryEmptySubtitle,
          )
        else
          AppSurfaceCard(
            borderRadius: AppRadius.large,
            showShadow: false,
            outlineOpacity: 0.2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.teamPayrollHistoryTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.medium),
                for (
                  var index = 0;
                  index < data.payrollHistory.length;
                  index++
                ) ...[
                  if (index > 0) const Divider(height: AppSpacing.large),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${data.payrollHistory[index].year}-${data.payrollHistory[index].month.toString().padLeft(2, '0')}',
                        ),
                      ),
                      Text(
                        formatAppMoney(
                          data.payrollHistory[index].netAmount,
                          currencyCode,
                          locale,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _PayrollMetricCard extends StatelessWidget {
  const _PayrollMetricCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return SizedBox(
      width: 168,
      child: AppSurfaceCard(
        borderRadius: AppRadius.medium,
        showShadow: false,
        outlineOpacity: 0.18,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
