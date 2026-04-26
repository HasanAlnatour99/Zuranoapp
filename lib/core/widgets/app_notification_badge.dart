import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';

class AppNotificationBadge extends StatelessWidget {
  const AppNotificationBadge({
    required this.count,
    required this.child,
    super.key,
  });

  final int count;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return badges.Badge(
      showBadge: count > 0,
      position: badges.BadgePosition.topEnd(top: -10, end: -8),
      badgeAnimation: const badges.BadgeAnimation.scale(),
      badgeStyle: badges.BadgeStyle(
        badgeColor: scheme.primary,
        borderSide: BorderSide(color: scheme.surfaceContainer, width: 2),
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      ),
      badgeContent: Text(
        count > 99 ? '99+' : '$count',
        style: theme.textTheme.labelSmall?.copyWith(
          color: scheme.onPrimary,
          fontWeight: FontWeight.w800,
        ),
      ),
      child: child,
    );
  }
}
