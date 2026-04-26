import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/firestore/firestore_paths.dart';
import '../models/customer_booking_settings.dart';

abstract class CustomerBookingAvailabilityRepository {
  Future<CustomerBookingSettings> getBookingSettings(String salonId);

  Future<List<Map<String, dynamic>>> getBookingsForDate({
    required String salonId,
    required DateTime date,
    String? excludeBookingId,
  });

  Future<Map<String, dynamic>> getWorkingHours({
    required String salonId,
    required DateTime date,
  });
}

class FirestoreCustomerBookingAvailabilityRepository
    implements CustomerBookingAvailabilityRepository {
  FirestoreCustomerBookingAvailabilityRepository(this._firestore);

  final FirebaseFirestore _firestore;

  static const _blockingStatuses = {
    'pending',
    'confirmed',
    'checkedIn',
    'checked_in',
  };

  @override
  Future<CustomerBookingSettings> getBookingSettings(String salonId) async {
    final doc = await _firestore.doc(FirestorePaths.publicSalon(salonId)).get();
    final data = doc.data();
    final raw = data?['customerBookingSettings'];
    return CustomerBookingSettings.fromMap(
      raw is Map<String, dynamic> ? raw : null,
    );
  }

  @override
  Future<List<Map<String, dynamic>>> getBookingsForDate({
    required String salonId,
    required DateTime date,
    String? excludeBookingId,
  }) async {
    final day = DateTime(date.year, date.month, date.day);
    final start = Timestamp.fromDate(day);
    final end = Timestamp.fromDate(day.add(const Duration(days: 1)));

    final snap = await _firestore
        .collection(FirestorePaths.salonBookings(salonId))
        .where('startAt', isGreaterThanOrEqualTo: start)
        .where('startAt', isLessThan: end)
        .get();

    return snap.docs
        .where((doc) => excludeBookingId == null || doc.id != excludeBookingId)
        .map((doc) => doc.data())
        .where((data) {
          final status = '${data['status'] ?? ''}'.trim();
          return _blockingStatuses.contains(status);
        })
        .map((data) {
          final employeeId =
              (data['employeeId'] as String?) ?? (data['barberId'] as String?);
          final employeeName =
              (data['employeeName'] as String?) ??
              (data['barberName'] as String?);
          return <String, dynamic>{
            'employeeId': employeeId,
            'employeeName': employeeName,
            'startAt': _dateTime(data['startAt']),
            'endAt': _dateTime(data['endAt']),
            'status': data['status'],
          };
        })
        .where((data) => data['startAt'] != null && data['endAt'] != null)
        .toList(growable: false);
  }

  @override
  Future<Map<String, dynamic>> getWorkingHours({
    required String salonId,
    required DateTime date,
  }) async {
    final doc = await _firestore.doc(FirestorePaths.publicSalon(salonId)).get();
    final data = doc.data();
    final workingHours = data?['workingHours'];
    final key = _weekdayKey(date.weekday);
    if (workingHours is Map<String, dynamic>) {
      final day = workingHours[key];
      if (day is Map<String, dynamic>) {
        return day;
      }
    }
    return const {'open': true, 'start': '09:00', 'end': '21:00'};
  }

  static DateTime? _dateTime(Object? value) {
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    return null;
  }

  static String _weekdayKey(int weekday) {
    return switch (weekday) {
      DateTime.monday => 'monday',
      DateTime.tuesday => 'tuesday',
      DateTime.wednesday => 'wednesday',
      DateTime.thursday => 'thursday',
      DateTime.friday => 'friday',
      DateTime.saturday => 'saturday',
      DateTime.sunday => 'sunday',
      _ => 'monday',
    };
  }
}
