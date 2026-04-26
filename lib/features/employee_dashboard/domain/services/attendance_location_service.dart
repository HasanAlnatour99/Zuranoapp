import 'package:geolocator/geolocator.dart';

import 'package:barber_shop_app/core/services/device_geolocation_service.dart';

class AttendanceLocationService {
  final DeviceGeolocationService _location = DeviceGeolocationService();

  Future<Position> getCurrentPosition() => _location.getCurrentPosition();

  double calculateDistanceMeters({
    required double fromLat,
    required double fromLng,
    required double toLat,
    required double toLng,
  }) {
    return _location.distanceBetweenMeters(
      fromLat: fromLat,
      fromLng: fromLng,
      toLat: toLat,
      toLng: toLng,
    );
  }

  bool isInsideZone({
    required double employeeLat,
    required double employeeLng,
    required double salonLat,
    required double salonLng,
    required double radiusMeters,
  }) {
    return _location.isInsideRadius(
      employeeLat: employeeLat,
      employeeLng: employeeLng,
      salonLat: salonLat,
      salonLng: salonLng,
      radiusMeters: radiusMeters,
    );
  }
}
