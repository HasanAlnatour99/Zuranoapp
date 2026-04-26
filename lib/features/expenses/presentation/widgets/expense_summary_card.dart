import 'package:flutter/material.dart';

import '../../../../core/formatting/app_money_format.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';
import '../../domain/expense_summary.dart';

class ExpenseSummaryCard extends StatelessWidget {
  const ExpenseSummaryCard({
    super.key,
    required this.summary,
    required this.currencyCode,
  });

  final ExpensesSummary summary;
  final String currencyCode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);

    final totalStr = formatAppMoney(summary.total, currencyCode, locale);
    final trend = summary.trendVsPriorPercent;
    final showTrend = trend != null && summary.expenseCount > 0;
    final topLabel = summary.topCategory ?? l10n.expensesScreenValuePending;
    final topAmountStr = summary.topCategoryAmount != null
        ? formatAppMoney(summary.topCategoryAmount!, currencyCode, locale)
        : '—';
    final topPct = summary.topCategoryPercentOfTotal;
    final topPctStr = topPct != null ? '${topPct.round()}%' : '—';

    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF7C3AED), Color(0xFF4C1D95)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7C3AED).withValues(alpha: 0.28),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          PositionedDirectional(
            end: 0,
            top: 0,
            child: Icon(
              AppIcons.receipt_long_outlined,
              size: 120,
              color: Colors.white.withValues(alpha: 0.06),
            ),
          ),
          PositionedDirectional(
            top: -4,
            end: -4,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(
                  AppIcons.insights_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.expensesScreenTotalExpensesLabel,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.85),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                totalStr,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 29,
                  letterSpacing: -0.5,
                ),
              ),
              if (showTrend) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        trend >= 0
                            ? AppIcons.trending_up_rounded
                            : AppIcons.trending_down_rounded,
                        size: 16,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l10n.expensesScreenTrendVsPrior(
                          _formatTrendPercent(trend),
                        ),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.92),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.large),
              Row(
                children: [
                  Expanded(
                    child: _SummaryMini(
                      label: l10n.expensesScreenTransactionsLabel,
                      value: l10n.expensesScreenTransactionsCount(
                        summary.expenseCount,
                      ),
                    ),
                  ),
                  _divider(),
                  Expanded(
                    child: _SummaryMini(
                      label: l10n.expensesScreenTopCategory,
                      value: summary.expenseCount == 0
                          ? l10n.expensesScreenValuePending
                          : '$topLabel\n$topAmountStr ($topPctStr)',
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String _formatTrendPercent(double value) {
  final sign = value > 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(0)}%';
}

class _SummaryMini extends StatelessWidget {
  const _SummaryMini({
    required this.label,
    required this.value,
    this.maxLines = 2,
  });

  final String label;
  final String value;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.72),
              fontSize: 10,
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 12,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _divider() => Container(
  width: 1,
  height: 36,
  margin: const EdgeInsets.symmetric(horizontal: 6),
  color: Colors.white.withValues(alpha: 0.22),
);
