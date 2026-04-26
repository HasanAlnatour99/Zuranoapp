import 'package:flutter/material.dart';

import '../../../../core/formatting/app_money_format.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/employee_sales_summary.dart';

class EmployeeCommissionCard extends StatelessWidget {
  const EmployeeCommissionCard({
    super.key,
    required this.commissionPercent,
    required this.summary,
    required this.currencyCode,
    required this.locale,
  });

  final double commissionPercent;
  final EmployeeSalesSummary summary;
  final String currencyCode;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pct = commissionPercent.clamp(0, 100);
    final rateLabel =
        '${pct == pct.roundToDouble() ? pct.round().toString() : pct.toStringAsFixed(1)}%';
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.percent_rounded, color: Colors.amber.shade800),
                      const SizedBox(width: 8),
                      Text(
                        l10n.employeeSalesCommissionRate,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Colors.grey.shade800,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    rateLabel,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                      color: Color(0xFF111827),
                    ),
                  ),
                  Text(
                    l10n.employeeSalesCommissionHint,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Container(width: 1, height: 88, color: Colors.grey.shade200),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.employeeSalesEstimatedCommission,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.grey.shade800,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formatAppMoney(
                      summary.estimatedCommission,
                      currencyCode,
                      locale,
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 20,
                      color: Color(0xFF7C3AED),
                    ),
                  ),
                  Text(
                    l10n.employeeSalesFromSales(
                      formatAppMoney(summary.totalAmount, currencyCode, locale),
                    ),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
