import 'package:flutter/foundation.dart';

/// Device position vs salon zone for employee Today (resolved in Riverpod).
@immutable
class EmployeeWorkplaceLocationSnapshot {
  const EmployeeWorkplaceLocationSnapshot({
    this.employeeLatitude,
    this.employeeLongitude,
    this.distanceMeters,
    this.insideZone,
    this.resolved = true,
  });

  const EmployeeWorkplaceLocationSnapshot.unresolved()
    : employeeLatitude = null,
      employeeLongitude = null,
      distanceMeters = null,
      insideZone = null,
      resolved = false;

  final double? employeeLatitude;
  final double? employeeLongitude;
  final double? distanceMeters;
  final bool? insideZone;

  /// `false` when workspace missing, zone not configured, or GPS failed.
  final bool resolved;

  bool get hasFix =>
      employeeLatitude != null &&
      employeeLongitude != null &&
      insideZone != null;
}
