import 'package:flutter/material.dart';

import '../constants/booking_operational_states.dart';
import '../constants/booking_statuses.dart';
import '../theme/app_spacing.dart';
import '../../features/bookings/data/models/booking.dart';
import '../../l10n/app_localizations.dart';

/// Day-of actions for confirmed bookings (Cloud Function–backed).
class BookingOperationsBar extends StatelessWidget {
  const BookingOperationsBar({
    super.key,
    required this.booking,
    required this.onMarkArrived,
    required this.onStartService,
    required this.onComplete,
    required this.onNoShowCustomer,
    required this.onNoShowBarber,
  });

  final Booking booking;
  final VoidCallback onMarkArrived;
  final VoidCallback onStartService;
  final VoidCallback onComplete;
  final VoidCallback onNoShowCustomer;
  final VoidCallback onNoShowBarber;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (booking.status != BookingStatuses.confirmed) {
      return const SizedBox.shrink();
    }
    final op = booking.operationalState;
    if (BookingOperationalStates.terminal.contains(op)) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.small),
      child: Wrap(
        spacing: AppSpacing.small,
        runSpacing: AppSpacing.small,
        children: [
          if (op == BookingOperationalStates.waiting) ...[
            TextButton(
              onPressed: onMarkArrived,
              child: Text(l10n.bookingOpMarkArrived),
            ),
            TextButton(
              onPressed: onNoShowCustomer,
              child: Text(l10n.bookingOpNoShowCustomer),
            ),
            TextButton(
              onPressed: onNoShowBarber,
              child: Text(l10n.bookingOpNoShowBarber),
            ),
          ],
          if (op == BookingOperationalStates.customerArrived)
            TextButton(
              onPressed: onStartService,
              child: Text(l10n.bookingOpStartService),
            ),
          if (op == BookingOperationalStates.serviceStarted)
            TextButton(
              onPressed: onComplete,
              child: Text(l10n.bookingOpComplete),
            ),
        ],
      ),
    );
  }
}
