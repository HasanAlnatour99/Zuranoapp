import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Premium rounded card used on employee workspace and attendance settings.
class ZuranoCard extends StatelessWidget {
  const ZuranoCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: ZuranoPremiumUiColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: ZuranoPremiumUiColors.border.withValues(alpha: 0.7),
        ),
        boxShadow: [
          BoxShadow(
            color: ZuranoPremiumUiColors.primaryPurple.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );

    if (onTap == null) {
      return card;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: card,
      ),
    );
  }
}
