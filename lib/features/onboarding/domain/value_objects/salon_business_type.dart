/// Stored in Firestore on `salons/{salonId}.businessType`.
enum SalonBusinessType {
  barber,
  womenSalon,
  unisex;

  String get firestoreValue => switch (this) {
    SalonBusinessType.barber => 'barber',
    SalonBusinessType.womenSalon => 'women_salon',
    SalonBusinessType.unisex => 'unisex',
  };

  static SalonBusinessType? tryParse(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    switch (raw) {
      case 'barber':
        return SalonBusinessType.barber;
      case 'women_salon':
        return SalonBusinessType.womenSalon;
      case 'unisex':
        return SalonBusinessType.unisex;
      default:
        return null;
    }
  }
}
