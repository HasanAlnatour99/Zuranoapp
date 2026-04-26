import 'package:flutter/material.dart';

/// Bundled font family names — change here to swap global typography (e.g. Cairo for Arabic).
abstract final class AppFontFamilies {
  static const String heading = 'GoogleSans';
  static const String body = 'Roboto';

  static String headingFor(Locale locale) {
    // Example future hook: `if (locale.languageCode == 'ar') return 'Cairo';`
    return heading;
  }

  static String bodyFor(Locale locale) {
    // Example future hook: alternate body family per locale.
    return body;
  }

  static List<String> bodyFallbacks(Locale locale) {
    // Register additional families in [pubspec.yaml] before listing here.
    return const [];
  }
}
