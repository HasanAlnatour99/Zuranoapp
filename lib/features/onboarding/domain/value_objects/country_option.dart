import '../../../../core/constants/app_countries.dart';

/// Country metadata for selectors (name, ISO-3166 alpha-2, dial code).
class CountryOption {
  const CountryOption({
    required this.isoCode,
    required this.nameEn,
    required this.nameAr,
    required this.dialCode,
  });

  final String isoCode;
  final String nameEn;
  final String nameAr;
  final String dialCode;

  String labelForLocale(String languageCode) =>
      languageCode == 'ar' ? nameAr : nameEn;

  factory CountryOption.fromChoice(CountryChoice c) {
    return CountryOption(
      isoCode: c.code,
      nameEn: c.nameEn,
      nameAr: c.nameAr,
      dialCode: c.dialCode,
    );
  }

  static List<CountryOption> get all => AppCountries.choices
      .map(CountryOption.fromChoice)
      .toList(growable: false);

  static CountryOption? tryFindByIso(String? code) {
    if (code == null || code.isEmpty) return null;
    final u = code.toUpperCase();
    for (final c in AppCountries.choices) {
      if (c.code == u) {
        return CountryOption.fromChoice(c);
      }
    }
    return null;
  }
}
