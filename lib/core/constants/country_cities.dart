class CityOption {
  const CityOption({required this.nameEn, required this.nameAr});

  final String nameEn;
  final String nameAr;

  String labelForLocale(String languageCode) =>
      languageCode == 'ar' ? nameAr : nameEn;
}

abstract final class CountryCities {
  static const Map<String, List<CityOption>> _byCountryIso = {
    'QA': [
      CityOption(nameEn: 'Doha', nameAr: 'الدوحة'),
      CityOption(nameEn: 'Al Rayyan', nameAr: 'الريان'),
      CityOption(nameEn: 'Al Wakrah', nameAr: 'الوكرة'),
      CityOption(nameEn: 'Lusail', nameAr: 'لوسيل'),
      CityOption(nameEn: 'Al Khor', nameAr: 'الخُور'),
    ],
    'SA': [
      CityOption(nameEn: 'Riyadh', nameAr: 'الرياض'),
      CityOption(nameEn: 'Jeddah', nameAr: 'جدة'),
      CityOption(nameEn: 'Makkah', nameAr: 'مكة'),
      CityOption(nameEn: 'Madinah', nameAr: 'المدينة المنورة'),
      CityOption(nameEn: 'Dammam', nameAr: 'الدمام'),
    ],
    'AE': [
      CityOption(nameEn: 'Dubai', nameAr: 'دبي'),
      CityOption(nameEn: 'Abu Dhabi', nameAr: 'أبوظبي'),
      CityOption(nameEn: 'Sharjah', nameAr: 'الشارقة'),
      CityOption(nameEn: 'Ajman', nameAr: 'عجمان'),
      CityOption(nameEn: 'Al Ain', nameAr: 'العين'),
    ],
    'US': [
      CityOption(nameEn: 'New York', nameAr: 'نيويورك'),
      CityOption(nameEn: 'Los Angeles', nameAr: 'لوس أنجلوس'),
      CityOption(nameEn: 'Chicago', nameAr: 'شيكاغو'),
      CityOption(nameEn: 'Houston', nameAr: 'هيوستن'),
      CityOption(nameEn: 'Miami', nameAr: 'ميامي'),
    ],
  };

  static const List<CityOption> _fallback = [
    CityOption(nameEn: 'Doha', nameAr: 'الدوحة'),
    CityOption(nameEn: 'Riyadh', nameAr: 'الرياض'),
    CityOption(nameEn: 'Dubai', nameAr: 'دبي'),
    CityOption(nameEn: 'Amman', nameAr: 'عمان'),
    CityOption(nameEn: 'Cairo', nameAr: 'القاهرة'),
  ];

  static List<CityOption> citiesForCountry(String? isoCode) {
    if (isoCode == null || isoCode.trim().isEmpty) {
      return _fallback;
    }
    final key = isoCode.trim().toUpperCase();
    return _byCountryIso[key] ?? _fallback;
  }
}
