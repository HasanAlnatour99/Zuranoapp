import 'package:flutter/material.dart';

import '../../data/models/customer_booking_details_model.dart';

class CustomerBookingRescheduleScreen extends StatelessWidget {
  const CustomerBookingRescheduleScreen({
    super.key,
    required this.salonId,
    required this.bookingId,
    this.initialBooking,
  });

  final String salonId;
  final String bookingId;
  final CustomerBookingDetailsModel? initialBooking;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reschedule booking')),
      body: Center(
        child: Text(
          'Reschedule screen\nSalon: $salonId\nBooking: $bookingId',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
