import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/salon_streams_provider.dart';
import '../../expenses/data/models/expense.dart';
import '../../sales/data/models/sale.dart';
import '../domain/sales_filter.dart';
import '../domain/sales_summary_model.dart';
import '../domain/sales_vs_expenses_point.dart';

class SalesFilterState {
  const SalesFilterState({
    this.datePreset = SalesFilter.thisMonth,
    this.customRange,
    this.paymentMethod,
    this.barberId,
  });

  final SalesFilter datePreset;
  final DateTimeRange? customRange;
  final String? paymentMethod;
  final String? barberId;

  SalesFilterState copyWith({
    SalesFilter? datePreset,
    Object? customRange = _sentinel,
    Object? paymentMethod = _sentinel,
    Object? barberId = _sentinel,
  }) {
    return SalesFilterState(
      datePreset: datePreset ?? this.datePreset,
      customRange: identical(customRange, _sentinel)
          ? this.customRange
          : customRange as DateTimeRange?,
      paymentMethod: identical(paymentMethod, _sentinel)
          ? this.paymentMethod
          : paymentMethod as String?,
      barberId: identical(barberId, _sentinel)
          ? this.barberId
          : barberId as String?,
    );
  }
}

class SalesFiltersNotifier extends Notifier<SalesFilterState> {
  @override
  SalesFilterState build() =>
      const SalesFilterState(datePreset: SalesFilter.thisMonth);

  void initialize({String? barberId}) {
    if (barberId == null || barberId.trim().isEmpty) {
      return;
    }
    state = state.copyWith(barberId: barberId.trim());
  }

  void setDatePreset(SalesFilter preset) {
    state = state.copyWith(
      datePreset: preset,
      customRange: preset == SalesFilter.custom ? state.customRange : null,
    );
  }

  void setCustomRange(DateTimeRange? range) {
    state = state.copyWith(
      datePreset: range == null ? state.datePreset : SalesFilter.custom,
      customRange: range,
    );
  }

  void setPaymentMethod(String? method) {
    state = state.copyWith(paymentMethod: method);
  }

  void setBarberId(String? barberId) {
    state = state.copyWith(barberId: barberId);
  }
}

final salesFiltersProvider =
    NotifierProvider<SalesFiltersNotifier, SalesFilterState>(
      SalesFiltersNotifier.new,
    );

class GroupedSalesDay {
  const GroupedSalesDay({
    required this.date,
    required this.sales,
    required this.total,
  });

  final DateTime date;
  final List<Sale> sales;
  final double total;
}

class SalesTrendPoint {
  const SalesTrendPoint({required this.date, required this.total});

  final DateTime date;
  final double total;
}

class SalesBreakdownSlice {
  const SalesBreakdownSlice({required this.label, required this.amount});

  final String label;
  final double amount;
}

class ServiceRevenueEntry {
  const ServiceRevenueEntry({required this.label, required this.amount});

  final String label;
  final double amount;
}

class BarberSalesRank {
  const BarberSalesRank({
    required this.employeeId,
    required this.name,
    required this.amount,
  });

  final String employeeId;
  final String name;
  final double amount;
}

final salesPaymentMethodOptionsProvider = Provider<List<String>>((ref) {
  final sales = ref.watch(salesStreamProvider).asData?.value ?? const <Sale>[];
  final set =
      sales.map((sale) => sale.paymentMethod).toSet().toList(growable: false)
        ..sort();
  return set;
});

final filteredSalesProvider = Provider<AsyncValue<List<Sale>>>((ref) {
  final salesAsync = ref.watch(salesStreamProvider);
  final filters = ref.watch(salesFiltersProvider);

  return salesAsync.whenData((sales) {
    return sales
        .where((sale) {
          if (filters.barberId != null &&
              filters.barberId!.trim().isNotEmpty &&
              sale.employeeId != filters.barberId) {
            return false;
          }
          if (filters.paymentMethod != null &&
              filters.paymentMethod!.trim().isNotEmpty &&
              sale.paymentMethod != filters.paymentMethod) {
            return false;
          }
          return dateTimeMatchesSalesFilter(
            at: sale.soldAt,
            filter: filters.datePreset,
            customRange: filters.customRange,
          );
        })
        .toList(growable: false)
      ..sort((a, b) => b.soldAt.compareTo(a.soldAt));
  });
});

final filteredExpensesForSalesProvider = Provider<AsyncValue<List<Expense>>>((
  ref,
) {
  final expensesAsync = ref.watch(expensesStreamProvider);
  final filters = ref.watch(salesFiltersProvider);
  return expensesAsync.whenData((expenses) {
    return expenses
        .where(
          (e) => dateTimeMatchesSalesFilter(
            at: e.incurredAt,
            filter: filters.datePreset,
            customRange: filters.customRange,
          ),
        )
        .toList(growable: false);
  });
});

final groupedSalesListProvider = Provider<AsyncValue<List<GroupedSalesDay>>>((
  ref,
) {
  final filteredAsync = ref.watch(filteredSalesProvider);
  return filteredAsync.whenData((sales) {
    final grouped = <DateTime, List<Sale>>{};
    for (final sale in sales) {
      final key = DateUtils.dateOnly(sale.soldAt.toLocal());
      grouped.putIfAbsent(key, () => <Sale>[]).add(sale);
    }
    final items =
        grouped.entries
            .map(
              (entry) => GroupedSalesDay(
                date: entry.key,
                sales: entry.value,
                total: entry.value.fold<double>(
                  0,
                  (sum, sale) => sum + sale.total,
                ),
              ),
            )
            .toList(growable: false)
          ..sort((a, b) => b.date.compareTo(a.date));
    return items;
  });
});

final salesSummaryModelProvider = Provider<AsyncValue<SalesSummaryModel>>((
  ref,
) {
  final filteredAsync = ref.watch(filteredSalesProvider);
  final employees = ref.watch(employeesStreamProvider).asData?.value;

  return filteredAsync.whenData((sales) {
    final total = sales.fold<double>(0, (sum, sale) => sum + sale.total);
    final averageTicket = sales.isEmpty ? 0.0 : total / sales.length;
    final topBarber = _topBarberEntry(sales);
    String? imageUrl;
    if (topBarber != null && employees != null) {
      for (final e in employees) {
        if (e.id == topBarber.id) {
          imageUrl = e.avatarUrl;
          break;
        }
      }
    }
    return SalesSummaryModel(
      totalSales: total,
      transactionsCount: sales.length,
      averageTicket: averageTicket,
      topBarberName: topBarber?.name,
      topBarberId: topBarber?.id,
      topBarberImageUrl: imageUrl,
      topServiceName: _topServiceName(sales),
    );
  });
});

/// Legacy name used in older widgets; prefer [salesSummaryModelProvider].
final salesSummaryProvider = Provider<AsyncValue<SalesSummaryModel>>(
  (ref) => ref.watch(salesSummaryModelProvider),
);

final salesTrendSeriesProvider = Provider<AsyncValue<List<SalesTrendPoint>>>((
  ref,
) {
  final filteredAsync = ref.watch(filteredSalesProvider);
  return filteredAsync.whenData((sales) {
    final totalsByDay = <DateTime, double>{};
    for (final sale in sales) {
      final day = DateUtils.dateOnly(sale.soldAt.toLocal());
      totalsByDay.update(
        day,
        (value) => value + sale.total,
        ifAbsent: () => sale.total,
      );
    }

    final points =
        totalsByDay.entries
            .map(
              (entry) => SalesTrendPoint(date: entry.key, total: entry.value),
            )
            .toList(growable: false)
          ..sort((a, b) => a.date.compareTo(b.date));

    return points;
  });
});

final salesVsExpensesSeriesProvider =
    Provider<AsyncValue<List<SalesVsExpensesPoint>>>((ref) {
      final salesAsync = ref.watch(filteredSalesProvider);
      final expensesAsync = ref.watch(filteredExpensesForSalesProvider);

      if (salesAsync.isLoading || expensesAsync.isLoading) {
        return const AsyncValue.loading();
      }
      if (salesAsync.hasError) {
        return AsyncValue.error(
          salesAsync.error!,
          salesAsync.stackTrace ?? StackTrace.current,
        );
      }
      if (expensesAsync.hasError) {
        return AsyncValue.error(
          expensesAsync.error!,
          expensesAsync.stackTrace ?? StackTrace.current,
        );
      }

      final filters = ref.watch(salesFiltersProvider);
      final points = _salesVsExpensesPoints(
        sales: salesAsync.requireValue,
        expenses: expensesAsync.requireValue,
        filters: filters,
      );
      return AsyncValue.data(points);
    });

final salesPaymentBreakdownProvider =
    Provider<AsyncValue<List<SalesBreakdownSlice>>>((ref) {
      final filteredAsync = ref.watch(filteredSalesProvider);
      return filteredAsync.whenData((sales) {
        final totals = <String, double>{};
        for (final sale in sales) {
          final method = sale.paymentMethod.trim();
          if (method.isEmpty) {
            continue;
          }
          totals.update(
            method,
            (value) => value + sale.total,
            ifAbsent: () => sale.total,
          );
        }

        final slices =
            totals.entries
                .map(
                  (entry) => SalesBreakdownSlice(
                    label: entry.key,
                    amount: entry.value,
                  ),
                )
                .toList(growable: false)
              ..sort((a, b) => b.amount.compareTo(a.amount));

        return slices;
      });
    });

final salesServiceRevenueBreakdownProvider =
    Provider<AsyncValue<List<ServiceRevenueEntry>>>((ref) {
      final filteredAsync = ref.watch(filteredSalesProvider);
      return filteredAsync.whenData((sales) {
        return _computeServiceRevenueRanked(sales);
      });
    });

final salesBarberRankingProvider = Provider<AsyncValue<List<BarberSalesRank>>>((
  ref,
) {
  final filteredAsync = ref.watch(filteredSalesProvider);
  return filteredAsync.whenData((sales) {
    return _computeBarberRanking(sales);
  });
});

/// Recent sales for the selected period (flat list, newest first).
final recentFilteredSalesProvider = Provider<AsyncValue<List<Sale>>>((ref) {
  return ref.watch(filteredSalesProvider);
});

({String id, String name})? _topBarberEntry(List<Sale> sales) {
  if (sales.isEmpty) return null;
  final totals = <String, double>{};
  final labels = <String, String>{};
  for (final sale in sales) {
    totals.update(
      sale.employeeId,
      (value) => value + sale.total,
      ifAbsent: () => sale.total,
    );
    labels[sale.employeeId] = sale.employeeName;
  }
  final winner = totals.entries.reduce((best, next) {
    return next.value > best.value ? next : best;
  });
  final id = winner.key;
  final name = labels[id];
  if (name == null || name.trim().isEmpty) return null;
  return (id: id, name: name.trim());
}

List<ServiceRevenueEntry> _computeServiceRevenueRanked(Iterable<Sale> sales) {
  final totals = <String, double>{};
  final labels = <String, String>{};
  for (final sale in sales) {
    if (sale.lineItems.isEmpty) {
      final label = sale.serviceNames.isEmpty
          ? ''
          : sale.serviceNames.first.trim();
      if (label.isEmpty) continue;
      totals.update(
        label,
        (value) => value + sale.total,
        ifAbsent: () => sale.total,
      );
      labels[label] = label;
      continue;
    }
    for (final line in sale.lineItems) {
      final key = line.serviceId.trim().isEmpty
          ? line.serviceName.trim()
          : line.serviceId.trim();
      if (key.isEmpty) continue;
      totals.update(
        key,
        (value) => value + line.total,
        ifAbsent: () => line.total,
      );
      labels[key] = line.serviceName;
    }
  }
  final rows =
      totals.entries
          .map(
            (e) => ServiceRevenueEntry(
              label: labels[e.key] ?? e.key,
              amount: e.value,
            ),
          )
          .toList(growable: false)
        ..sort((a, b) => b.amount.compareTo(a.amount));
  return rows;
}

List<BarberSalesRank> _computeBarberRanking(Iterable<Sale> sales) {
  final totals = <String, double>{};
  final names = <String, String>{};
  for (final sale in sales) {
    final id = sale.employeeId.trim();
    if (id.isEmpty) continue;
    totals.update(id, (v) => v + sale.total, ifAbsent: () => sale.total);
    if (sale.employeeName.trim().isNotEmpty) {
      names[id] = sale.employeeName;
    }
  }
  final rows =
      totals.entries
          .map(
            (e) => BarberSalesRank(
              employeeId: e.key,
              name: names[e.key]?.trim().isNotEmpty == true
                  ? names[e.key]!
                  : e.key,
              amount: e.value,
            ),
          )
          .toList(growable: false)
        ..sort((a, b) => b.amount.compareTo(a.amount));
  return rows;
}

String? _topServiceName(List<Sale> sales) {
  if (sales.isEmpty) return null;
  final counts = <String, int>{};
  for (final sale in sales) {
    if (sale.lineItems.isEmpty) {
      for (final name in sale.serviceNames) {
        if (name.trim().isEmpty) continue;
        counts.update(name, (value) => value + 1, ifAbsent: () => 1);
      }
      continue;
    }
    for (final line in sale.lineItems) {
      final name = line.serviceName.trim();
      if (name.isEmpty) continue;
      counts.update(
        name,
        (value) => value + (line.quantity <= 0 ? 1 : line.quantity),
        ifAbsent: () => (line.quantity <= 0 ? 1 : line.quantity),
      );
    }
  }
  if (counts.isEmpty) return null;
  return counts.entries.reduce((best, next) {
    return next.value > best.value ? next : best;
  }).key;
}

List<SalesVsExpensesPoint> _salesVsExpensesPoints({
  required List<Sale> sales,
  required List<Expense> expenses,
  required SalesFilterState filters,
}) {
  final now = DateTime.now();
  final range = _chartDateRange(filters, now);
  if (range == null) return const [];

  final salesByDay = <DateTime, double>{};
  for (final sale in sales) {
    final d = DateUtils.dateOnly(sale.soldAt.toLocal());
    salesByDay.update(d, (v) => v + sale.total, ifAbsent: () => sale.total);
  }
  final expensesByDay = <DateTime, double>{};
  for (final e in expenses) {
    final d = DateUtils.dateOnly(e.incurredAt.toLocal());
    expensesByDay.update(d, (v) => v + e.amount, ifAbsent: () => e.amount);
  }

  final points = <SalesVsExpensesPoint>[];
  for (
    var d = range.start;
    !d.isAfter(range.end);
    d = d.add(const Duration(days: 1))
  ) {
    final day = DateUtils.dateOnly(d);
    points.add(
      SalesVsExpensesPoint(
        date: day,
        salesTotal: salesByDay[day] ?? 0,
        expensesTotal: expensesByDay[day] ?? 0,
      ),
    );
  }
  return points;
}

({DateTime start, DateTime end})? _chartDateRange(
  SalesFilterState filters,
  DateTime now,
) {
  final today = DateUtils.dateOnly(now);
  switch (filters.datePreset) {
    case SalesFilter.today:
      return (start: today, end: today);
    case SalesFilter.thisWeek:
      final start = today.subtract(
        Duration(days: today.weekday - DateTime.monday),
      );
      final end = start.add(const Duration(days: 6));
      return (start: start, end: end);
    case SalesFilter.thisMonth:
      final start = DateTime(now.year, now.month, 1);
      final end = DateTime(now.year, now.month + 1, 0);
      return (start: DateUtils.dateOnly(start), end: DateUtils.dateOnly(end));
    case SalesFilter.custom:
      final range = filters.customRange;
      if (range == null) {
        return (start: today.subtract(const Duration(days: 29)), end: today);
      }
      return (
        start: DateUtils.dateOnly(range.start),
        end: DateUtils.dateOnly(range.end),
      );
  }
}

const Object _sentinel = Object();
