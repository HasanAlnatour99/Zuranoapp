import 'employee_sales_query.dart';

/// Binds digest cache + AI refresh to history range and employee — not to every KPI tick.
class TeamSalesInsightRequest {
  const TeamSalesInsightRequest({
    required this.query,
    required this.historyStart,
    required this.historyEndExclusive,
  });

  final EmployeeSalesQuery query;
  final DateTime historyStart;
  final DateTime historyEndExclusive;

  @override
  bool operator ==(Object other) {
    return other is TeamSalesInsightRequest &&
        other.query == query &&
        other.historyStart == historyStart &&
        other.historyEndExclusive == historyEndExclusive;
  }

  @override
  int get hashCode => Object.hash(query, historyStart, historyEndExclusive);
}
