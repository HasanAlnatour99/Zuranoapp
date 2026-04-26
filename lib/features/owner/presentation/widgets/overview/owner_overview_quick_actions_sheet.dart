import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_routes.dart';
import '../../../../../core/constants/user_roles.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../../providers/owner_dashboard_module_provider.dart';
import '../../../../users/data/models/app_user.dart';
import '../owner_workspace_modules.dart';
import 'overview_design_tokens.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

/// Bottom sheet: service, barber, booking, expense, sale.
Future<void> showOwnerOverviewQuickActionSheet({
  required BuildContext context,
  required WidgetRef ref,
  required AppUser user,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final scheme = Theme.of(context).colorScheme;
  final nav = Navigator.of(context);
  final router = GoRouter.of(context);
  final canManageTeam =
      user.role == UserRoles.owner || user.role == UserRoles.admin;
  final salonId = user.salonId?.trim() ?? '';

  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    backgroundColor: scheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.ownerOverviewFabSheetTitle,
                style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: OwnerOverviewTokens.textPrimary,
                ),
              ),
              const Gap(12),
              _SheetTile(
                icon: AppIcons.design_services_outlined,
                label: l10n.ownerOverviewSmartAddService,
                onTap: () {
                  nav.pop();
                  Future.microtask(() => router.push(AppRoutes.ownerServices));
                },
              ),
              if (canManageTeam)
                _SheetTile(
                  icon: AppIcons.person_add_alt_outlined,
                  label: l10n.ownerOverviewSmartAddBarber,
                  onTap: () {
                    nav.pop();
                    Future.microtask(() {
                      if (!context.mounted) return;
                      if (salonId.isEmpty) {
                        router.go(AppRoutes.ownerTeam);
                        return;
                      }
                      showOwnerTeamMemberSheet(context, salonId: salonId);
                    });
                  },
                ),
              _SheetTile(
                icon: AppIcons.event_available_outlined,
                label: l10n.ownerOverviewSmartCreateBooking,
                onTap: () {
                  nav.pop();
                  Future.microtask(() => router.push(AppRoutes.bookingsNew));
                },
              ),
              _SheetTile(
                icon: AppIcons.receipt_long_outlined,
                label: l10n.ownerOverviewQuickAddExpense,
                onTap: () {
                  nav.pop();
                  ref
                      .read(ownerDashboardModuleIndexProvider.notifier)
                      .setIndex(3);
                },
              ),
              _SheetTile(
                icon: AppIcons.point_of_sale_outlined,
                label: l10n.ownerOverviewQuickAddSale,
                onTap: () {
                  nav.pop();
                  Future.microtask(() => router.push(AppRoutes.ownerSalesAdd));
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _SheetTile extends StatelessWidget {
  const _SheetTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: OwnerOverviewTokens.purple),
      title: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
      trailing: Icon(
        AppIcons.chevron_right_rounded,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      onTap: onTap,
    );
  }
}
