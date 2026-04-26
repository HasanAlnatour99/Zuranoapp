class EmployeeSalesSummary {
  const EmployeeSalesSummary({
    required this.totalAmount,
    required this.servicesCount,
    required this.estimatedCommission,
    required this.averageServiceValue,
    required this.uniqueCustomersCount,
  });

  final double totalAmount;
  final int servicesCount;
  final double estimatedCommission;
  final double averageServiceValue;
  final int uniqueCustomersCount;

  static const empty = EmployeeSalesSummary(
    totalAmount: 0,
    servicesCount: 0,
    estimatedCommission: 0,
    averageServiceValue: 0,
    uniqueCustomersCount: 0,
  );
}
