import 'package:flutter/material.dart';

import '../../../../core/widgets/zurano/zurano_empty_state.dart';
import '../../../../l10n/app_localizations.dart';

class EmptyServicesState extends StatelessWidget {
  const EmptyServicesState({super.key, this.onAdd, this.showPrimary = true});

  final VoidCallback? onAdd;
  final bool showPrimary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ZuranoEmptyState(
      title: l10n.ownerServicesEmptyTitle,
      description: l10n.ownerServicesEmptyDescription,
      primaryLabel: l10n.ownerAddService,
      onPrimary: onAdd ?? () {},
      showPrimaryButton: showPrimary,
    );
  }
}
