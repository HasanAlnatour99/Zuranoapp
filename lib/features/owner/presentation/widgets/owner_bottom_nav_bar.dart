import 'package:flutter/material.dart';

import '../../../../core/ui/app_icons.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/zurano_center_fab.dart';

/// Owner shell bottom navigation with a center [+] that is part of this bar
/// (not [Scaffold.floatingActionButton]) so it does not move when the keyboard
/// opens while `resizeToAvoidBottomInset` keeps the body/search layout correct.
class OwnerBottomNavBar extends StatelessWidget {
  const OwnerBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.onCenterAddTap,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final VoidCallback onCenterAddTap;

  static const double _fabHalf = ZuranoCenterFab.fabSize / 2;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final bottomPad = MediaQuery.paddingOf(context).bottom;

    const double kRowVerticalPadding = 10;
    const double kRowMinHeight = 56;
    final double barTotalHeight = kRowMinHeight + kRowVerticalPadding * 2 + bottomPad;
    final double stackHeight = barTotalHeight + _fabHalf;

    Widget tab({
      required int branchIndex,
      required IconData icon,
      required IconData selectedIcon,
      required String label,
    }) {
      return Expanded(
        child: _OwnerBottomNavItem(
          icon: icon,
          selectedIcon: selectedIcon,
          label: label,
          selected: selectedIndex == branchIndex,
          onTap: () => onDestinationSelected(branchIndex),
        ),
      );
    }

    final finance = tab(
      branchIndex: 0,
      icon: AppIcons.account_balance_wallet_outlined,
      selectedIcon: AppIcons.account_balance_wallet,
      label: l10n.ownerTabFinance,
    );
    final customers = tab(
      branchIndex: 1,
      icon: AppIcons.groups_2_outlined,
      selectedIcon: AppIcons.groups,
      label: l10n.ownerTabCustomers,
    );
    final team = tab(
      branchIndex: 2,
      icon: AppIcons.groups_outlined,
      selectedIcon: AppIcons.groups,
      label: l10n.ownerTabTeam,
    );
    final overview = tab(
      branchIndex: 3,
      icon: AppIcons.dashboard_outlined,
      selectedIcon: AppIcons.dashboard,
      label: l10n.ownerTabOverview,
    );

    const centerGap = SizedBox(width: 72);

    // Single visual order: overview at layout "start" (left in LTR, right in
    // RTL). [Row] follows ambient [Directionality]; do not mirror manually.
    final rowChildren = <Widget>[
      overview,
      team,
      centerGap,
      customers,
      finance,
    ];

    return SizedBox(
      height: stackHeight,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: barTotalHeight,
            child: Material(
              color: scheme.surfaceContainer,
              surfaceTintColor: scheme.surfaceContainer,
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  8,
                  kRowVerticalPadding,
                  8,
                  kRowVerticalPadding + bottomPad,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: rowChildren,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: barTotalHeight - _fabHalf,
            child: Center(
              child: Tooltip(
                message: l10n.ownerOverviewFabSheetTitle,
                child: Hero(
                  tag: 'owner_shell_center_fab',
                  child: ZuranoCenterFab(onPressed: onCenterAddTap),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OwnerBottomNavItem extends StatelessWidget {
  const _OwnerBottomNavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final primary = scheme.primary;
    final muted = scheme.onSurfaceVariant;
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
        decoration: BoxDecoration(
          color: selected
              ? primary.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxHeight < 46;
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  selected ? selectedIcon : icon,
                  color: selected ? primary : muted,
                  size: 20,
                ),
                if (!compact) ...[
                  const SizedBox(height: 2),
                  Flexible(
                    child: FittedBox(
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: selected ? primary : muted,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
