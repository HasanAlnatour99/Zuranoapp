import 'package:flutter/material.dart';

import 'app_text_styles.dart';

TextTheme localizedTextTheme({
  required ColorScheme scheme,
  required Locale locale,
}) {
  final m3 = scheme.brightness == Brightness.dark
      ? Typography.material2021(platform: TargetPlatform.android).white
      : Typography.material2021(platform: TargetPlatform.android).black;

  return m3.copyWith(
    displayLarge: AppTextStyles.headingLarge(
      scheme,
      locale: locale,
    ).copyWith(fontSize: 54, height: 1.12, letterSpacing: -0.25),
    displayMedium: AppTextStyles.headingLarge(
      scheme,
      locale: locale,
    ).copyWith(fontSize: 42, height: 1.16, letterSpacing: 0),
    displaySmall: AppTextStyles.headingLarge(
      scheme,
      locale: locale,
    ).copyWith(fontSize: 33, height: 1.22, letterSpacing: 0),
    headlineLarge: AppTextStyles.headingLarge(
      scheme,
      locale: locale,
    ).copyWith(fontSize: 29, height: 1.25, letterSpacing: 0),
    headlineMedium: AppTextStyles.headingLarge(
      scheme,
      locale: locale,
    ).copyWith(fontSize: 25, height: 1.29, letterSpacing: 0),
    headlineSmall: AppTextStyles.headingLarge(scheme, locale: locale),
    titleLarge: AppTextStyles.headingLarge(
      scheme,
      locale: locale,
    ).copyWith(fontSize: 18, height: 1.25, letterSpacing: -0.2),
    titleMedium: AppTextStyles.headingMedium(
      scheme,
      locale: locale,
    ).copyWith(fontSize: 16, height: 1.3, color: scheme.onSurface),
    titleSmall: AppTextStyles.headingMedium(scheme, locale: locale).copyWith(
      fontSize: 14,
      height: 1.3,
      letterSpacing: 0.1,
      color: scheme.onSurface,
    ),
    bodyLarge: AppTextStyles.bodyLarge(scheme, locale: locale),
    bodyMedium: AppTextStyles.bodyMedium(scheme, locale: locale),
    bodySmall: AppTextStyles.bodyMedium(scheme, locale: locale).copyWith(
      fontSize: 12,
      height: 1.33,
      letterSpacing: 0.4,
      color: scheme.onSurfaceVariant,
    ),
    labelLarge: AppTextStyles.buttonText(
      scheme,
      locale: locale,
    ).copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.1),
    labelMedium: AppTextStyles.bodyMedium(scheme, locale: locale).copyWith(
      fontWeight: FontWeight.w500,
      fontSize: 12,
      height: 1.33,
      letterSpacing: 0.5,
      color: scheme.onSurface,
    ),
    labelSmall: AppTextStyles.bodyMedium(scheme, locale: locale).copyWith(
      fontWeight: FontWeight.w500,
      fontSize: 11,
      height: 1.45,
      letterSpacing: 0.5,
      color: scheme.onSurfaceVariant,
    ),
  );
}
