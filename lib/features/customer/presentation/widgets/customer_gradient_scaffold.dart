import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Soft Zurano background: white base + light purple vertical wash.
class CustomerGradientScaffold extends StatelessWidget {
  const CustomerGradientScaffold({
    super.key,
    required this.child,
    this.bottomNavigationBar,
  });

  final Widget child;
  final Widget? bottomNavigationBar;

  static const _top = Color(0xFFF5F3FF);
  static const _mid = Color(0xFFFAFAFF);
  static const _bottom = Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_top, _mid, _bottom],
          stops: [0.0, 0.45, 1.0],
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(
            context,
          ).colorScheme.copyWith(surface: Colors.transparent),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          bottomNavigationBar: bottomNavigationBar,
          body: child,
        ),
      ),
    );
  }
}

/// Deep purple filled button for customer CTAs (matches brand primary).
class CustomerPrimaryButtonStyle {
  static ButtonStyle filled(BuildContext context) {
    return FilledButton.styleFrom(
      backgroundColor: AppBrandColors.primary,
      foregroundColor: AppBrandColors.onPrimary,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}
