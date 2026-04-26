import 'package:geolocator/geolocator.dart';

/// Device GPS: current position, distance, and salon-radius checks.
///
/// Onboarding [LocationService] handles country/city lists — keep names distinct.
class DeviceGeolocationService {
  Future<Position> getCurrentPosition() async {
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

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
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
