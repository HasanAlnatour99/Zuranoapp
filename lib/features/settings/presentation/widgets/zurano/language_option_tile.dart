import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

/// Radio-style language row with selected lavender fill and trailing check.
class LanguageOptionTile extends StatelessWidget {
  const LanguageOptionTile({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          height: 52,
          decoration: BoxDecoration(
            color: selected ? ZuranoPremiumUiColors.softPurple : null,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? ZuranoPremiumUiColors.primaryPurple.withValues(alpha: 0.25)
                  : ZuranoPremiumUiColors.border,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                Icon(
                  Icons.language_rounded,
                  size: 22,
                  color: selected
                      ? ZuranoPremiumUiColors.primaryPurple
                      : ZuranoPremiumUiColors.textSecondary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: ZuranoPremiumUiColors.textPrimary,
                    ),
                  ),
                ),
                Icon(
                  selected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_off_rounded,
                  color: selected
                      ? ZuranoPremiumUiColors.primaryPurple
                      : ZuranoPremiumUiColors.textSecondary,
                  size: 22,
                ),
                const SizedBox(width: 8),
                if (selected)
                  Icon(
                    Icons.check_circle_rounded,
                    color: ZuranoPremiumUiColors.primaryPurple,
                    size: 22,
                  )
                else
                  const SizedBox(width: 22),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
