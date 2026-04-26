class EmployeeTodaySummaryModel {
  const EmployeeTodaySummaryModel({
    required this.servicesCount,
    required this.salesTotal,
    required this.commissionEstimate,
    required this.workedHoursLabel,
  });

  final int servicesCount;
  final double salesTotal;
  final double commissionEstimate;
  final String workedHoursLabel;

  static const empty = EmployeeTodaySummaryModel(
    servicesCount: 0,
    salesTotal: 0,
    commissionEstimate: 0,
    workedHoursLabel: '0.0',
  );
}
