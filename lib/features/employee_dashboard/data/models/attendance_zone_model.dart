class AttendanceZoneModel {
  const AttendanceZoneModel({
    required this.latitude,
    required this.longitude,
    required this.radiusMeters,
    this.address = '',
    this.branchName = '',
  });

  final double latitude;
  final double longitude;
  final double radiusMeters;
  final String address;
  final String branchName;

  bool get isConfigured =>
      latitude != 0 &&
      longitude != 0 &&
      radiusMeters >= 10 &&
      radiusMeters <= 500;

  factory AttendanceZoneModel.fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return const AttendanceZoneModel(
        latitude: 0,
        longitude: 0,
        radiusMeters: 20,
      );
    }
    final m = Map<String, dynamic>.from(map);
    return AttendanceZoneModel(
      latitude: (m['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (m['longitude'] as num?)?.toDouble() ?? 0,
      radiusMeters: (m['radiusMeters'] as num?)?.toDouble() ?? 20,
      address: m['address']?.toString() ?? '',
      branchName: m['branchName']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'radiusMeters': radiusMeters,
      'address': address,
      'branchName': branchName,
    };
  }

  AttendanceZoneModel copyWith({
    double? latitude,
    double? longitude,
    double? radiusMeters,
    String? address,
    String? branchName,
  }) {
    return AttendanceZoneModel(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radiusMeters: radiusMeters ?? this.radiusMeters,
      address: address ?? this.address,
      branchName: branchName ?? this.branchName,
    );
  }
}
