import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../../core/constants/sale_reporting.dart';
import '../../../core/firestore/firestore_paths.dart';
import '../../../core/firestore/firestore_serializers.dart';
import '../../../core/firestore/firestore_write_payload.dart';
import '../../employees/data/models/employee.dart';
import '../../salon/data/models/salon.dart';
import '../../sales/data/models/sale.dart';
import '../domain/models/ai_surface_response.dart';
import '../domain/repositories/owner_dashboard_ai_repository.dart';

class FirestoreOwnerDashboardAiRepository
    implements OwnerDashboardAiRepository {
  FirestoreOwnerDashboardAiRepository({required FirebaseFirestore firestore})
    : _firestore = firestore;

  final FirebaseFirestore _firestore;

  static const int _topBarbersLimit = 5;

  CollectionReference<Map<String, dynamic>> _sales(String salonId) {
    FirestoreWritePayload.assertSalonId(salonId);
    return _firestore.collection(FirestorePaths.salonSales(salonId));
  }

  CollectionReference<Map<String, dynamic>> _employees(String salonId) {
    FirestoreWritePayload.assertSalonId(salonId);
    return _firestore.collection(FirestorePaths.salonEmployees(salonId));
  }

  DocumentReference<Map<String, dynamic>> _salon(String salonId) {
    FirestoreWritePayload.assertSalonId(salonId);
    return _firestore.doc(FirestorePaths.salon(salonId));
  }

  @override
  Future<SalonRevenueSummary> getSalonRevenueSummary({
    required String salonId,
    required AiTimeframe timeframe,
  }) async {
    final normalizedSalonId = salonId.trim();
    FirestoreWritePayload.assertSalonId(normalizedSalonId);

    final rangeWindow = resolveRangeWindow(timeframe);
    final currencyCode = await _readSalonCurrencyCode(normalizedSalonId);

    try {
      final aggregateSnapshot = await _buildCompletedSalesQuery(
        normalizedSalonId,
        rangeWindow,
      ).aggregate(count(), sum('total')).get();
      final transactionCount = aggregateSnapshot.count ?? 0;
      final grossSales = _safeDouble(aggregateSnapshot.getSum('total'));
      return buildRevenueSummary(
        range: timeframe.range,
        rangeLabel: rangeWindow.label,
        currencyCode: currencyCode,
        grossSales: grossSales,
        transactionCount: transactionCount,
      );
    } on FirebaseException catch (_) {
      final fallback = await _computeRevenueSummaryFromDocuments(
        normalizedSalonId,
        rangeWindow,
      );
      return buildRevenueSummary(
        range: timeframe.range,
        rangeLabel: rangeWindow.label,
        currencyCode: currencyCode,
        grossSales: fallback.grossSales,
        transactionCount: fallback.transactionCount,
      );
    }
  }

  @override
  Future<List<TopBarberSnapshot>> getTopBarbers({
    required String salonId,
    required AiTimeframe timeframe,
  }) async {
    final normalizedSalonId = salonId.trim();
    FirestoreWritePayload.assertSalonId(normalizedSalonId);

    final rangeWindow = resolveRangeWindow(timeframe);
    final salesSnapshot = await _buildCompletedSalesQuery(
      normalizedSalonId,
      rangeWindow,
    ).get();

    if (salesSnapshot.docs.isEmpty) {
      return const [];
    }

    final employeeSnapshot = await _employees(normalizedSalonId).get();
    final employeesById = {
      for (final doc in employeeSnapshot.docs)
        doc.id: Employee.fromJson(doc.data()),
    };

    final sales = salesSnapshot.docs
        .map((doc) => Sale.fromJson(doc.data()))
        .toList(growable: false);
    return buildTopBarberSnapshots(
      sales: sales,
      employeesById: employeesById,
      limit: _topBarbersLimit,
    );
  }

  Query<Map<String, dynamic>> _buildCompletedSalesQuery(
    String salonId,
    AiRangeWindow rangeWindow,
  ) {
    return _sales(salonId)
        .where('status', isEqualTo: SaleStatuses.completed)
        .where('soldAt', isGreaterThanOrEqualTo: rangeWindow.start)
        .where('soldAt', isLessThan: rangeWindow.end)
        .orderBy('soldAt', descending: true);
  }

  Future<_RevenueSummaryAccumulator> _computeRevenueSummaryFromDocuments(
    String salonId,
    AiRangeWindow rangeWindow,
  ) async {
    final snapshot = await _buildCompletedSalesQuery(
      salonId,
      rangeWindow,
    ).get();
    var grossSales = 0.0;
    var transactionCount = 0;
    for (final doc in snapshot.docs) {
      final sale = Sale.fromJson(doc.data());
      grossSales += _saleTotal(sale);
      transactionCount += 1;
    }

    return _RevenueSummaryAccumulator(
      grossSales: grossSales,
      transactionCount: transactionCount,
      averageTicket: transactionCount > 0 ? grossSales / transactionCount : 0,
    );
  }

  Future<String> _readSalonCurrencyCode(String salonId) async {
    try {
      final snapshot = await _salon(salonId).get();
      final data = snapshot.data();
      if (!snapshot.exists || data == null) {
        return 'USD';
      }
      final salon = Salon.fromJson(data);
      return salon.currencyCode.trim().isEmpty
          ? 'USD'
          : salon.currencyCode.trim();
    } on Object {
      return 'USD';
    }
  }

  @visibleForTesting
  static SalonRevenueSummary buildRevenueSummary({
    required AiTimeRange range,
    required String rangeLabel,
    required String currencyCode,
    required double grossSales,
    required int transactionCount,
  }) {
    return SalonRevenueSummary(
      range: range,
      rangeLabel: rangeLabel,
      currencyCode: currencyCode.trim().isEmpty ? 'USD' : currencyCode.trim(),
      grossSales: grossSales,
      transactionCount: transactionCount,
      averageTicket: transactionCount > 0 ? grossSales / transactionCount : 0,
    );
  }

  @visibleForTesting
  static List<TopBarberSnapshot> buildTopBarberSnapshots({
    required List<Sale> sales,
    required Map<String, Employee> employeesById,
    int limit = _topBarbersLimit,
  }) {
    final grouped = <String, _TopBarberAccumulator>{};

    for (final sale in sales) {
      if (sale.status != SaleStatuses.completed) {
        continue;
      }

      final employeeId = _resolveEmployeeIdForTest(sale);
      if (employeeId == null) {
        continue;
      }

      final amount = _saleTotalForTest(sale);
      final current = grouped[employeeId];
      final resolvedEmployee = employeesById[employeeId];
      final displayName = _resolveEmployeeNameForTest(
        sale: sale,
        employee: resolvedEmployee,
        fallbackId: employeeId,
      );
      final photoUrl = _resolveEmployeePhotoForTest(employee: resolvedEmployee);

      grouped[employeeId] = _TopBarberAccumulator(
        employeeId: employeeId,
        employeeName: displayName,
        photoUrl: photoUrl ?? current?.photoUrl,
        salesAmount: (current?.salesAmount ?? 0) + amount,
        transactionsCount: (current?.transactionsCount ?? 0) + 1,
      );
    }

    if (grouped.isEmpty) {
      return const [];
    }

    final sorted = grouped.values.toList(growable: false)
      ..sort((a, b) {
        final bySales = b.salesAmount.compareTo(a.salesAmount);
        if (bySales != 0) return bySales;
        final byTransactions = b.transactionsCount.compareTo(
          a.transactionsCount,
        );
        if (byTransactions != 0) return byTransactions;
        return a.employeeName.toLowerCase().compareTo(
          b.employeeName.toLowerCase(),
        );
      });

    return sorted
        .take(limit)
        .toList(growable: false)
        .asMap()
        .entries
        .map((entry) {
          final item = entry.value;
          return TopBarberSnapshot(
            employeeId: item.employeeId,
            employeeName: item.employeeName,
            photoUrl: item.photoUrl,
            salesAmount: item.salesAmount,
            transactionsCount: item.transactionsCount,
            averageTicket: item.transactionsCount > 0
                ? item.salesAmount / item.transactionsCount
                : 0,
            rank: entry.key + 1,
          );
        })
        .toList(growable: false);
  }

  @visibleForTesting
  static AiRangeWindow resolveRangeWindow(
    AiTimeframe timeframe, {
    DateTime? now,
  }) {
    final anchor = now ?? DateTime.now();
    switch (timeframe.range) {
      case AiTimeRange.today:
        final start = DateTime(anchor.year, anchor.month, anchor.day);
        final end = start.add(const Duration(days: 1));
        return AiRangeWindow(start: start, end: end, label: 'today');
      case AiTimeRange.last7Days:
        final end = DateTime(anchor.year, anchor.month, anchor.day + 1);
        final start = end.subtract(const Duration(days: 7));
        return AiRangeWindow(start: start, end: end, label: 'last_7_days');
      case AiTimeRange.month:
        final year = timeframe.year ?? anchor.year;
        final month = timeframe.month ?? anchor.month;
        if (month < 1 || month > 12) {
          throw const FormatException('Month must be between 1 and 12.');
        }
        final start = DateTime(year, month, 1);
        final end = DateTime(year, month + 1, 1);
        final isCurrentMonth = year == anchor.year && month == anchor.month;
        return AiRangeWindow(
          start: start,
          end: end,
          label: isCurrentMonth
              ? 'this_month'
              : '$year-${month.toString().padLeft(2, '0')}',
        );
      case AiTimeRange.quarter:
        final year = timeframe.year ?? anchor.year;
        final quarter = timeframe.quarter ?? _quarterForMonth(anchor.month);
        if (quarter < 1 || quarter > 4) {
          throw const FormatException('Quarter must be between 1 and 4.');
        }
        final startMonth = ((quarter - 1) * 3) + 1;
        final start = DateTime(year, startMonth, 1);
        final end = DateTime(year, startMonth + 3, 1);
        final isCurrentQuarter =
            year == anchor.year && quarter == _quarterForMonth(anchor.month);
        return AiRangeWindow(
          start: start,
          end: end,
          label: isCurrentQuarter ? 'this_quarter' : '$year-Q$quarter',
        );
      case AiTimeRange.custom:
        final startDate = timeframe.startDate;
        final endDate = timeframe.endDate;
        if (startDate == null || endDate == null) {
          throw const FormatException(
            'Custom range requires both start and end dates.',
          );
        }
        final start = DateTime(startDate.year, startDate.month, startDate.day);
        final inclusiveEnd = DateTime(endDate.year, endDate.month, endDate.day);
        if (start.isAfter(inclusiveEnd)) {
          throw const FormatException(
            'Custom range start date must be on or before end date.',
          );
        }
        return AiRangeWindow(
          start: start,
          end: inclusiveEnd.add(const Duration(days: 1)),
          label: '${_formatDate(start)}_${_formatDate(inclusiveEnd)}',
        );
    }
  }

  double _saleTotal(Sale sale) {
    return _saleTotalForTest(sale);
  }

  double _safeDouble(Object? value) {
    return FirestoreSerializers.doubleValue(value);
  }

  static int _quarterForMonth(int month) {
    return ((month - 1) ~/ 3) + 1;
  }
}

class AiRangeWindow {
  const AiRangeWindow({
    required this.start,
    required this.end,
    required this.label,
  });

  final DateTime start;
  final DateTime end;
  final String label;
}

class _RevenueSummaryAccumulator {
  const _RevenueSummaryAccumulator({
    required this.grossSales,
    required this.transactionCount,
    required this.averageTicket,
  });

  final double grossSales;
  final int transactionCount;
  final double averageTicket;
}

class _TopBarberAccumulator {
  const _TopBarberAccumulator({
    required this.employeeId,
    required this.employeeName,
    required this.salesAmount,
    required this.transactionsCount,
    this.photoUrl,
  });

  final String employeeId;
  final String employeeName;
  final String? photoUrl;
  final double salesAmount;
  final int transactionsCount;
}

String? _resolveEmployeeIdForTest(Sale sale) {
  final employeeId = sale.employeeId.trim();
  if (employeeId.isNotEmpty) return employeeId;
  final barberId = sale.barberId.trim();
  if (barberId.isNotEmpty) return barberId;
  return null;
}

String _resolveEmployeeNameForTest({
  required Sale sale,
  required Employee? employee,
  required String fallbackId,
}) {
  final employeeName = employee?.name.trim();
  if (employeeName != null && employeeName.isNotEmpty) {
    return employeeName;
  }
  final saleName = sale.employeeName.trim();
  if (saleName.isNotEmpty) {
    return saleName;
  }
  if (sale.lineItems.isNotEmpty) {
    final candidate = sale.lineItems.first.employeeName.trim();
    if (candidate.isNotEmpty) {
      return candidate;
    }
  }
  return fallbackId;
}

String? _resolveEmployeePhotoForTest({required Employee? employee}) {
  final photoUrl = employee?.avatarUrl?.trim();
  if (photoUrl == null || photoUrl.isEmpty) {
    return null;
  }
  return photoUrl;
}

double _saleTotalForTest(Sale sale) {
  if (sale.lineItems.isEmpty) {
    return FirestoreSerializers.doubleValue(sale.total);
  }
  final itemsTotal = sale.lineItems.fold<double>(
    0,
    (runningTotal, item) =>
        runningTotal + FirestoreSerializers.doubleValue(item.total),
  );
  if (itemsTotal > 0) {
    return itemsTotal;
  }
  return FirestoreSerializers.doubleValue(sale.total);
}

String _formatDate(DateTime value) {
  final year = value.year.toString().padLeft(4, '0');
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}
