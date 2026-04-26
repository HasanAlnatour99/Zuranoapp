import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

/// Premium settings / HR shell body (bottom navigation comes from [OwnerDashboardScreen]).
class ZuranoPageScaffold extends StatelessWidget {
  const ZuranoPageScaffold({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(color: ZuranoPremiumUiColors.background, child: child);
  }
}
