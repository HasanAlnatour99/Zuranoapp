import 'package:flutter/material.dart';
import 'package:phonecodes/phonecodes.dart' as pc;

import 'territory_names_ar.dart';

/// Country row for onboarding / settings (ISO 3166-1 alpha-2 + ITU-T dial).
/// Backed by [pc.Country] so the picker lists all territories with calling codes.
typedef CountryChoice = ({
  String code,
  String nameEn,
  String nameAr,
  String dialCode,
});

abstract final class AppCountries {
  /// Full sorted list (English + Arabic from CLDR, with a few shorter Gulf labels).
  static final List<CountryChoice> choices = _buildChoices();

  static List<CountryChoice> _buildChoices() {
    // [phonecodes] repeats the same ISO for some territories (e.g. DO, PR, SH).
    final byIso = <String, CountryChoice>{};
    for (final c in pc.Country.values) {
      final iso = c.code.toUpperCase();
      if (byIso.containsKey(iso)) {
        continue;
      }
      byIso[iso] = (
        code: c.code,
        nameEn: c.name,
        nameAr: _nameArFor(iso, c.name),
        dialCode: c.dialCode,
      );
    }
    final out = byIso.values.toList();
    out.sort(
      (a, b) => a.nameEn.toLowerCase().compareTo(b.nameEn.toLowerCase()),
    );
    return out;
  }

  /// Arabic display name: CLDR + optional short overrides, else English.
  static String _nameArFor(String isoUpper, String nameEn) {
    final u = isoUpper.toUpperCase();
    return _arabicShortOverrides[u] ?? kTerritoryNamesAr[u] ?? nameEn;
  }

  /// Shorter Arabic where the team prefers it over full CLDR wording.
  static const Map<String, String> _arabicShortOverrides = {
    'AE': 'الإمارات',
    'SA': 'السعودية',
  };

  static String? nameForCode(String? code, Locale locale) {
    if (code == null || code.isEmpty) {
      return null;
    }
    final u = code.toUpperCase();
    for (final c in choices) {
      if (c.code == u) {
        return locale.languageCode == 'ar' ? c.nameAr : c.nameEn;
      }
    }
    return code;
  }
}
