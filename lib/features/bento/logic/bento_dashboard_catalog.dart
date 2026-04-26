import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_routes.dart';
import '../../../core/theme/bento_tokens.dart';

/// Stable identifiers for owner workspace shortcuts shown on the Bento grid.
enum BentoDashboardTileKind {
  revenue,
  services,
  barbers,
  appointments,
  expenses,
}

/// Data-only description of a dashboard tile (no [BuildContext], no UI types).
class BentoDashboardTile {
  const BentoDashboardTile({
    required this.kind,
    required this.routeName,
    required this.size,
  });

  final BentoDashboardTileKind kind;

  /// [GoRouter.pushNamed] target (see [AppRouteNames]).
  final String routeName;
  final BentoCardSize size;
}

/// Owner quick links for the Bento dashboard (override in tests via [ProviderScope]).
final bentoDashboardCatalogProvider = Provider<List<BentoDashboardTile>>((ref) {
  return _kDefaultOwnerTiles;
});

const _kDefaultOwnerTiles = <BentoDashboardTile>[
  BentoDashboardTile(
    kind: BentoDashboardTileKind.revenue,
    routeName: AppRouteNames.revenue,
    size: BentoCardSize.large,
  ),
  BentoDashboardTile(
    kind: BentoDashboardTileKind.services,
    routeName: AppRouteNames.services,
    size: BentoCardSize.small,
  ),
  BentoDashboardTile(
    kind: BentoDashboardTileKind.barbers,
    routeName: AppRouteNames.team,
    size: BentoCardSize.medium,
  ),
  BentoDashboardTile(
    kind: BentoDashboardTileKind.appointments,
    routeName: AppRouteNames.bookings,
    size: BentoCardSize.medium,
  ),
  BentoDashboardTile(
    kind: BentoDashboardTileKind.expenses,
    routeName: AppRouteNames.expenses,
    size: BentoCardSize.small,
  ),
];
