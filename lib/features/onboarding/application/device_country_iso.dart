import 'dart:ui' as ui;

import '../../../core/constants/app_countries.dart';

/// Tries the device locale’s region (e.g. `en_US` → `US`) against [AppCountries].
String? tryDeviceLocaleCountryIso() {
  final region = ui.PlatformDispatcher.instance.locale.countryCode;
  if (region == null || region.isEmpty) return null;
  return AppCountries.choices.any((c) => c.code == region.toUpperCase())
      ? region.toUpperCase()
      : null;
}
