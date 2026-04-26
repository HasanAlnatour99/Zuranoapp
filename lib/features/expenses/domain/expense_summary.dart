import 'package:flutter/material.dart';

import '../data/models/expense.dart';

/// Aggregated numbers for the expenses dashboard (date + filter aware).
class ExpensesSummary {
  const ExpensesSummary({
    required this.total,
    required this.expenseCount,
    required this.topCategory,
    this.topCategoryAmount,
    this.topCategoryPercentOfTotal,
    this.averageExpense,
    this.highestExpense,
    this.trendVsPriorPercent,
  });

  final double total;
  final int expenseCount;
  final String? topCategory;
  final double? topCategoryAmount;
  final double? topCategoryPercentOfTotal;
  final double? averageExpense;
  final double? highestExpense;
  final double? trendVsPriorPercent;
}

class ExpenseCategoryBar {
  const ExpenseCategoryBar({
    required this.category,
    required this.amount,
    required this.progress,
  });

  final String category;
  final double amount;
  final double progress;
}

class GroupedExpensesDay {
  const GroupedExpensesDay({
    required this.date,
    required this.expenses,
    required this.total,
  });

  final DateTime date;
  final List<Expense> expenses;
  final double total;
}

/// One row for category breakdown UI (amount + percent + bar color).
class ExpenseCategoryBreakdownUiRow {
  const ExpenseCategoryBreakdownUiRow({
    required this.categoryLabel,
    required this.amount,
    required this.percentOfTotal,
    required this.progress,
    required this.barColor,
  });

  final String categoryLabel;
  final double amount;
  final double percentOfTotal;
  final double progress;
  final Color barColor;
}
