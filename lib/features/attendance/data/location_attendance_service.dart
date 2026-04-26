import 'package:geolocator/geolocator.dart';

import '../../../core/services/device_geolocation_service.dart';

/// GPS helpers for attendance punches (spec-aligned API).
class LocationAttendanceService {
  LocationAttendanceService({DeviceGeolocationService? device})
    : _device = device ?? DeviceGeolocationService();

  final DeviceGeolocationService _device;

  Future<Position> getCurrentPosition() => _device.getCurrentPosition();

  double calculateDistanceMeters({
    required double salonLat,
    required double salonLng,
    required double userLat,
    required double userLng,
  }) {
    return Geolocator.distanceBetween(salonLat, salonLng, userLat, userLng);
  }
}
