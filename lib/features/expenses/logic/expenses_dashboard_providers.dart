import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/salon_streams_provider.dart';
import '../data/models/expense.dart';
import '../domain/expense_filter_state.dart';
import '../domain/expense_summary.dart';

export '../domain/expense_filter_state.dart';
export '../domain/expense_summary.dart';

List<Expense> applyExpenseFilters(
  List<Expense> expenses,
  ExpensesFilterState filters,
) {
  final rows =
      expenses
          .where((expense) {
            if (expense.isDeleted) return false;
            if (filters.category != null &&
                filters.category!.trim().isNotEmpty &&
                expense.category != filters.category) {
              return false;
            }
            if (filters.paymentMethod != null &&
                filters.paymentMethod!.trim().isNotEmpty &&
                expense.paymentMethod != filters.paymentMethod) {
              return false;
            }
            if (filters.createdByUid != null &&
                filters.createdByUid!.trim().isNotEmpty &&
                expense.createdByUid != filters.createdByUid) {
              return false;
            }
            return _matchesDatePreset(expense.incurredAt, filters);
          })
          .toList(growable: false)
        ..sort((a, b) => b.incurredAt.compareTo(a.incurredAt));
  return rows;
}

final expensesCategoryOptionsProvider = Provider<List<String>>((ref) {
  final expenses =
      ref.watch(expensesStreamProvider).asData?.value ?? const <Expense>[];
  final categories =
      expenses
          .where((e) => !e.isDeleted)
          .map((expense) => expense.category.trim())
          .where((value) => value.isNotEmpty)
          .toSet()
          .toList(growable: false)
        ..sort();
  return categories;
});

/// Distinct creators for the expense filters sheet (from loaded expenses).
final expenseCreatedByFilterOptionsProvider =
    Provider<List<({String uid, String name})>>((ref) {
      final expenses =
          ref.watch(expensesStreamProvider).asData?.value ?? const <Expense>[];
      final map = <String, String>{};
      for (final e in expenses) {
        if (e.isDeleted) continue;
        final uid = e.createdByUid.trim();
        if (uid.isEmpty) continue;
        final name = e.createdByName.trim();
        map[uid] = name.isEmpty ? uid : name;
      }
      return map.entries
          .map((e) => (uid: e.key, name: e.value))
          .toList(growable: false);
    });

final expensePaymentMethodOptionsProvider = Provider<List<String>>((ref) {
  final expenses =
      ref.watch(expensesStreamProvider).asData?.value ?? const <Expense>[];
  final methods =
      expenses
          .where((e) => !e.isDeleted)
          .map((expense) => expense.paymentMethod.trim())
          .where((value) => value.isNotEmpty)
          .toSet()
          .toList(growable: false)
        ..sort();
  return methods;
});

final filteredExpensesProvider = Provider<AsyncValue<List<Expense>>>((ref) {
  final expensesAsync = ref.watch(expensesStreamProvider);
  final filters = ref.watch(expensesFiltersProvider);

  return expensesAsync.whenData(
    (expenses) => applyExpenseFilters(expenses, filters),
  );
});

/// Latest three expenses in the current filter window (for dashboard card).
final recentFilteredExpensesProvider = Provider<AsyncValue<List<Expense>>>((
  ref,
) {
  final filteredAsync = ref.watch(filteredExpensesProvider);
  return filteredAsync.whenData((list) => list.take(3).toList(growable: false));
});

final groupedExpensesListProvider =
    Provider<AsyncValue<List<GroupedExpensesDay>>>((ref) {
      final filteredAsync = ref.watch(filteredExpensesProvider);
      return filteredAsync.whenData((expenses) {
        final grouped = <DateTime, List<Expense>>{};
        for (final expense in expenses) {
          final key = DateUtils.dateOnly(expense.incurredAt.toLocal());
          grouped.putIfAbsent(key, () => <Expense>[]).add(expense);
        }
        final rows =
            grouped.entries
                .map(
                  (entry) => GroupedExpensesDay(
                    date: entry.key,
                    expenses: entry.value,
                    total: entry.value.fold<double>(
                      0,
                      (sum, expense) => sum + expense.amount,
                    ),
                  ),
                )
                .toList(growable: false)
              ..sort((a, b) => b.date.compareTo(a.date));
        return rows;
      });
    });

final expenseCategoryBreakdownBarsProvider =
    Provider<AsyncValue<List<ExpenseCategoryBar>>>((ref) {
      final filteredAsync = ref.watch(filteredExpensesProvider);
      return filteredAsync.whenData((expenses) {
        final totals = <String, double>{};
        var overall = 0.0;
        for (final expense in expenses) {
          final category = expense.category.trim();
          final label = category.isEmpty ? '' : category;
          totals.update(
            label,
            (value) => value + expense.amount,
            ifAbsent: () => expense.amount,
          );
          overall += expense.amount;
        }
        final rows =
            totals.entries
                .map(
                  (entry) => ExpenseCategoryBar(
                    category: entry.key,
                    amount: entry.value,
                    progress: overall <= 0 ? 0 : entry.value / overall,
                  ),
                )
                .toList(growable: false)
              ..sort((a, b) => b.amount.compareTo(a.amount));
        return rows;
      });
    });

const List<Color> _categoryBarPalette = [
  Color(0xFF7C3AED),
  Color(0xFF8B5CF6),
  Color(0xFFA78BFA),
  Color(0xFFC4B5FD),
  Color(0xFFDDD6FE),
];

final expenseCategoryBreakdownUiRowsProvider =
    Provider<AsyncValue<List<ExpenseCategoryBreakdownUiRow>>>((ref) {
      final barsAsync = ref.watch(expenseCategoryBreakdownBarsProvider);
      final filteredAsync = ref.watch(filteredExpensesProvider);
      return barsAsync.when(
        loading: () => const AsyncValue.loading(),
        error: (e, st) => AsyncValue.error(e, st),
        data: (bars) {
          final total =
              filteredAsync.asData?.value.fold<double>(
                0,
                (s, e) => s + e.amount,
              ) ??
              0;
          if (bars.isEmpty || total <= 0) {
            return const AsyncValue.data(<ExpenseCategoryBreakdownUiRow>[]);
          }
          final rows = <ExpenseCategoryBreakdownUiRow>[];
          for (var i = 0; i < bars.length; i++) {
            final b = bars[i];
            final pct = (b.amount / total) * 100;
            rows.add(
              ExpenseCategoryBreakdownUiRow(
                categoryLabel: b.category,
                amount: b.amount,
                percentOfTotal: pct,
                progress: b.progress,
                barColor: _categoryBarPalette[i % _categoryBarPalette.length],
              ),
            );
          }
          return AsyncValue.data(rows);
        },
      );
    });

final expensesSummaryProvider = Provider<AsyncValue<ExpensesSummary>>((ref) {
  final expensesAsync = ref.watch(expensesStreamProvider);
  final filters = ref.watch(expensesFiltersProvider);

  return expensesAsync.when(
    loading: () => const AsyncValue.loading(),
    error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
    data: (all) {
      final active = all.where((e) => !e.isDeleted).toList(growable: false);
      final expenses = applyExpenseFilters(active, filters);
      final total = expenses.fold<double>(
        0,
        (sum, expense) => sum + expense.amount,
      );
      final top = _topCategoryEntry(expenses);
      final avg = expenses.isEmpty ? null : total / expenses.length;
      final highest = expenses.isEmpty
          ? null
          : expenses.map((e) => e.amount).reduce(math.max);
      final trend = _expenseTrendVsPriorComparableWindow(active, filters);

      return AsyncValue.data(
        ExpensesSummary(
          total: total,
          expenseCount: expenses.length,
          topCategory: top?.label,
          topCategoryAmount: top?.amount,
          topCategoryPercentOfTotal: top == null || total <= 0
              ? null
              : (top.amount / total) * 100,
          averageExpense: avg,
          highestExpense: highest,
          trendVsPriorPercent: trend,
        ),
      );
    },
  );
});

/// Frequent categories for quick-pick in add-expense flows (by count).
final expenseCategorySuggestionsProvider = Provider<List<String>>((ref) {
  final expenses =
      ref.watch(expensesStreamProvider).asData?.value ?? const <Expense>[];
  final counts = <String, int>{};
  for (final expense in expenses) {
    if (expense.isDeleted) continue;
    final label = expense.category.trim();
    if (label.isEmpty) continue;
    counts.update(label, (v) => v + 1, ifAbsent: () => 1);
  }
  final entries = counts.entries.toList(growable: false)
    ..sort((a, b) => b.value.compareTo(a.value));
  return entries.take(10).map((e) => e.key).toList(growable: false);
});

bool _matchesDatePreset(DateTime date, ExpensesFilterState filters) {
  final local = date.toLocal();
  final now = DateTime.now();
  final day = DateUtils.dateOnly(local);
  final today = DateUtils.dateOnly(now);
  switch (filters.datePreset) {
    case ExpensesDatePreset.today:
      return day == today;
    case ExpensesDatePreset.thisWeek:
      final start = today.subtract(
        Duration(days: today.weekday - DateTime.monday),
      );
      final end = start.add(const Duration(days: 7));
      return !day.isBefore(start) && day.isBefore(end);
    case ExpensesDatePreset.thisMonth:
      return local.year == now.year && local.month == now.month;
    case ExpensesDatePreset.custom:
      final range = filters.customRange;
      if (range == null) return true;
      final start = DateUtils.dateOnly(range.start);
      final end = DateUtils.dateOnly(range.end).add(const Duration(days: 1));
      return !day.isBefore(start) && day.isBefore(end);
  }
}

({String label, double amount})? _topCategoryEntry(List<Expense> expenses) {
  if (expenses.isEmpty) return null;
  final totals = <String, double>{};
  for (final expense in expenses) {
    final label = expense.category.trim();
    if (label.isEmpty) continue;
    totals.update(
      label,
      (value) => value + expense.amount,
      ifAbsent: () => expense.amount,
    );
  }
  if (totals.isEmpty) return null;
  final best = totals.entries.reduce((a, b) => b.value > a.value ? b : a);
  return (label: best.key, amount: best.value);
}

double? _expenseTrendVsPriorComparableWindow(
  List<Expense> all,
  ExpensesFilterState filters,
) {
  final priorRange = _priorComparableDateRange(filters);
  if (priorRange == null) return null;
  final priorTotal = _sumExpensesInRangeWithStaticFilters(
    all,
    priorRange,
    filters,
  );
  final current = applyExpenseFilters(all, filters);
  final currentTotal = current.fold<double>(0, (s, e) => s + e.amount);
  if (priorTotal <= 0) {
    if (currentTotal <= 0) return null;
    return 100;
  }
  return ((currentTotal - priorTotal) / priorTotal) * 100;
}

DateTimeRange? _priorComparableDateRange(ExpensesFilterState filters) {
  final now = DateTime.now();
  switch (filters.datePreset) {
    case ExpensesDatePreset.custom:
      return null;
    case ExpensesDatePreset.today:
      final y = DateUtils.dateOnly(now.subtract(const Duration(days: 1)));
      return DateTimeRange(start: y, end: y);
    case ExpensesDatePreset.thisWeek:
      final today = DateUtils.dateOnly(now);
      final weekStart = today.subtract(
        Duration(days: today.weekday - DateTime.monday),
      );
      final prevStart = weekStart.subtract(const Duration(days: 7));
      final prevEnd = weekStart.subtract(const Duration(days: 1));
      return DateTimeRange(start: prevStart, end: prevEnd);
    case ExpensesDatePreset.thisMonth:
      final today = DateUtils.dateOnly(now);
      final monthStart = DateTime(today.year, today.month, 1);
      final dayCount = today.difference(monthStart).inDays + 1;
      final prevMonthLast = monthStart.subtract(const Duration(days: 1));
      final prevMonthStart = DateTime(
        prevMonthLast.year,
        prevMonthLast.month,
        1,
      );
      final dim = DateUtils.getDaysInMonth(
        prevMonthStart.year,
        prevMonthStart.month,
      );
      final cap = math.min(dayCount, dim);
      final end = DateTime(prevMonthStart.year, prevMonthStart.month, cap);
      return DateTimeRange(start: prevMonthStart, end: end);
  }
}

double _sumExpensesInRangeWithStaticFilters(
  List<Expense> all,
  DateTimeRange range,
  ExpensesFilterState filters,
) {
  final start = DateUtils.dateOnly(range.start);
  final end = DateUtils.dateOnly(range.end);
  return all
      .where((expense) {
        if (expense.isDeleted) return false;
        if (filters.category != null &&
            filters.category!.trim().isNotEmpty &&
            expense.category != filters.category) {
          return false;
        }
        if (filters.paymentMethod != null &&
            filters.paymentMethod!.trim().isNotEmpty &&
            expense.paymentMethod != filters.paymentMethod) {
          return false;
        }
        if (filters.createdByUid != null &&
            filters.createdByUid!.trim().isNotEmpty &&
            expense.createdByUid != filters.createdByUid) {
          return false;
        }
        final d = DateUtils.dateOnly(expense.incurredAt.toLocal());
        return !d.isBefore(start) && !d.isAfter(end);
      })
      .fold<double>(0, (sum, expense) => sum + expense.amount);
}
