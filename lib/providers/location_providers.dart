import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/location_service.dart';
import 'onboarding_providers.dart';

final locationServiceProvider = Provider<LocationService>((ref) {
  return const LocationService();
});

/// Cities for the country chosen during onboarding (ISO alpha-2).
final salonSetupCitiesProvider = FutureProvider.autoDispose<List<String>>((
  ref,
) async {
  final code = ref.watch(onboardingPrefsProvider).countryCode?.trim();
  if (code == null || code.isEmpty) {
    return const [];
  }
  return ref.read(locationServiceProvider).getCitiesByCountryCode(code);
});
