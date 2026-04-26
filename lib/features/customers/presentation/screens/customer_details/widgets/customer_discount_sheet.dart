import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../data/models/customer.dart';
import '../../../providers/customer_details_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> showEditCustomerDiscountSheet({
  required BuildContext context,
  required WidgetRef ref,
  required Customer customer,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final controller = TextEditingController(
    text:
        customer.discountPercentage ==
            customer.discountPercentage.roundToDouble()
        ? customer.discountPercentage.toStringAsFixed(0)
        : customer.discountPercentage.toStringAsFixed(1),
  );
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(ctx).bottom),
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.customerDiscountEditSheetTitle,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 17,
                  color: FinanceDashboardColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                ],
                decoration: InputDecoration(
                  labelText: l10n.customerDiscountPercentLabel,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: () async {
                  final v =
                      double.tryParse(controller.text.replaceAll(',', '.')) ??
                      -1;
                  if (v < 0 || v > 100) {
                    ScaffoldMessenger.of(ctx).showSnackBar(
                      SnackBar(content: Text(l10n.customerDiscountInvalid)),
                    );
                    return;
                  }
                  try {
                    await ref
                        .read(customerDetailsControllerProvider.notifier)
                        .updateDiscount(
                          customerId: customer.id,
                          discountPercentage: v,
                        );
                    if (ctx.mounted) Navigator.of(ctx).pop();
                  } on Object catch (e) {
                    if (ctx.mounted) {
                      ScaffoldMessenger.of(
                        ctx,
                      ).showSnackBar(SnackBar(content: Text('$e')));
                    }
                  }
                },
                style: FilledButton.styleFrom(
                  backgroundColor: FinanceDashboardColors.primaryPurple,
                  minimumSize: const Size.fromHeight(48),
                ),
                child: Text(l10n.addCustomerSaveCustomer),
              ),
            ],
          ),
        ),
      );
    },
  );
}
