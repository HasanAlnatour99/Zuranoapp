import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart'
    show AppBrandColors, AppColorsLight;
import '../../../../core/theme/app_spacing.dart';

/// Hero image with overlay controls (back, favorite, share).
class SalonProfileHeader extends StatelessWidget {
  const SalonProfileHeader({
    super.key,
    required this.coverImageUrl,
    required this.onBack,
    required this.onFavoriteTap,
    required this.onShareTap,
    required this.favoriteSelected,
    this.height = 220,
  });

  final String? coverImageUrl;
  final VoidCallback onBack;
  final VoidCallback onFavoriteTap;
  final VoidCallback onShareTap;
  final bool favoriteSelected;
  final double height;

  @override
  Widget build(BuildContext context) {
    final url = coverImageUrl?.trim();

    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (url != null && url.isNotEmpty)
            Image.network(
              url,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const _HeaderFallback(),
            )
          else
            const _HeaderFallback(),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.2),
                  Colors.black.withValues(alpha: 0.5),
                ],
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.small,
                vertical: AppSpacing.small,
              ),
              child: Row(
                children: [
                  Material(
                    color: Colors.white.withValues(alpha: 0.92),
                    shape: const CircleBorder(),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_rounded),
                      color: AppColorsLight.textPrimary,
                      onPressed: onBack,
                    ),
                  ),
                  const Spacer(),
                  Material(
                    color: Colors.white.withValues(alpha: 0.92),
                    shape: const CircleBorder(),
                    child: IconButton(
                      icon: Icon(
                        favoriteSelected
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: favoriteSelected
                            ? Colors.redAccent
                            : AppColorsLight.textPrimary,
                      ),
                      onPressed: onFavoriteTap,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Material(
                    color: Colors.white.withValues(alpha: 0.92),
                    shape: const CircleBorder(),
                    child: IconButton(
                      icon: const Icon(Icons.ios_share_rounded),
                      color: AppColorsLight.textPrimary,
                      onPressed: onShareTap,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderFallback extends StatelessWidget {
  const _HeaderFallback();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppBrandColors.secondary,
      child: Center(
        child: Icon(
          Icons.storefront_rounded,
          size: 72,
          color: AppBrandColors.primary.withValues(alpha: 0.35),
        ),
      ),
    );
  }
}
