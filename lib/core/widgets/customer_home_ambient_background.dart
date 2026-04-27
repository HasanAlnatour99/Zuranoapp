import 'package:flutter/material.dart';

/// Plain white canvas for customer discover home (RTL-safe).
class CustomerHomeAmbientBackground extends StatelessWidget {
  const CustomerHomeAmbientBackground({super.key, required this.child});

  final Widget child;

  /// [AppBar] fill aligned with the body canvas.
  static Color appBarTint(ColorScheme scheme) => scheme.surface;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ColoredBox(color: scheme.surface, child: child);
  }
}
