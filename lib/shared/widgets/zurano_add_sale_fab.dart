import 'package:flutter/material.dart';

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
    return FloatingActionButton.extended(
      heroTag: heroTag,
      elevation: 8,
      backgroundColor: const Color(0xFF7C3AED),
      foregroundColor: Colors.white,
      onPressed: onPressed,
      icon: const Icon(Icons.add_rounded),
      label: Text(
        l10n.employeeAddSaleFab,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
      ),
    );
  }
}
