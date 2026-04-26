import 'package:flutter/material.dart';

import '../../../../../../core/formatting/app_money_format.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../l10n/app_localizations.dart';
import 'package:barber_shop_app/features/sales/data/models/sale.dart';
import '../../../../data/models/customer.dart';
import 'customer_transaction_tile.dart';

class CustomerSalesSection extends StatelessWidget {
  const CustomerSalesSection({
    super.key,
    required this.customer,
    required this.sales,
    required this.l10n,
    required this.locale,
    required this.currencyCode,
  });

  final Customer customer;
  final List<Sale> sales;
  final AppLocalizations l10n;
  final Locale locale;
  final String currencyCode;

  @override
  Widget build(BuildContext context) {
    final totalSpent = formatAppMoney(
      customer.totalSpent,
      currencyCode,
      locale,
    );
    final lastVisit = customer.lastVisitAt == null
        ? '—'
        : MaterialLocalizations.of(
            context,
          ).formatFullDate(customer.lastVisitAt!.toLocal());

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFF0ECFF)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.customerSalesSectionTitle,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
              color: FinanceDashboardColors.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.customerSalesTotalSpentSummary(totalSpent),
            style: const TextStyle(
              color: FinanceDashboardColors.textSecondary,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.customerSalesLastVisitSummary(lastVisit),
            style: const TextStyle(
              color: FinanceDashboardColors.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 14),
          if (sales.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                children: [
                  Icon(
                    Icons.receipt_long_rounded,
                    size: 40,
                    color: FinanceDashboardColors.textSecondary.withValues(
                      alpha: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.customerSalesEmptyTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.customerSalesEmptySubtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: FinanceDashboardColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            )
          else
            ...sales.map(
              (s) => CustomerTransactionTile(
                sale: s,
                l10n: l10n,
                locale: locale,
                currencyCode: currencyCode,
              ),
            ),
        ],
      ),
    );
  }
}
