import '../../l10n/app_localizations.dart';
import '../constants/booking_statuses.dart';

String localizedBookingStatus(AppLocalizations l10n, String status) {
  return switch (status) {
    BookingStatuses.pending => l10n.bookingStatusPending,
    BookingStatuses.confirmed => l10n.bookingStatusConfirmed,
    BookingStatuses.completed => l10n.bookingStatusCompleted,
    BookingStatuses.cancelled => l10n.bookingStatusCancelled,
    BookingStatuses.noShow => l10n.bookingStatusNoShow,
    BookingStatuses.rescheduled => l10n.bookingStatusRescheduled,
    _ => status,
  };
}
