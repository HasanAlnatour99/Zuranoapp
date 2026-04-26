import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../providers/auth_session_actions.dart';

Future<void> showZuranoSignOutConfirmDialog(BuildContext context) async {
  final l10n = AppLocalizations.of(context)!;
  final theme = Theme.of(context);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          l10n.signOutDialogTitle,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: ZuranoPremiumUiColors.textPrimary,
          ),
        ),
        content: Text(
          l10n.signOutSubtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: ZuranoPremiumUiColors.textSecondary,
            height: 1.45,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: ZuranoPremiumUiColors.danger,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.customerSignOut),
          ),
        ],
      );
    },
  );
  if (confirmed == true && context.mounted) {
    await performAppSignOut(context);
  }
}
