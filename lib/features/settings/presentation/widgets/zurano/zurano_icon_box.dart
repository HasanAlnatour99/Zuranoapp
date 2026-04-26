import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

/// Soft square icon container for settings / HR cards.
class ZuranoIconBox extends StatelessWidget {
  const ZuranoIconBox({
    super.key,
    required this.icon,
    this.size = 44,
    this.iconSize = 22,
  });

  final IconData icon;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: ZuranoPremiumUiColors.softPurple,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        size: iconSize,
        color: ZuranoPremiumUiColors.primaryPurple,
      ),
    );
  }
}
