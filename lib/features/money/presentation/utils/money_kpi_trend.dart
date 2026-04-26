import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

enum MoneyKpiTrendKind { sales, expenses, payroll, netProfit }

class MoneyKpiTrendLine {
  const MoneyKpiTrendLine(this.label, this.color);

  final String label;
  final Color color;
}

MoneyKpiTrendLine buildMoneyKpiTrendLine({
  required MoneyKpiTrendKind kind,
  required double current,
  required double previous,
  required String previousMonthAbbrev,
  required AppLocalizations l10n,
}) {
  const eps = 0.0001;
  if (current.abs() < eps && previous.abs() < eps) {
    return MoneyKpiTrendLine(
      l10n.moneyDashboardKpiTrendNoData,
      FinanceDashboardColors.textSecondary,
    );
  }
  if (previous.abs() < eps && current > eps) {
    final cost =
        kind == MoneyKpiTrendKind.expenses || kind == MoneyKpiTrendKind.payroll;
    return MoneyKpiTrendLine(
      l10n.moneyDashboardKpiTrendNew,
      cost
          ? FinanceDashboardColors.expensePink
          : FinanceDashboardColors.greenProfit,
    );
  }
  if (previous.abs() < eps && current < -eps) {
    return MoneyKpiTrendLine(
      l10n.moneyDashboardKpiTrendNew,
      FinanceDashboardColors.textSecondary,
    );
  }

  final delta = current - previous;
  final absPct = (delta / previous * 100).abs();
  final pctLabel = _formatPercent(absPct);

  String label;
  if (delta > eps) {
    label = l10n.moneyDashboardKpiTrendUpVsMonth(pctLabel, previousMonthAbbrev);
  } else if (delta < -eps) {
    label = l10n.moneyDashboardKpiTrendDownVsMonth(
      pctLabel,
      previousMonthAbbrev,
    );
  } else {
    label = l10n.moneyDashboardKpiTrendFlatVsMonth('0', previousMonthAbbrev);
  }

  final color = _trendColor(kind: kind, delta: delta);
  return MoneyKpiTrendLine(label, color);
}

Color _trendColor({required MoneyKpiTrendKind kind, required double delta}) {
  const eps = 0.0001;
  switch (kind) {
    case MoneyKpiTrendKind.sales:
    case MoneyKpiTrendKind.netProfit:
      if (delta > eps) return FinanceDashboardColors.greenProfit;
      if (delta < -eps) return FinanceDashboardColors.expensePink;
      return FinanceDashboardColors.textSecondary;
    case MoneyKpiTrendKind.expenses:
    case MoneyKpiTrendKind.payroll:
      if (delta > eps) return FinanceDashboardColors.expensePink;
      if (delta < -eps) return FinanceDashboardColors.greenProfit;
      return FinanceDashboardColors.textSecondary;
  }
}

String _formatPercent(double value) {
  if (!value.isFinite) return '0';
  if (value >= 100) return value.round().toString();
  if (value >= 10) return value.round().toString();
  if (value < 0.1 && value > 0) return value.toStringAsFixed(1);
  return value.toStringAsFixed(value == value.roundToDouble() ? 0 : 1);
}
