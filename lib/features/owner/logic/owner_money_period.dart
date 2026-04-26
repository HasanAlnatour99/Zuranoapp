import '../../../core/constants/payroll_statuses.dart';
import '../../../core/constants/sale_reporting.dart';
import '../../expenses/data/models/expense.dart';
import '../../payroll/data/models/payroll_record.dart';
import '../../sales/data/models/sale.dart';

/// Money tab period filter (custom range reserved for a later release).
enum OwnerMoneyPeriodKind { today, month }

bool _sameLocalCalendarDay(DateTime a, DateTime b) {
  final la = a.toLocal();
  final lb = b.toLocal();
  return la.year == lb.year && la.month == lb.month && la.day == lb.day;
}

bool _saleCountsAsRevenue(Sale s) {
  return s.status == SaleStatuses.completed;
}

bool saleInOwnerMoneyPeriod(Sale s, OwnerMoneyPeriodKind p, DateTime now) {
  if (!_saleCountsAsRevenue(s)) {
    return false;
  }
  return switch (p) {
    OwnerMoneyPeriodKind.today => _sameLocalCalendarDay(s.soldAt, now),
    OwnerMoneyPeriodKind.month =>
      s.reportYear == now.year && s.reportMonth == now.month,
  };
}

bool expenseInOwnerMoneyPeriod(
  Expense e,
  OwnerMoneyPeriodKind p,
  DateTime now,
) {
  return switch (p) {
    OwnerMoneyPeriodKind.today => _sameLocalCalendarDay(e.incurredAt, now),
    OwnerMoneyPeriodKind.month =>
      e.reportYear == now.year && e.reportMonth == now.month,
  };
}

bool payrollInOwnerMoneyPeriod(
  PayrollRecord r,
  OwnerMoneyPeriodKind p,
  DateTime now,
) {
  if (r.status == PayrollStatuses.voided) {
    return false;
  }
  return switch (p) {
    OwnerMoneyPeriodKind.today =>
      r.paidAt != null && _sameLocalCalendarDay(r.paidAt!, now),
    OwnerMoneyPeriodKind.month => r.year == now.year && r.month == now.month,
  };
}

double sumSales(Iterable<Sale> sales, OwnerMoneyPeriodKind p, DateTime now) {
  return sales
      .where((s) => saleInOwnerMoneyPeriod(s, p, now))
      .fold<double>(0, (a, s) => a + s.total);
}

double sumPayroll(
  Iterable<PayrollRecord> rows,
  OwnerMoneyPeriodKind p,
  DateTime now,
) {
  return rows
      .where((r) => payrollInOwnerMoneyPeriod(r, p, now))
      .fold<double>(0, (a, r) => a + r.netAmount);
}

double sumExpenses(
  Iterable<Expense> rows,
  OwnerMoneyPeriodKind p,
  DateTime now,
) {
  return rows
      .where((e) => expenseInOwnerMoneyPeriod(e, p, now))
      .fold<double>(0, (a, e) => a + e.amount);
}
