import 'package:flutter/material.dart';

import '../../../../../../core/formatting/app_money_format.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../data/models/customer.dart';
import '../../../../domain/customer_type_resolver.dart';

class CustomerInsightsCard extends StatelessWidget {
  const CustomerInsightsCard({
    super.key,
    required this.customer,
    required this.resolvedType,
    required this.l10n,
    required this.locale,
    required this.currencyCode,
  });

  final Customer customer;
  final CustomerType resolvedType;
  final AppLocalizations l10n;
  final Locale locale;
  final String currencyCode;

  @override
  Widget build(BuildContext context) {
    final last = customer.lastVisitAt;
    final days = last == null ? null : DateTime.now().difference(last).inDays;
    final lastVisitText = last == null
        ? l10n.customerInsightNoVisits
        : l10n.customerInsightLastVisitDays(days ?? 0);

    final suggestion = switch (resolvedType) {
      CustomerType.vip => l10n.customerSuggestedActionVip,
      CustomerType.newCustomer => l10n.customerSuggestedActionNew,
      CustomerType.regular => l10n.customerSuggestedActionRegular,
      CustomerType.inactive => l10n.customerSuggestedActionInactive,
    };

    final spent = formatAppMoney(customer.totalSpent, currencyCode, locale);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F2FF),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE9D8FD)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: const Icon(
              Icons.insights_rounded,
              color: Color(0xFF8B3DFF),
              size: 26,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.customerInsightsTitle,
                  style: const TextStyle(
                    color: Color(0xFF6D28D9),
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                _InsightRow(
                  icon: Icons.event_available_rounded,
                  text: lastVisitText,
                ),
                _InsightRow(
                  icon: Icons.bar_chart_rounded,
                  text: l10n.customerInsightTotalVisitsLine(
                    customer.totalVisits,
                  ),
                ),
                _InsightRow(
                  icon: Icons.payments_rounded,
                  text: l10n.customerInsightTotalSpentLine(spent),
                ),
                _InsightRow(icon: Icons.diamond_rounded, text: suggestion),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightRow extends StatelessWidget {
  const _InsightRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF6B7280)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13.5,
                height: 1.35,
                fontWeight: FontWeight.w600,
                color: Color(0xFF374151),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
