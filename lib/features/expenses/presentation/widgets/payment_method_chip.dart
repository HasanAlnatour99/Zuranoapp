import 'package:flutter/material.dart';

import '../../../../core/constants/sale_reporting.dart';
import '../../../../core/formatting/sale_payment_method_localized.dart';
import '../../../../l10n/app_localizations.dart';

class PaymentMethodChip extends StatelessWidget {
  const PaymentMethodChip({super.key, required this.method});

  final String method;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final label = localizedSalePaymentMethod(l10n, method);
    final isBank =
        method == SalePaymentMethods.digitalWallet ||
        method.toLowerCase().contains('bank');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isBank ? const Color(0xFFEFFBF4) : const Color(0xFFEDE9FE),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: isBank ? const Color(0xFF166534) : const Color(0xFF5B21B6),
        ),
      ),
    );
  }
}
