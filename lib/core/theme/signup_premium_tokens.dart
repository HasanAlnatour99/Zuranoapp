import 'package:flutter/material.dart';

/// Light luxury palette for email/password signup (matches purple brand).
abstract final class SignupPremiumColors {
  static const background = Color(0xFFFFFFFF);
  static const inputFill = Color(0xFFF3F4F6);
  static const textPrimary = Color(0xFF111111);
  static const textSecondary = Color(0xFF64748B);
  static const border = Color(0xFFE5E7EB);
  static const borderStrong = Color(0xFFCBD5E1);
  static const error = Color(0xFFB3261E);
  static const purpleDeep = Color(0xFF7B2FF7);
  static const purpleLight = Color(0xFF9B51E0);
  static const socialSurface = Color(0xFFFFFFFF);
}

abstract final class SignupPremiumLayout {
  static const double screenPadding = 24;
  static const double fieldRadius = 16;
  static const double buttonHeight = 56;
  static const double socialHeight = 56;
  static const double sectionGap = 14;
}

abstract final class SignupPremiumGradients {
  static const primaryCta = LinearGradient(
    colors: [SignupPremiumColors.purpleDeep, SignupPremiumColors.purpleLight],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}

/// Local theme overlay for signup (does not replace app-wide theme).
ThemeData signupPremiumThemeOverlay(ThemeData base) {
  const scheme = ColorScheme.light(
    primary: SignupPremiumColors.purpleDeep,
    onPrimary: Colors.white,
    surface: SignupPremiumColors.background,
    onSurface: SignupPremiumColors.textPrimary,
    onSurfaceVariant: SignupPremiumColors.textSecondary,
    error: SignupPremiumColors.error,
    outline: SignupPremiumColors.borderStrong,
  );

  return base.copyWith(
    brightness: Brightness.light,
    colorScheme: scheme,
    scaffoldBackgroundColor: SignupPremiumColors.background,
    textTheme: base.textTheme.apply(
      bodyColor: SignupPremiumColors.textPrimary,
      displayColor: SignupPremiumColors.textPrimary,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: SignupPremiumColors.purpleDeep,
        textStyle: base.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}
