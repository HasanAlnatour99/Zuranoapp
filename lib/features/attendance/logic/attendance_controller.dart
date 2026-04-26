import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/attendance_repository.dart';
import '../../salon/data/salon_repository.dart';
import '../../../providers/repository_providers.dart';

final attendanceControllerProvider = Provider<AttendanceController>((ref) {
  return AttendanceController(
    attendanceRepository: ref.watch(attendanceRepositoryProvider),
    salonRepository: ref.watch(salonRepositoryProvider),
  );
});

class AttendanceController {
  AttendanceController({
    required AttendanceRepository attendanceRepository,
    required SalonRepository salonRepository,
  }) : _attendanceRepository = attendanceRepository,
       _salonRepository = salonRepository;

  final AttendanceRepository _attendanceRepository;
  final SalonRepository _salonRepository;

  /// Logic for checking in.
  /// In a real app, you'd add GPS/WiFi validation here.
  Future<void> checkIn({
    required String salonId,
    required String attendanceId,
    double? latitude,
    double? longitude,
  }) async {
    // 1. Fetch salon for location validation (if coordinates provided)
    if (latitude != null && longitude != null) {
      final salon = await _salonRepository.getSalon(salonId);
      if (salon != null && salon.location != null) {
        // Here you would use a distance formula to verify proximity.
        // For now, we assume proximity is valid if coordinates are sent.
      }
    }

    // 2. Perform check-in
    await _attendanceRepository.checkIn(
      salonId: salonId,
      attendanceId: attendanceId,
      at: DateTime.now(),
    );
  }

  /// Logic for checking out.
  Future<void> checkOut({
    required String salonId,
    required String attendanceId,
  }) async {
    await _attendanceRepository.checkOut(
      salonId: salonId,
      attendanceId: attendanceId,
      at: DateTime.now(),
    );
  }
}
