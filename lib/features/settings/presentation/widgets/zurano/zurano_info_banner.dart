import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

class ZuranoInfoBanner extends StatelessWidget {
  const ZuranoInfoBanner({super.key, required this.text, this.onClose});

  final String text;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: ZuranoPremiumUiColors.softPurple,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ZuranoPremiumUiColors.primaryPurple.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: ZuranoPremiumUiColors.primaryPurple,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: ZuranoPremiumUiColors.textPrimary,
                height: 1.35,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (onClose != null)
            IconButton(
              onPressed: onClose,
              icon: Icon(
                Icons.close_rounded,
                color: ZuranoPremiumUiColors.textSecondary,
                size: 20,
              ),
              style: IconButton.styleFrom(
                minimumSize: const Size(40, 40),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
            ),
        ],
      ),
    );
  }
}
