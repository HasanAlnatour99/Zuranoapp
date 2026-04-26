import '../booking/invalid_booking_status_transition_exception.dart';
import 'booking_statuses.dart';

/// Allowed [BookingStatuses] transitions:
/// - [BookingStatuses.pending] → [BookingStatuses.confirmed] | [BookingStatuses.cancelled]
/// - [BookingStatuses.confirmed] → [BookingStatuses.completed] | [BookingStatuses.cancelled] | [BookingStatuses.noShow]
///
/// Terminal: [BookingStatuses.completed], [BookingStatuses.cancelled], [BookingStatuses.noShow].
abstract final class BookingStatusMachine {
  static const Set<String> _all = {
    BookingStatuses.pending,
    BookingStatuses.confirmed,
    BookingStatuses.completed,
    BookingStatuses.cancelled,
    BookingStatuses.noShow,
    BookingStatuses.rescheduled,
  };

  static final Map<String, Set<String>> _edges = {
    BookingStatuses.pending: {
      BookingStatuses.confirmed,
      BookingStatuses.cancelled,
      BookingStatuses.rescheduled,
    },
    BookingStatuses.confirmed: {
      BookingStatuses.completed,
      BookingStatuses.cancelled,
      BookingStatuses.noShow,
      BookingStatuses.rescheduled,
    },
  };

  /// Normalizes Firestore values for the state machine (legacy `scheduled` → [BookingStatuses.pending]).
  static String normalize(String? raw) {
    final s = raw?.trim() ?? '';
    if (s.isEmpty || s == 'scheduled') {
      return BookingStatuses.pending;
    }
    return s;
  }

  static bool isKnownStatus(String status) => _all.contains(status);

  /// Whether [toStatus] can be reached from [fromStatus] (after [normalize]).
  /// Same status returns `true` (no-op).
  static bool canTransition(String? fromRaw, String? toRaw) {
    final from = normalize(fromRaw);
    final to = normalize(toRaw);
    if (from == to) {
      return true;
    }
    if (!isKnownStatus(from) || !isKnownStatus(to)) {
      return false;
    }
    final outs = _edges[from];
    return outs != null && outs.contains(to);
  }

  /// Throws [InvalidBookingStatusTransitionException] if the transition is not allowed.
  static void assertTransition(String? fromRaw, String? toRaw) {
    final from = normalize(fromRaw);
    final to = normalize(toRaw);
    if (from == to) {
      return;
    }
    if (!isKnownStatus(from) || !isKnownStatus(to)) {
      throw ArgumentError.value(
        toRaw,
        'status',
        'Unknown booking status after normalization (from: $from, to: $to).',
      );
    }
    if (!canTransition(from, to)) {
      throw InvalidBookingStatusTransitionException(from, to);
    }
  }
}
