import 'booking_slot_exception.dart';

/// UTC grid alignment for barber bookings (15 or 30 minutes).
abstract final class BookingSlots {
  static const supportedSteps = [15, 30];

  static void assertAllowedStep(int slotStepMinutes) {
    if (!supportedSteps.contains(slotStepMinutes)) {
      throw BookingSlotException(
        'slotStepMinutes must be one of: ${supportedSteps.join(", ")}.',
      );
    }
  }

  /// [start] and [end] must fall on UTC slot boundaries; duration must be a
  /// positive multiple of [slotStepMinutes].
  static void assertUtcSlotRange(
    DateTime start,
    DateTime end,
    int slotStepMinutes,
  ) {
    assertAllowedStep(slotStepMinutes);
    final su = start.toUtc();
    final eu = end.toUtc();
    if (!eu.isAfter(su)) {
      throw BookingSlotException('endAt must be after startAt.');
    }
    if (!_isUtcAligned(su, slotStepMinutes) ||
        !_isUtcAligned(eu, slotStepMinutes)) {
      throw BookingSlotException(
        'startAt and endAt must align to $slotStepMinutes-minute UTC slots.',
      );
    }
    final durationMin = eu.difference(su).inMinutes;
    if (durationMin % slotStepMinutes != 0) {
      throw BookingSlotException(
        'Booking duration must be a multiple of $slotStepMinutes minutes.',
      );
    }
  }

  static bool _isUtcAligned(DateTime utc, int slotStepMinutes) {
    if (utc.microsecond != 0 || utc.millisecond != 0) {
      return false;
    }
    final midnight = DateTime.utc(utc.year, utc.month, utc.day);
    final minutes = utc.difference(midnight).inMinutes;
    return minutes % slotStepMinutes == 0;
  }
}
