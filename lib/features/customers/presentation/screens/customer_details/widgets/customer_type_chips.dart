import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/constants/user_roles.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../providers/session_provider.dart';
import '../../../../data/models/customer.dart';
import '../../../../domain/customer_type_resolver.dart';
import '../../../providers/customer_details_providers.dart';

class CustomerTypeChips extends ConsumerWidget {
  const CustomerTypeChips({
    super.key,
    required this.customer,
    required this.resolvedType,
    required this.l10n,
  });

  final Customer customer;
  final CustomerType resolvedType;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(sessionUserProvider).asData?.value;
    final canToggleVip =
        user != null &&
        (user.role == UserRoles.owner || user.role == UserRoles.admin);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.customerTypeSectionTitle,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 14,
            color: FinanceDashboardColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _TypeChip(
              label: l10n.customerTypeVip,
              icon: Icons.workspace_premium_rounded,
              selected: customer.isVip,
              onTap: canToggleVip
                  ? () async {
                      try {
                        await ref
                            .read(customerDetailsControllerProvider.notifier)
                            .toggleVip(
                              customerId: customer.id,
                              isVip: !customer.isVip,
                            );
                      } on Object catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text('$e')));
                        }
                      }
                    }
                  : null,
            ),
            _TypeChip(
              label: l10n.customerTypeNew,
              icon: Icons.person_add_alt_1_rounded,
              selected:
                  !customer.isVip && resolvedType == CustomerType.newCustomer,
            ),
            _TypeChip(
              label: l10n.customerTypeRegular,
              icon: Icons.star_rounded,
              selected: !customer.isVip && resolvedType == CustomerType.regular,
            ),
            _TypeChip(
              label: l10n.customerTypeInactive,
              icon: Icons.visibility_off_rounded,
              selected:
                  !customer.isVip && resolvedType == CustomerType.inactive,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          l10n.customerTypeChipsHint,
          style: const TextStyle(
            fontSize: 12,
            color: FinanceDashboardColors.textSecondary,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.label,
    required this.icon,
    required this.selected,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bg = selected
        ? const Color(0xFFF3E8FF)
        : FinanceDashboardColors.surface;
    final fg = selected
        ? FinanceDashboardColors.primaryPurple
        : FinanceDashboardColors.textSecondary;
    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: fg),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                  color: fg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
