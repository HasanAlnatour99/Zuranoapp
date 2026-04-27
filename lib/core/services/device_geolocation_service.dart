import 'dart:async';

import 'package:geolocator/geolocator.dart';

/// Device GPS: current position, distance, and salon-radius checks.
///
/// Onboarding [LocationService] handles country/city lists — keep names distinct.
class DeviceGeolocationService {
  Future<Position> getCurrentPosition({
    Duration timeout = const Duration(seconds: 12),
    LocationAccuracy accuracy = LocationAccuracy.high,
  }) async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception('Location service is disabled. Please enable GPS.');
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception('Location permission is required.');
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permission is permanently denied. Please enable it from phone settings.',
      );
    }

    final lastKnown = await Geolocator.getLastKnownPosition();
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: accuracy,
          timeLimit: timeout,
        ),
      );
    } on TimeoutException {
      if (lastKnown != null) {
        return lastKnown;
      }
      throw Exception('Location request timed out. Please try again.');
    } on Object {
      if (lastKnown != null) {
        return lastKnown;
      }
      rethrow;
    }
  }

  Future<Position?> tryGetCurrentPosition({
    Duration timeout = const Duration(seconds: 8),
    LocationAccuracy accuracy = LocationAccuracy.medium,
  }) async {
    try {
      return await getCurrentPosition(timeout: timeout, accuracy: accuracy);
    } on Object {
      return await Geolocator.getLastKnownPosition();
    }
  }

  double distanceBetweenMeters({
    required double fromLat,
    required double fromLng,
    required double toLat,
    required double toLng,
  }) {
    return Geolocator.distanceBetween(fromLat, fromLng, toLat, toLng);
  }

  bool isInsideRadius({
    required double employeeLat,
    required double employeeLng,
    required double salonLat,
    required double salonLng,
    required double radiusMeters,
  }) {
    final distance = distanceBetweenMeters(
      fromLat: employeeLat,
      fromLng: employeeLng,
      toLat: salonLat,
      toLng: salonLng,
    );

    return distance <= radiusMeters;
  }
}
