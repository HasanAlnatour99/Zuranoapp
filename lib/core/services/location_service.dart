import 'package:country_state_city/country_state_city.dart' as csc;

/// Resolves city names for salon setup from bundled country data.
class LocationService {
  const LocationService();

  /// Returns sorted unique city names for [countryCode] (ISO 3166-1 alpha-2).
  Future<List<String>> getCitiesByCountryCode(String countryCode) async {
    final normalized = countryCode.trim().toUpperCase();
    if (normalized.isEmpty) {
      return const [];
    }
    try {
      final cities = await csc.getCountryCities(normalized);
      final names = cities.map((c) => c.name.trim()).where((n) => n.isNotEmpty);
      final unique = names.toSet().toList()..sort();
      return unique;
    } catch (_) {
      return const [];
    }
  }
}
