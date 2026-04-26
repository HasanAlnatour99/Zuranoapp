import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/zurano_tokens.dart';
import '../../../../core/widgets/zurano/zurano_gradient_button.dart';
import '../../../../l10n/app_localizations.dart';

class CustomerEmptyState extends StatelessWidget {
  const CustomerEmptyState({
    super.key,
    required this.canCreate,
    this.onAddCustomer,
  });

  final bool canCreate;
  final VoidCallback? onAddCustomer;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 98,
            height: 98,
            decoration: BoxDecoration(
              color: ZuranoTokens.lightPurple,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(
              Icons.groups_rounded,
              color: ZuranoTokens.primary,
              size: 42,
            ),
          ),
          const SizedBox(height: 22),
          Text(
            l10n.customersEmptyTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: ZuranoTokens.textDark,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            canCreate
                ? l10n.customersEmptyMessageCanCreate
                : l10n.customersEmptyMessageNoAccess,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: FinanceDashboardColors.textSecondary,
              fontSize: 15,
              height: 1.4,
            ),
          ),
          if (canCreate && onAddCustomer != null) ...[
            const SizedBox(height: 26),
            ZuranoGradientButton(
              label: l10n.customersAddCustomerFab,
              icon: Icons.add_rounded,
              onPressed: onAddCustomer,
            ),
          ],
        ],
      ),
    );
  }
}
