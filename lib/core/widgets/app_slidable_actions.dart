import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../theme/app_radius.dart';

class AppSwipeAction {
  const AppSwipeAction({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isDestructive = false,
    this.backgroundColor,
    this.foregroundColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool isDestructive;
  final Color? backgroundColor;
  final Color? foregroundColor;
}

class AppSlidableActions extends StatelessWidget {
  const AppSlidableActions({
    required this.child,
    super.key,
    this.startActions = const <AppSwipeAction>[],
    this.endActions = const <AppSwipeAction>[],
  });

  final Widget child;
  final List<AppSwipeAction> startActions;
  final List<AppSwipeAction> endActions;

  @override
  Widget build(BuildContext context) {
    if (startActions.isEmpty && endActions.isEmpty) {
      return child;
    }

    return Slidable(
      startActionPane: startActions.isEmpty
          ? null
          : ActionPane(
              motion: const DrawerMotion(),
              extentRatio: _extentRatio(startActions.length),
              children: startActions
                  .map((action) => _buildAction(context, action))
                  .toList(growable: false),
            ),
      endActionPane: endActions.isEmpty
          ? null
          : ActionPane(
              motion: const ScrollMotion(),
              extentRatio: _extentRatio(endActions.length),
              children: endActions
                  .map((action) => _buildAction(context, action))
                  .toList(growable: false),
            ),
      child: child,
    );
  }

  double _extentRatio(int count) {
    return (count * 0.2).clamp(0.2, 0.6);
  }

  Widget _buildAction(BuildContext context, AppSwipeAction action) {
    final scheme = Theme.of(context).colorScheme;
    final backgroundColor =
        action.backgroundColor ??
        (action.isDestructive
            ? scheme.errorContainer
            : scheme.primaryContainer);
    final foregroundColor =
        action.foregroundColor ??
        (action.isDestructive
            ? scheme.onErrorContainer
            : scheme.onPrimaryContainer);

    return SlidableAction(
      onPressed: (_) => action.onPressed(),
      borderRadius: BorderRadius.circular(AppRadius.large),
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      icon: action.icon,
      label: action.label,
      spacing: 4,
    );
  }
}
