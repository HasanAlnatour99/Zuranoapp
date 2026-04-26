import '../../../../core/constants/app_countries.dart';

/// Display + persistence model for the country picker (Zurano onboarding).
class Country {
  const Country({
    required this.nameEn,
    required this.nameAr,
    required this.isoCode,
    required this.dialCode,
  });

  final String nameEn;
  final String nameAr;
  final String isoCode;
  final String dialCode;

  String get flag => countryFlagEmoji(isoCode);

  /// For `users/{uid}.countryName` and UI (English canonical).
  String get nameForFirestore => nameEn;

  String displayName(String languageCode) =>
      languageCode == 'ar' ? nameAr : nameEn;

  static Country fromChoice(CountryChoice c) {
    return Country(
      nameEn: c.nameEn,
      nameAr: c.nameAr,
      isoCode: c.code,
      dialCode: c.dialCode,
    );
  }

  static String countryFlagEmoji(String isoCode) {
    final code = isoCode.toUpperCase();
    if (code.length != 2) return '';
    return code.runes.map((r) => String.fromCharCode(r + 127397)).join();
  }
}
