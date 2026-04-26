import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Tile footprint presets for masonry layouts.
enum BentoCardSize { small, medium, large }

/// Layout and elevation tokens for the Bento card system (no widget tree).
abstract final class BentoLayoutTokens {
  static const double minHeightSmall = 118;
  static const double minHeightMedium = 156;
  static const double minHeightLarge = 212;
  static const double iconGlyphSize = 26;

  static double minHeightFor(BentoCardSize size) => switch (size) {
    BentoCardSize.small => minHeightSmall,
    BentoCardSize.medium => minHeightMedium,
    BentoCardSize.large => minHeightLarge,
  };
}

/// Visual decoration tokens for Bento surfaces (gradients, elevation, shadow).
abstract final class BentoDecorTokens {
  static const double cardElevation = 6;

  static LinearGradient cardGradient(Brightness brightness) {
    if (brightness == Brightness.dark) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF4C1D95), Color(0xFF6D28D9), Color(0xFF7C3AED)],
      );
    }
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppBrandColorsPremium.secondary,
        AppBrandColorsPremium.primary,
        AppBrandColorsPremium.primaryLight,
      ],
    );
  }

  static List<BoxShadow> cardShadows(ColorScheme scheme) => [
    BoxShadow(
      color: scheme.shadow.withValues(alpha: 0.2),
      blurRadius: 22,
      offset: Offset(0, cardElevation * 1.5),
    ),
  ];
}
