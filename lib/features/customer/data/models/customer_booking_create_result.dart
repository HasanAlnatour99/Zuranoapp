class CustomerBookingCreateResult {
  const CustomerBookingCreateResult({
    required this.bookingId,
    required this.salonId,
    required this.customerId,
    required this.bookingCode,
    required this.status,
    required this.startAt,
    required this.endAt,
  });

  final String bookingId;
  final String salonId;
  final String customerId;
  final String bookingCode;
  final String status;
  final DateTime startAt;
  final DateTime endAt;
}
