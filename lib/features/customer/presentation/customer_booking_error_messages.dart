import '../../../l10n/app_localizations.dart';
import '../domain/customer_booking_limits.dart';

String customerBookingSubmissionMessage(AppLocalizations l10n, String? code) {
  return switch (code) {
    'incomplete' => l10n.customerBookingIncomplete,
    'not_authenticated' => l10n.customerBookingSignInRequired,
    'notes_too_long' => l10n.customerBookingNotesTooLong(
      CustomerBookingLimits.maxNotesLength,
    ),
    'time_overlap' => l10n.customerBookingSlotTaken,
    'slot_invalid' => l10n.customerBookingSlotInvalid,
    'unknown' => l10n.genericError,
    _ => '',
  };
}
