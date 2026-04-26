import '../../../core/constants/payroll_statuses.dart';
import '../../../core/constants/sale_reporting.dart';
import '../../expenses/data/models/expense.dart';
import '../../payroll/data/models/payroll_record.dart';
import '../../sales/data/models/sale.dart';
import 'owner_money_period.dart';

/// Cash vs accrual-style recognition for the Owner Money module (future UI).
enum OwnerMoneyRecognitionMode {
  /// Revenue and costs by activity / pay period (current default behavior).
  operational,

  /// Cash-oriented view: settlement-focused where data exists (`paidAt`, etc.).
  /// Sales still use [Sale.soldAt] until a dedicated collection timestamp exists.
  cash,
}

/// Aggregates Money tab numbers by [OwnerMoneyRecognitionMode] and
/// [OwnerMoneyPeriodKind]. Keeps today’s payroll rule unchanged for
/// [OwnerMoneyRecognitionMode.operational]; extends with cash variants for
/// future accrued payroll without changing the widget layout.
abstract final class OwnerMoneyAggregation {
  static bool saleInPeriod(
    Sale s,
    OwnerMoneyRecognitionMode mode,
    OwnerMoneyPeriodKind p,
    DateTime now,
  ) {
    return switch (mode) {
      OwnerMoneyRecognitionMode.operational => saleInOwnerMoneyPeriod(
        s,
        p,
        now,
      ),
      OwnerMoneyRecognitionMode.cash => _saleCash(s, p, now),
    };
  }

  static bool expenseInPeriod(
    Expense e,
    OwnerMoneyRecognitionMode mode,
    OwnerMoneyPeriodKind p,
    DateTime now,
  ) {
    return switch (mode) {
      OwnerMoneyRecognitionMode.operational => expenseInOwnerMoneyPeriod(
        e,
        p,
        now,
      ),
      OwnerMoneyRecognitionMode.cash => _expenseCash(e, p, now),
    };
  }

  static bool payrollInPeriod(
    PayrollRecord r,
    OwnerMoneyRecognitionMode mode,
    OwnerMoneyPeriodKind p,
    DateTime now,
  ) {
    return switch (mode) {
      OwnerMoneyRecognitionMode.operational => payrollInOwnerMoneyPeriod(
        r,
        p,
        now,
      ),
      OwnerMoneyRecognitionMode.cash => _payrollCash(r, p, now),
    };
  }

  static double sumSales(
    Iterable<Sale> sales,
    OwnerMoneyRecognitionMode mode,
    OwnerMoneyPeriodKind p,
    DateTime now,
  ) {
    return sales
        .where((s) => saleInPeriod(s, mode, p, now))
        .fold<double>(0, (a, s) => a + s.total);
  }

  static double sumPayroll(
    Iterable<PayrollRecord> rows,
    OwnerMoneyRecognitionMode mode,
    OwnerMoneyPeriodKind p,
    DateTime now,
  ) {
    return rows
        .where((r) => payrollInPeriod(r, mode, p, now))
        .fold<double>(0, (a, r) => a + r.netAmount);
  }

  static double sumExpenses(
    Iterable<Expense> rows,
    OwnerMoneyRecognitionMode mode,
    OwnerMoneyPeriodKind p,
    DateTime now,
  ) {
    return rows
        .where((e) => expenseInPeriod(e, mode, p, now))
        .fold<double>(0, (a, e) => a + e.amount);
  }

  /// Best-effort cash view for sales: completed revenue by [soldAt] calendar
  /// window. When [Sale] gains a payment-settled timestamp, switch this to that
  /// field for true cash recognition.
  static bool _saleCash(Sale s, OwnerMoneyPeriodKind p, DateTime now) {
    if (s.status != SaleStatuses.completed) {
      return false;
    }
    return switch (p) {
      OwnerMoneyPeriodKind.today => _sameLocalCalendarDay(s.soldAt, now),
      OwnerMoneyPeriodKind.month =>
        s.reportYear == now.year && s.reportMonth == now.month,
    };
  }

  static bool _expenseCash(Expense e, OwnerMoneyPeriodKind p, DateTime now) {
    // No `paidAt` on [Expense] yet; align with operational until paid expenses exist.
    return expenseInOwnerMoneyPeriod(e, p, now);
  }

  static bool _sameLocalCalendarDay(DateTime a, DateTime b) {
    final la = a.toLocal();
    final lb = b.toLocal();
    return la.year == lb.year && la.month == lb.month && la.day == lb.day;
  }

  static bool _payrollCash(
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
      OwnerMoneyPeriodKind.month => _payrollCashMonth(r, now),
    };
  }

  /// Cash month: amounts that were actually paid in the calendar month.
  static bool _payrollCashMonth(PayrollRecord r, DateTime now) {
    final paid = r.paidAt;
    if (paid == null) {
      return false;
    }
    final local = paid.toLocal();
    return local.year == now.year && local.month == now.month;
  }
}
