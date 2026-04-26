import 'package:flutter/material.dart';

import 'app_bar_leading_back.dart';

/// Shared app bar for full-screen pages.
///
/// Defaults to a contextual back arrow when the route can pop.
class AppPageHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppPageHeader({
    super.key,
    this.title,
    this.actions,
    this.showBackButton,
    this.fallbackLocation,
    this.automaticallyImplyLeading = false,
    this.elevation = 0,
    this.scrolledUnderElevation = 0,
    this.backgroundColor,
    this.foregroundColor,
    this.bottom,
  });

  final Widget? title;
  final List<Widget>? actions;
  final bool? showBackButton;
  final String? fallbackLocation;
  final bool automaticallyImplyLeading;
  final double? elevation;
  final double? scrolledUnderElevation;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    final shouldShowBack = showBackButton ?? canPop;

    return AppBar(
      leading: shouldShowBack
          ? AppBarLeadingBack(fallbackLocation: fallbackLocation)
          : null,
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: title,
      actions: actions,
      elevation: elevation,
      scrolledUnderElevation: scrolledUnderElevation,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      bottom: bottom,
    );
  }
}
