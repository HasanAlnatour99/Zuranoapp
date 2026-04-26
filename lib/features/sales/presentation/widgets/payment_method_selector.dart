import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/payment_method.dart';

class PaymentMethodSelector extends StatelessWidget {
  const PaymentMethodSelector({
    super.key,
    required this.selected,
    required this.onChanged,
    required this.l10n,
    this.allowedMethods,
  });

  final PosPaymentMethod selected;
  final ValueChanged<PosPaymentMethod> onChanged;
  final AppLocalizations l10n;

  /// When non-null, only these methods are shown and tappable.
  final Set<PosPaymentMethod>? allowedMethods;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: FinanceDashboardColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.035),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.addSalePaymentMethodField,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: FinanceDashboardColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                for (final method in _orderedMethods()) ...[
                  Expanded(
                    child: _PaymentMethodTile(
                      label: _label(method, l10n),
                      icon: method.icon,
                      selected: selected == method,
                      enabled:
                          allowedMethods == null ||
                          allowedMethods!.contains(method),
                      onTap: () => onChanged(method),
                    ),
                  ),
                  if (method != _orderedMethods().last)
                    const SizedBox(width: 10),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<PosPaymentMethod> _orderedMethods() {
    const all = PosPaymentMethod.values;
    if (allowedMethods == null || allowedMethods!.isEmpty) {
      return all.toList(growable: false);
    }
    return all.where(allowedMethods!.contains).toList(growable: false);
  }

  String _label(PosPaymentMethod m, AppLocalizations l10n) {
    return switch (m) {
      PosPaymentMethod.cash => l10n.paymentMethodCash,
      PosPaymentMethod.card => l10n.paymentMethodCard,
      PosPaymentMethod.mixed => l10n.paymentMethodMixed,
    };
  }
}

class _PaymentMethodTile extends StatelessWidget {
  const _PaymentMethodTile({
    required this.label,
    required this.icon,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? FinanceDashboardColors.primaryPurple.withValues(alpha: 0.08)
          : Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: !enabled
                  ? FinanceDashboardColors.border.withValues(alpha: 0.5)
                  : selected
                  ? FinanceDashboardColors.primaryPurple
                  : FinanceDashboardColors.border,
              width: selected ? 1.6 : 1,
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: selected
                      ? FinanceDashboardColors.primaryPurple
                      : FinanceDashboardColors.lightPurple.withValues(
                          alpha: 0.52,
                        ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: selected
                      ? Colors.white
                      : FinanceDashboardColors.primaryPurple,
                  size: 19,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        color: selected
                            ? FinanceDashboardColors.deepPurple
                            : FinanceDashboardColors.textPrimary,
                      ),
                    ),
                  ),
                  if (selected) ...[
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.check_circle_rounded,
                      size: 15,
                      color: FinanceDashboardColors.primaryPurple,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
