class CustomerBookingSlot {
  const CustomerBookingSlot({
    required this.startAt,
    required this.endAt,
    this.employeeId,
    this.employeeName,
    required this.isAvailable,
    this.unavailableReason,
  });

  final DateTime startAt;
  final DateTime endAt;
  final String? employeeId;
  final String? employeeName;
  final bool isAvailable;
  final String? unavailableReason;
}
