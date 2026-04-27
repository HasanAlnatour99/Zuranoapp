import '../data/models/customer_booking_draft.dart';
import '../data/models/customer_booking_slot.dart';
import '../data/models/customer_team_member_public_model.dart';
import '../data/repositories/customer_booking_availability_repository.dart';

class CustomerSlotAvailabilityService {
  const CustomerSlotAvailabilityService(this._repository);

  final CustomerBookingAvailabilityRepository _repository;

  Future<List<CustomerBookingSlot>> generateSlots({
    required String salonId,
    required DateTime date,
    required CustomerBookingDraft draft,
    required List<CustomerTeamMemberPublicModel> teamMembers,
  }) async {
    if (!draft.hasServices || !draft.hasTeamSelection || teamMembers.isEmpty) {
      return const [];
    }

    final settings = await _repository.getBookingSettings(salonId);
    if (!settings.enabled) {
      return const [];
    }

    final workingHours = await _repository.getWorkingHours(
      salonId: salonId,
      date: date,
    );
    if (workingHours['open'] == false) {
      return const [];
    }

    final duration = draft.durationMinutes;
    final interval = settings.bookingSlotIntervalMinutes <= 0
        ? 30
        : settings.bookingSlotIntervalMinutes;
    if (duration <= 0) {
      return const [];
    }

    final day = DateTime(date.year, date.month, date.day);
    final openAt = _timeOnDate(day, '${workingHours['start'] ?? '09:00'}');
    final closeAt = _timeOnDate(day, '${workingHours['end'] ?? '21:00'}');
    if (openAt == null || closeAt == null || !closeAt.isAfter(openAt)) {
      return const [];
    }

    final now = DateTime.now();
    if (!settings.allowSameDayBooking && _isSameDay(day, now)) {
      return const [];
    }

    final earliestBookable = now.add(
      Duration(minutes: settings.minimumNoticeMinutes.clamp(0, 10080)),
    );

    final bookings = await _repository.getBookingsForDate(
      salonId: salonId,
      date: date,
    );
    final buffer = settings.bufferMinutes.clamp(0, 240);
    final slots = <CustomerBookingSlot>[];

    for (
      var start = openAt;
      !start.add(Duration(minutes: duration)).isAfter(closeAt);
      start = start.add(Duration(minutes: interval))
    ) {
      final end = start.add(Duration(minutes: duration));

      if (start.isBefore(earliestBookable)) {
        continue;
      }

      if (draft.anyAvailableEmployee) {
        final member = _firstAvailableTeamMember(
          teamMembers,
          bookings,
          buffer,
          start,
          end,
        );
        slots.add(
          CustomerBookingSlot(
            startAt: start,
            endAt: end,
            employeeId: member?.id,
            employeeName: member?.displayTitle,
            isAvailable: member != null,
            unavailableReason: member == null ? 'busy' : null,
          ),
        );
        continue;
      }

      final employeeId = draft.selectedEmployeeId;
      final employeeName = draft.selectedEmployeeName;
      if (employeeId == null || employeeId.trim().isEmpty) {
        continue;
      }
      final available = !_hasOverlap(bookings, buffer, employeeId, start, end);
      slots.add(
        CustomerBookingSlot(
          startAt: start,
          endAt: end,
          employeeId: employeeId,
          employeeName: employeeName,
          isAvailable: available,
          unavailableReason: available ? null : 'busy',
        ),
      );
    }

    return slots;
  }

  CustomerTeamMemberPublicModel? _firstAvailableTeamMember(
    List<CustomerTeamMemberPublicModel> teamMembers,
    List<Map<String, dynamic>> bookings,
    int bufferMinutes,
    DateTime start,
    DateTime end,
  ) {
    for (final member in teamMembers) {
      if (!_hasOverlap(bookings, bufferMinutes, member.id, start, end)) {
        return member;
      }
    }
    return null;
  }

  bool _hasOverlap(
    List<Map<String, dynamic>> bookings,
    int bufferMinutes,
    String employeeId,
    DateTime start,
    DateTime end,
  ) {
    final buffer = Duration(minutes: bufferMinutes);
    for (final booking in bookings) {
      if (booking['employeeId'] != employeeId) {
        continue;
      }
      final existingStart = booking['startAt'];
      final existingEnd = booking['endAt'];
      if (existingStart is! DateTime || existingEnd is! DateTime) {
        continue;
      }
      final existingEndBuffered = existingEnd.add(buffer);
      if (start.isBefore(existingEndBuffered) && end.isAfter(existingStart)) {
        return true;
      }
    }
    return false;
  }

  static DateTime? _timeOnDate(DateTime day, String raw) {
    final parts = raw.trim().split(':');
    if (parts.length < 2) {
      return null;
    }
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) {
      return null;
    }
    return DateTime(day.year, day.month, day.day, hour, minute);
  }

  static bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
