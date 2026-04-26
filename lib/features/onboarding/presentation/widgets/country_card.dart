import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/models/country.dart';

const _kSelectedFill = Color(0xFFEDE7F6);
const _kUnselectedFill = Color(0xFFF9F7FF);
const _kSubtleBorder = Color(0xFFE5E1EC);

/// One country row with flag, name, ISO, dial code, and selection affordance.
class CountryCard extends StatelessWidget {
  const CountryCard({
    super.key,
    required this.country,
    required this.displayName,
    required this.isSelected,
    required this.onTap,
  });

  final Country country;
  final String displayName;
  final bool isSelected;
  final VoidCallback onTap;

  static const _radius = 20.0;
  static const _flagSize = 30.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_radius),
        border: Border.all(
          color: isSelected
              ? AppBrandColorsPremium.primary
              : _kSubtleBorder.withValues(alpha: 0.9),
          width: isSelected ? 1.5 : 1,
        ),
        color: isSelected
            ? _kSelectedFill
            : (isDark
                  ? theme.colorScheme.surfaceContainerHigh
                  : _kUnselectedFill),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(_radius),
          splashColor: AppBrandColorsPremium.primary.withValues(alpha: 0.12),
          highlightColor: AppBrandColorsPremium.primary.withValues(alpha: 0.06),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: _flagSize,
                  height: _flagSize,
                  child: Center(
                    child: Text(
                      country.flag,
                      style: const TextStyle(fontSize: 25, height: 1),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        displayName,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        country.isoCode,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  country.dialCode,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppBrandColorsPremium.primary,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(width: 10),
                _TrailingSelection(isSelected: isSelected),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TrailingSelection extends StatelessWidget {
  const _TrailingSelection({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    if (isSelected) {
      return Container(
        width: 28,
        height: 28,
        decoration: const BoxDecoration(
          color: AppBrandColorsPremium.primary,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check_rounded,
          size: 16,
          color: AppBrandColorsPremium.onPrimary,
        ),
      );
    }
    return Icon(
      Icons.circle_outlined,
      size: 22,
      color: AppBrandColorsPremium.primary.withValues(alpha: 0.35),
    );
  }
}
