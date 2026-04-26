import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

/// In-body top bar (shell may hide its AppBar on the More tab).
class ZuranoTopBar extends StatelessWidget {
  const ZuranoTopBar({super.key, required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 12, 12),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(AppIcons.arrow_back_ios_new_rounded, size: 20),
            color: ZuranoPremiumUiColors.textPrimary,
            style: IconButton.styleFrom(
              minimumSize: const Size(44, 44),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: ZuranoPremiumUiColors.textPrimary,
                letterSpacing: -0.2,
              ),
            ),
          ),
          const SizedBox(width: 44),
        ],
      ),
    );
  }
}
