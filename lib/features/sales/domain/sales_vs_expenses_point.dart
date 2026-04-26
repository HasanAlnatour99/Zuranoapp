/// One day in the Sales vs Expenses chart series.
class SalesVsExpensesPoint {
  const SalesVsExpensesPoint({
    required this.date,
    required this.salesTotal,
    required this.expensesTotal,
  });

  final DateTime date;
  final double salesTotal;
  final double expensesTotal;
}
