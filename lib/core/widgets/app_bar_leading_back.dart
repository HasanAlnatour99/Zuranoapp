import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

/// Compact back control for narrow AppBars; works with [GoRouter] stacks.
///
/// When the route can pop, uses [GoRouter.pop] or [Navigator.pop]. Otherwise, if
/// [fallbackLocation] is set, uses [GoRouter.go]. If neither applies, renders
/// an empty gap so root dashboards keep a stable title alignment.
///
/// When no [GoRouter] is in the tree (e.g. some widget tests), falls back to
/// [Navigator] only.
class AppBarLeadingBack extends StatelessWidget {
  const AppBarLeadingBack({super.key, this.fallbackLocation});

  /// When pop is not available, [GoRouter.go] navigates here.
  final String? fallbackLocation;

  static bool _canPop(BuildContext context) {
    final router = GoRouter.maybeOf(context);
    if (router != null) {
      return router.canPop();
    }
    return Navigator.of(context).canPop();
  }

  @override
  Widget build(BuildContext context) {
    final canPop = _canPop(context);
    final fallback = fallbackLocation?.trim();
    final hasFallback = fallback != null && fallback.isNotEmpty;
    if (!canPop && !hasFallback) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context);
    final tooltip =
        l10n?.authCommonBack ??
        MaterialLocalizations.of(context).backButtonTooltip;

    return IconButton(
      icon: const Icon(AppIcons.arrow_back_ios_new_rounded, size: 20),
      tooltip: tooltip,
      visualDensity: VisualDensity.compact,
      style: IconButton.styleFrom(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: () {
        final router = GoRouter.maybeOf(context);
        if (router != null) {
          if (router.canPop()) {
            router.pop();
          } else if (hasFallback) {
            router.go(fallback);
          }
        } else if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      },
    );
  }
}
