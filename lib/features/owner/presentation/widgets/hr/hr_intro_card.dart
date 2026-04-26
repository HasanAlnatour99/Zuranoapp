import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

class HrIntroCard extends StatelessWidget {
  const HrIntroCard({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: ZuranoPremiumUiColors.softPurple,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: ZuranoPremiumUiColors.primaryPurple.withValues(alpha: 0.12),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: ZuranoPremiumUiColors.primaryPurple,
              borderRadius: BorderRadius.all(Radius.circular(14)),
            ),
            child: const Icon(
              Icons.verified_user_outlined,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: ZuranoPremiumUiColors.textPrimary,
                height: 1.45,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
