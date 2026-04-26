import 'package:flutter/material.dart';

import '../../../../core/formatting/app_money_format.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/employee_sales_summary.dart';

class EmployeeSalesKpiGrid extends StatelessWidget {
  const EmployeeSalesKpiGrid({
    super.key,
    required this.summary,
    required this.currencyCode,
    required this.locale,
  });

  final EmployeeSalesSummary summary;
  final String currencyCode;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Row(
        children: [
          Expanded(
            child: _KpiTile(
              icon: Icons.account_balance_wallet_rounded,
              iconBg: const Color(0xFFD1FAE5),
              iconColor: const Color(0xFF059669),
              label: l10n.employeeSalesKpiTotal,
              value: formatAppMoney(summary.totalAmount, currencyCode, locale),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _KpiTile(
              icon: Icons.content_cut_rounded,
              iconBg: const Color(0xFFDBEAFE),
              iconColor: const Color(0xFF2563EB),
              label: l10n.employeeSalesKpiServices,
              value: summary.servicesCount.toString(),
            ),
          ),
        ],
      ),
    );
  }
}

class EmployeeSalesKpiGridRow2 extends StatelessWidget {
  const EmployeeSalesKpiGridRow2({
    super.key,
    required this.summary,
    required this.currencyCode,
    required this.locale,
  });

  final EmployeeSalesSummary summary;
  final String currencyCode;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Row(
        children: [
          Expanded(
            child: _KpiTile(
              icon: Icons.paid_rounded,
              iconBg: const Color(0xFFFEF3C7),
              iconColor: const Color(0xFFD97706),
              label: l10n.employeeSalesKpiCommission,
              value: formatAppMoney(
                summary.estimatedCommission,
                currencyCode,
                locale,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _KpiTile(
              icon: Icons.pie_chart_outline_rounded,
              iconBg: const Color(0xFFF4ECFF),
              iconColor: const Color(0xFF7C3AED),
              label: l10n.employeeSalesKpiAvgService,
              value: formatAppMoney(
                summary.averageServiceValue,
                currencyCode,
                locale,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _KpiTile extends StatelessWidget {
  const _KpiTile({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 15,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11.5,
              height: 1.25,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
