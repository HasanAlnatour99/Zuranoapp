import 'customer_booking_limits.dart';

/// Pure validation for the customer booking flow (no BuildContext / l10n).
abstract final class CustomerBookingValidator {
  static String? notesErrorIfInvalid(String notes) {
    if (notes.length <= CustomerBookingLimits.maxNotesLength) {
      return null;
    }
    return 'notes_too_long';
  }
}
