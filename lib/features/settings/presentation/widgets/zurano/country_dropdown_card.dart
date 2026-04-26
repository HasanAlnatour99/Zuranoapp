import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

/// Compact bordered field that opens country selection from parent [onTap].
class CountryDropdownCard extends StatelessWidget {
  const CountryDropdownCard({
    super.key,
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: ZuranoPremiumUiColors.lightSurface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          constraints: const BoxConstraints(minHeight: 48),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: ZuranoPremiumUiColors.border),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: ZuranoPremiumUiColors.textPrimary,
                  ),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: ZuranoPremiumUiColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
