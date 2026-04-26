import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/payment_method.dart';
import '../providers/add_sale_controller.dart';

class AddSalePaymentSplitFields extends ConsumerStatefulWidget {
  const AddSalePaymentSplitFields({super.key});

  @override
  ConsumerState<AddSalePaymentSplitFields> createState() =>
      _AddSalePaymentSplitFieldsState();
}

class _AddSalePaymentSplitFieldsState
    extends ConsumerState<AddSalePaymentSplitFields> {
  late final TextEditingController _cashCtrl;
  late final TextEditingController _cardCtrl;

  @override
  void initState() {
    super.initState();
    final s = ref.read(addSaleControllerProvider);
    _cashCtrl = TextEditingController(text: _fmt(s.splitCashAmount));
    _cardCtrl = TextEditingController(text: _fmt(s.splitCardAmount));
  }

  @override
  void dispose() {
    _cashCtrl.dispose();
    _cardCtrl.dispose();
    super.dispose();
  }

  String _fmt(double v) {
    if (v == 0) return '';
    if (v == v.roundToDouble()) return v.round().toString();
    return v.toString();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(addSaleControllerProvider);
    final notifier = ref.read(addSaleControllerProvider.notifier);

    ref.listen<AddSaleState>(addSaleControllerProvider, (previous, next) {
      if (previous?.paymentMethod != next.paymentMethod ||
          (previous?.totalAmount != next.totalAmount &&
              next.paymentMethod == PosPaymentMethod.mixed)) {
        _cashCtrl.text = _fmt(next.splitCashAmount);
        _cardCtrl.text = _fmt(next.splitCardAmount);
      }
    });

    if (state.paymentMethod != PosPaymentMethod.mixed) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: FinanceDashboardColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.addSaleCashCardSplitTitle,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 14,
                color: FinanceDashboardColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cashCtrl,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                    ],
                    decoration: InputDecoration(
                      labelText: l10n.addSaleCashAmountHint,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onChanged: (raw) {
                      final v = double.tryParse(raw.replaceAll(',', '.')) ?? 0;
                      notifier.setSplitCashAmount(v);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _cardCtrl,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                    ],
                    decoration: InputDecoration(
                      labelText: l10n.addSaleCardAmountHint,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onChanged: (raw) {
                      final v = double.tryParse(raw.replaceAll(',', '.')) ?? 0;
                      notifier.setSplitCardAmount(v);
                    },
                  ),
                ),
              ],
            ),
            if (!state.paymentStructureValid(state.totalAmount)) ...[
              const SizedBox(height: 8),
              Text(
                l10n.addSalePaymentSplitInvalid,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
