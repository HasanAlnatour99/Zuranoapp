import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/salon_streams_provider.dart';
import '../../expenses/data/models/expense.dart';
import '../../payroll/data/models/payroll_record.dart';
import '../../sales/data/models/sale.dart';

enum MoneyInsightKind { topBarber, topService, largestExpenseCategory }

class MoneyMonthSelection extends Notifier<DateTime> {
  @override
  DateTime build() {
    final now = DateTime.now();
    return DateTime(now.year, now.month);
  }

  void selectMonth(DateTime month) {
    state = DateTime(month.year, month.month);
  }
}

final moneySelectedMonthProvider =
    NotifierProvider<MoneyMonthSelection, DateTime>(MoneyMonthSelection.new);

final moneyMonthOptionsProvider = Provider<List<DateTime>>((ref) {
  final now = DateTime.now();
  return List<DateTime>.generate(
    6,
    (index) => DateTime(now.year, now.month - index),
    growable: false,
  );
});

class MoneyLeaderboardEntry {
  const MoneyLeaderboardEntry({
    required this.id,
    required this.label,
    required this.amount,
  });

  final String id;
  final String label;
  final double amount;
}

class MoneyCategoryBreakdown {
  const MoneyCategoryBreakdown({
    required this.category,
    required this.amount,
    required this.share,
  });

  final String category;
  final double amount;
  final double share;
}

class MoneyDashboardInsight {
  const MoneyDashboardInsight({
    required this.kind,
    required this.label,
    required this.value,
    this.amount,
  });

  final MoneyInsightKind kind;
  final String label;
  final String value;
  final double? amount;
}

class MoneyTrendPoint {
  const MoneyTrendPoint({
    required this.date,
    required this.sales,
    required this.expenses,
  });

  final DateTime date;
  final double sales;
  final double expenses;
}

class MoneyDashboardSummary {
  const MoneyDashboardSummary({
    required this.month,
    required this.salesTotal,
    required this.expensesTotal,
    required this.payrollTotal,
    required this.netProfit,
    required this.topBarber,
    required this.topService,
    required this.categoryBreakdown,
  });

  final DateTime month;
  final double salesTotal;
  final double expensesTotal;
  final double payrollTotal;
  final double netProfit;
  final MoneyLeaderboardEntry? topBarber;
  final MoneyLeaderboardEntry? topService;
  final List<MoneyCategoryBreakdown> categoryBreakdown;
}

/// Builds [MoneyDashboardSummary] for a calendar month from raw streams.
MoneyDashboardSummary buildMoneyDashboardSummaryForMonth({
  required Iterable<Sale> sales,
  required Iterable<Expense> expenses,
  required Iterable<PayrollRecord> payroll,
  required DateTime month,
}) {
  final mSales = sales.where((sale) {
    return sale.reportYear == month.year && sale.reportMonth == month.month;
  });
  final mExpenses = expenses.where((expense) {
    return expense.reportYear == month.year &&
        expense.reportMonth == month.month;
  });
  final mPayroll = payroll.where((record) {
    return record.year == month.year && record.month == month.month;
  });

  final salesTotal = mSales.fold<double>(0, (sum, sale) => sum + sale.total);
  final expensesTotal = mExpenses.fold<double>(
    0,
    (sum, expense) => sum + expense.amount,
  );
  final payrollTotal = mPayroll.fold<double>(
    0,
    (sum, record) => sum + record.netAmount,
  );

  return MoneyDashboardSummary(
    month: month,
    salesTotal: salesTotal,
    expensesTotal: expensesTotal,
    payrollTotal: payrollTotal,
    netProfit: salesTotal - expensesTotal - payrollTotal,
    topBarber: _computeTopBarber(mSales),
    topService: _computeTopService(mSales),
    categoryBreakdown: _buildCategoryBreakdown(mExpenses),
  );
}

final totalSalesTodayProvider = Provider<double>((ref) {
  final sales = ref.watch(salesStreamProvider).asData?.value ?? const <Sale>[];
  final today = DateUtils.dateOnly(DateTime.now());
  return sales
      .where((sale) => _isSameDay(sale.soldAt, today))
      .fold<double>(0, (sum, sale) => sum + sale.total);
});

final totalSalesThisMonthProvider = Provider<double>((ref) {
  final sales = ref.watch(salesStreamProvider).asData?.value ?? const <Sale>[];
  final now = DateTime.now();
  return sales
      .where(
        (sale) => sale.reportYear == now.year && sale.reportMonth == now.month,
      )
      .fold<double>(0, (sum, sale) => sum + sale.total);
});

final totalExpensesThisMonthProvider = Provider<double>((ref) {
  final expenses =
      ref.watch(expensesStreamProvider).asData?.value ?? const <Expense>[];
  final now = DateTime.now();
  return expenses
      .where(
        (expense) =>
            expense.reportYear == now.year && expense.reportMonth == now.month,
      )
      .fold<double>(0, (sum, expense) => sum + expense.amount);
});

final salonTotalCommissionTodayProvider = Provider<double>((ref) {
  final sales = ref.watch(salesStreamProvider).asData?.value ?? const <Sale>[];
  final today = DateUtils.dateOnly(DateTime.now());
  return sales
      .where((sale) => _isSameDay(sale.soldAt, today))
      .fold<double>(0, (sum, sale) => sum + (sale.commissionAmount ?? 0));
});

final salonTotalCommissionMonthProvider = Provider<double>((ref) {
  final sales = ref.watch(salesStreamProvider).asData?.value ?? const <Sale>[];
  final now = DateTime.now();
  return sales
      .where(
        (sale) => sale.reportYear == now.year && sale.reportMonth == now.month,
      )
      .fold<double>(0, (sum, sale) => sum + (sale.commissionAmount ?? 0));
});

final expenseCategoryBreakdownProvider = Provider<List<MoneyCategoryBreakdown>>(
  (ref) {
    final expenses =
        ref.watch(expensesStreamProvider).asData?.value ?? const <Expense>[];
    final now = DateTime.now();
    return _buildCategoryBreakdown(
      expenses.where(
        (expense) =>
            expense.reportYear == now.year && expense.reportMonth == now.month,
      ),
    );
  },
);

final topBarberProvider = Provider<MoneyLeaderboardEntry?>((ref) {
  final sales = ref.watch(salesStreamProvider).asData?.value ?? const <Sale>[];
  final now = DateTime.now();
  return _computeTopBarber(
    sales.where(
      (sale) => sale.reportYear == now.year && sale.reportMonth == now.month,
    ),
  );
});

final topServiceProvider = Provider<MoneyLeaderboardEntry?>((ref) {
  final sales = ref.watch(salesStreamProvider).asData?.value ?? const <Sale>[];
  final now = DateTime.now();
  return _computeTopService(
    sales.where(
      (sale) => sale.reportYear == now.year && sale.reportMonth == now.month,
    ),
  );
});

final netProfitThisMonthProvider = Provider<double>((ref) {
  final sales = ref.watch(totalSalesThisMonthProvider);
  final expenses = ref.watch(totalExpensesThisMonthProvider);
  final payroll = ref.watch(_currentMonthPayrollTotalProvider);
  return sales - expenses - payroll;
});

final moneyDashboardSummaryProvider =
    Provider<AsyncValue<MoneyDashboardSummary>>((ref) {
      final salesAsync = ref.watch(salesStreamProvider);
      final expensesAsync = ref.watch(expensesStreamProvider);
      final payrollAsync = ref.watch(payrollStreamProvider);
      final month = ref.watch(moneySelectedMonthProvider);

      return _combineAsyncValues<MoneyDashboardSummary>(
        [salesAsync, expensesAsync, payrollAsync],
        () {
          return buildMoneyDashboardSummaryForMonth(
            sales: salesAsync.requireValue,
            expenses: expensesAsync.requireValue,
            payroll: payrollAsync.requireValue,
            month: month,
          );
        },
      );
    });

/// Prior month totals for KPI trend copy (vs Mar, etc.).
final moneyPreviousMonthSummaryProvider =
    Provider<AsyncValue<MoneyDashboardSummary>>((ref) {
      final salesAsync = ref.watch(salesStreamProvider);
      final expensesAsync = ref.watch(expensesStreamProvider);
      final payrollAsync = ref.watch(payrollStreamProvider);
      final month = ref.watch(moneySelectedMonthProvider);
      final previous = DateTime(month.year, month.month - 1);

      return _combineAsyncValues<MoneyDashboardSummary>(
        [salesAsync, expensesAsync, payrollAsync],
        () {
          return buildMoneyDashboardSummaryForMonth(
            sales: salesAsync.requireValue,
            expenses: expensesAsync.requireValue,
            payroll: payrollAsync.requireValue,
            month: previous,
          );
        },
      );
    });

final moneyTrendSeriesProvider = Provider<AsyncValue<List<MoneyTrendPoint>>>((
  ref,
) {
  final salesAsync = ref.watch(salesStreamProvider);
  final expensesAsync = ref.watch(expensesStreamProvider);
  final month = ref.watch(moneySelectedMonthProvider);

  return _combineAsyncValues<List<MoneyTrendPoint>>(
    [salesAsync, expensesAsync],
    () {
      final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
      final salesByDay = <DateTime, double>{};
      final expensesByDay = <DateTime, double>{};

      for (final sale in salesAsync.requireValue) {
        if (sale.reportYear != month.year || sale.reportMonth != month.month) {
          continue;
        }
        final day = DateUtils.dateOnly(sale.soldAt.toLocal());
        salesByDay.update(
          day,
          (value) => value + sale.total,
          ifAbsent: () => sale.total,
        );
      }

      for (final expense in expensesAsync.requireValue) {
        if (expense.reportYear != month.year ||
            expense.reportMonth != month.month) {
          continue;
        }
        final day = DateUtils.dateOnly(expense.incurredAt.toLocal());
        expensesByDay.update(
          day,
          (value) => value + expense.amount,
          ifAbsent: () => expense.amount,
        );
      }

      return List<MoneyTrendPoint>.generate(daysInMonth, (index) {
        final date = DateTime(month.year, month.month, index + 1);
        return MoneyTrendPoint(
          date: date,
          sales: salesByDay[date] ?? 0,
          expenses: expensesByDay[date] ?? 0,
        );
      }, growable: false);
    },
  );
});

final moneyInsightsProvider = Provider<AsyncValue<List<MoneyDashboardInsight>>>(
  (ref) {
    final summaryAsync = ref.watch(moneyDashboardSummaryProvider);
    return summaryAsync.whenData((summary) {
      final insights = <MoneyDashboardInsight>[];
      if (summary.topBarber != null && summary.topBarber!.amount > 0) {
        insights.add(
          MoneyDashboardInsight(
            kind: MoneyInsightKind.topBarber,
            label: summary.topBarber!.label,
            value: summary.topBarber!.amount.toStringAsFixed(0),
            amount: summary.topBarber!.amount,
          ),
        );
      }
      if (summary.topService != null && summary.topService!.amount > 0) {
        insights.add(
          MoneyDashboardInsight(
            kind: MoneyInsightKind.topService,
            label: summary.topService!.label,
            value: summary.topService!.amount.toStringAsFixed(0),
            amount: summary.topService!.amount,
          ),
        );
      }
      if (summary.categoryBreakdown.isNotEmpty) {
        final first = summary.categoryBreakdown.first;
        insights.add(
          MoneyDashboardInsight(
            kind: MoneyInsightKind.largestExpenseCategory,
            label: first.category,
            value: '${(first.share * 100).round()}%',
            amount: first.amount,
          ),
        );
      }
      return insights.take(3).toList(growable: false);
    });
  },
);

final _currentMonthPayrollTotalProvider = Provider<double>((ref) {
  final payroll =
      ref.watch(payrollStreamProvider).asData?.value ?? const <PayrollRecord>[];
  final now = DateTime.now();
  return payroll
      .where((record) => record.year == now.year && record.month == now.month)
      .fold<double>(0, (sum, record) => sum + record.netAmount);
});

AsyncValue<T> _combineAsyncValues<T>(
  List<AsyncValue<dynamic>> values,
  T Function() builder,
) {
  for (final value in values) {
    final error = value.asError;
    if (error != null) {
      return AsyncValue.error(error.error, error.stackTrace);
    }
  }
  if (values.any((value) => value.isLoading && !value.hasValue)) {
    return const AsyncValue.loading();
  }
  return AsyncValue.data(builder());
}

MoneyLeaderboardEntry? _computeTopBarber(Iterable<Sale> sales) {
  final totals = <String, MoneyLeaderboardEntry>{};
  for (final sale in sales) {
    final id = sale.employeeId.trim().isNotEmpty
        ? sale.employeeId
        : sale.barberId;
    if (id.isEmpty) continue;
    final current = totals[id];
    totals[id] = MoneyLeaderboardEntry(
      id: id,
      label: sale.employeeName.trim().isEmpty ? id : sale.employeeName,
      amount: (current?.amount ?? 0) + sale.total,
    );
  }
  if (totals.isEmpty) return null;
  return totals.values.reduce((best, next) {
    if (next.amount > best.amount) return next;
    return best;
  });
}

MoneyLeaderboardEntry? _computeTopService(Iterable<Sale> sales) {
  final totals = <String, MoneyLeaderboardEntry>{};
  for (final sale in sales) {
    if (sale.lineItems.isEmpty) {
      final label = sale.serviceNames.isEmpty ? '' : sale.serviceNames.first;
      if (label.isEmpty) continue;
      final current = totals[label];
      totals[label] = MoneyLeaderboardEntry(
        id: label,
        label: label,
        amount: (current?.amount ?? 0) + sale.total,
      );
      continue;
    }
    for (final line in sale.lineItems) {
      final key = line.serviceId.trim().isEmpty
          ? line.serviceName
          : line.serviceId;
      if (key.isEmpty) continue;
      final current = totals[key];
      totals[key] = MoneyLeaderboardEntry(
        id: key,
        label: line.serviceName,
        amount: (current?.amount ?? 0) + line.total,
      );
    }
  }
  if (totals.isEmpty) return null;
  return totals.values.reduce((best, next) {
    if (next.amount > best.amount) return next;
    return best;
  });
}

List<MoneyCategoryBreakdown> _buildCategoryBreakdown(
  Iterable<Expense> expenses,
) {
  final totals = <String, double>{};
  var overall = 0.0;
  for (final expense in expenses) {
    final category = expense.category.trim();
    overall += expense.amount;
    totals.update(
      category,
      (value) => value + expense.amount,
      ifAbsent: () => expense.amount,
    );
  }
  final rows =
      totals.entries
          .map(
            (entry) => MoneyCategoryBreakdown(
              category: entry.key,
              amount: entry.value,
              share: overall <= 0 ? 0 : entry.value / overall,
            ),
          )
          .toList(growable: false)
        ..sort((a, b) => b.amount.compareTo(a.amount));
  return rows;
}

bool _isSameDay(DateTime value, DateTime day) {
  final local = value.toLocal();
  return local.year == day.year &&
      local.month == day.month &&
      local.day == day.day;
}
