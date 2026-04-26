import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Semantic colors for auth & pre-auth (premium light: white + purple).
/// Prefer [Theme.of(context).colorScheme] in product screens when possible.
abstract final class AuthPremiumColors {
  /// App canvas.
  static const scaffold = Colors.white;

  /// Base / panels.
  static const surface = Colors.white;

  /// Cards / elevated blocks (rare; prefer [surface] on white app).
  static const surfaceElevated = Color(0xFFF8FAFC);

  /// Auth text fields.
  static const inputFill = Color(0xFFF3F4F6);

  /// Subtle borders.
  static const border = Color(0xFFE5E7EB);

  static const textPrimary = Color(0xFF111111);

  static const textSecondary = Color(0xFF64748B);

  static const accent = AppBrandColorsPremium.primary;

  static const accentSecondary = AppBrandColorsPremium.secondary;

  static const error = Color(0xFFEF4444);
  static const success = Color(0xFF10B981);

  static const gradientAccent = AppPremiumGradients.accent;
}

abstract final class AuthPremiumLayout {
  static const double screenPadding = 24;
  static const double fieldHeight = 56;
  static const double buttonHeightMin = 55;
  static const double cardRadius = 20;
  static const double fieldRadius = 16;
  static const double sectionGap = 18;
}
