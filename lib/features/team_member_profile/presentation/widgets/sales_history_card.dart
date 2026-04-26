import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/sale_reporting.dart';
import '../../../../core/formatting/app_money_format.dart';
import '../../../sales/data/models/sale.dart';
import '../../../../l10n/app_localizations.dart';
import '../theme/team_member_profile_colors.dart';

class SalesHistoryCard extends StatelessWidget {
  const SalesHistoryCard({
    super.key,
    required this.sale,
    required this.currencyCode,
  });

  final Sale sale;
  final String currencyCode;

  static String _paymentLabel(AppLocalizations l10n, String code) {
    switch (code) {
      case SalePaymentMethods.cash:
        return l10n.paymentMethodCash;
      case SalePaymentMethods.card:
        return l10n.paymentMethodCard;
      case SalePaymentMethods.mixed:
        return l10n.paymentMethodMixed;
      case SalePaymentMethods.digitalWallet:
        return l10n.paymentMethodDigitalWallet;
      case SalePaymentMethods.other:
        return l10n.paymentMethodOther;
      default:
        return code.trim().isEmpty ? l10n.paymentMethodOther : code;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final localeTag = locale.toString();
    final timeFormat = DateFormat('dd MMM yyyy • hh:mm a', localeTag);
    final customerLabel =
        (sale.customerName != null && sale.customerName!.trim().isNotEmpty)
        ? sale.customerName!.trim()
        : l10n.teamMemberSalesWalkInCustomer;
    final servicesSummary = sale.lineItems.isEmpty
        ? (sale.serviceNames.isEmpty
              ? l10n.teamMemberSalesServiceSummaryFallback
              : sale.serviceNames.join(', '))
        : sale.lineItems.map((e) => e.serviceName).join(', ');
    final payLabel = _paymentLabel(l10n, sale.paymentMethod);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TeamMemberProfileColors.card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: TeamMemberProfileColors.border),
        boxShadow: [
          BoxShadow(
            color: TeamMemberProfileColors.textPrimary.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: TeamMemberProfileColors.softPurple,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              color: TeamMemberProfileColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customerLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: TeamMemberProfileColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  servicesSummary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: TeamMemberProfileColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  timeFormat.format(sale.soldAt.toLocal()),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: TeamMemberProfileColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatMoney(sale.total, currencyCode, locale),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: TeamMemberProfileColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: TeamMemberProfileColors.softPurple,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  payLabel.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: TeamMemberProfileColors.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
