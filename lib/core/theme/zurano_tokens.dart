import 'package:flutter/material.dart';

/// Premium Zurano (white + purple) tokens for owner Services flows.
/// Scoped tokens — use with `Zurano` widgets; app-wide theme stays unchanged.
abstract final class ZuranoTokens {
  static const Color background = Color(0xFFFAFAFD);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color primary = Color(0xFF7C3AED);
  static const Color secondary = Color(0xFFA855F7);
  static const Color lightPurple = Color(0xFFF3E8FF);
  static const Color activeCardFill = Color(0xFFFAF5FF);
  static const Color textDark = Color(0xFF0F172A);
  static const Color textGray = Color(0xFF6B7280);
  static const Color border = Color(0xFFE5E7EB);
  static const Color sectionBorder = Color(0xFFECECF2);
  static const Color searchFill = Color(0xFFF8F7FC);
  static const Color chipUnselected = Color(0xFFF4F4F6);
  static const Color inputFill = Color(0xFFFCFCFE);
  static const Color uploadFill = Color(0xFFFCFAFF);

  static const double radiusCard = 22;
  static const double radiusSection = 24;
  static const double radiusInput = 18;
  static const double radiusButton = 20;
  static const double radiusSearch = 20;

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static List<BoxShadow> softCardShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.06),
      blurRadius: 18,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> sectionShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.045),
      blurRadius: 22,
      offset: const Offset(0, 10),
    ),
  ];

  static List<BoxShadow> fabGlow = [
    BoxShadow(
      color: primary.withValues(alpha: 0.35),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];
}
