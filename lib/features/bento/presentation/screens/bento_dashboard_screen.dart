import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/bento/bento_card.dart';
import '../../../../l10n/app_localizations.dart';
import '../../logic/bento_dashboard_catalog.dart';

/// Masonry overview of key owner modules with purple Bento tiles.
class BentoDashboardScreen extends ConsumerWidget {
  const BentoDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final tiles = ref.watch(bentoDashboardCatalogProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.bentoDashboardScreenTitle)),
      body: MasonryGridView.count(
        padding: const EdgeInsetsDirectional.all(AppSpacing.large),
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.small,
        crossAxisSpacing: AppSpacing.small,
        itemCount: tiles.length,
        itemBuilder: (context, index) {
          final tile = tiles[index];
          final copy = _copyForTile(l10n, tile.kind);
          return BentoCard(
            icon: copy.icon,
            title: copy.title,
            subtitle: copy.subtitle,
            size: tile.size,
            onTap: () => _openOperation(context, tile.routeName),
          );
        },
      ),
    );
  }

  static void _openOperation(BuildContext context, String routeName) {
    context.pushNamed(routeName);
  }
}

class _BentoTileCopy {
  const _BentoTileCopy({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;
}

_BentoTileCopy _copyForTile(
  AppLocalizations l10n,
  BentoDashboardTileKind kind,
) {
  return switch (kind) {
    BentoDashboardTileKind.revenue => _BentoTileCopy(
      icon: Icons.payments_outlined,
      title: l10n.smartWorkspaceRevenueTitle,
      subtitle: l10n.salesScreenTitle,
    ),
    BentoDashboardTileKind.services => _BentoTileCopy(
      icon: Icons.design_services_outlined,
      title: l10n.ownerServicesTitle,
      subtitle: l10n.ownerServicesSubtitle,
    ),
    BentoDashboardTileKind.barbers => _BentoTileCopy(
      icon: Icons.groups_outlined,
      title: l10n.ownerTeamTitle,
      subtitle: l10n.ownerTeamSubtitle,
    ),
    BentoDashboardTileKind.appointments => _BentoTileCopy(
      icon: Icons.calendar_month_outlined,
      title: l10n.ownerBookingsListTitle,
      subtitle: l10n.ownerBookingCreate,
    ),
    BentoDashboardTileKind.expenses => _BentoTileCopy(
      icon: Icons.receipt_long_outlined,
      title: l10n.expensesScreenTitle,
      subtitle: l10n.expensesScreenSubtitle,
    ),
  };
}
