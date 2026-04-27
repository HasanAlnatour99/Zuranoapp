import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';

class ZuranoAddSaleFab extends StatelessWidget {
  const ZuranoAddSaleFab({
    super.key,
    required this.onPressed,
    required this.heroTag,
  });

  final VoidCallback onPressed;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    if (bottomInset > 0) {
      return const SizedBox.shrink();
    }
    final l10n = AppLocalizations.of(context)!;
    return FloatingActionButton(
      heroTag: heroTag,
      elevation: 8,
      backgroundColor: ZuranoPremiumUiColors.primaryPurple,
      foregroundColor: Colors.white,
      tooltip: l10n.employeeAddSaleFab,
      onPressed: onPressed,
      child: const Icon(Icons.add_rounded),
    );
  }
}
