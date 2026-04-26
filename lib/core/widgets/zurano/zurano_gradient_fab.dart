import 'package:flutter/material.dart';

import '../../theme/zurano_tokens.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

class ZuranoGradientFab extends StatelessWidget {
  const ZuranoGradientFab({
    super.key,
    required this.onPressed,
    this.tooltip,
    this.size = 58,
  });

  final VoidCallback onPressed;
  final String? tooltip;
  final double size;

  @override
  Widget build(BuildContext context) {
    final fab = Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Ink(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: ZuranoTokens.primaryGradient,
            boxShadow: ZuranoTokens.fabGlow,
          ),
          child: const Center(
            child: Icon(AppIcons.add_rounded, color: Colors.white, size: 30),
          ),
        ),
      ),
    );

    if (tooltip == null || tooltip!.isEmpty) {
      return fab;
    }
    return Tooltip(message: tooltip!, child: fab);
  }
}
