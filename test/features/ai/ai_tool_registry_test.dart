import 'package:barber_shop_app/core/constants/app_routes.dart';
import 'package:barber_shop_app/features/ai/data/ai_tool_registry.dart';
import 'package:barber_shop_app/features/ai/domain/models/ai_surface_response.dart';
import 'package:barber_shop_app/features/ai/domain/repositories/owner_dashboard_ai_repository.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AiToolRegistry', () {
    test('shapes revenue summary payload with compact safe fields', () async {
      final registry = AiToolRegistry(_FakeOwnerDashboardAiRepository());

      final payload = await registry.invoke(
        const FunctionCall('getSalonRevenueSummary', {
          'salonId': 'salon-1',
          'range': 'today',
        }),
      );

      expect(payload['ok'], true);
      expect(payload['recommendedRoute'], AppRoutes.ownerSales);
      expect(payload['summary'], {
        'range': 'today',
        'rangeLabel': 'today',
        'currencyCode': 'USD',
        'grossSales': 1250.0,
        'transactionCount': 5,
        'averageTicket': 250.0,
      });
    });

    test(
      'passes explicit month and year to repository for month queries',
      () async {
        final repository = _FakeOwnerDashboardAiRepository();
        final registry = AiToolRegistry(repository);

        await registry.invoke(
          const FunctionCall('getSalonRevenueSummary', {
            'salonId': 'salon-1',
            'range': 'month',
            'year': 2025,
            'month': 12,
          }),
        );

        expect(repository.lastRevenueTimeframe?.range, AiTimeRange.month);
        expect(repository.lastRevenueTimeframe?.year, 2025);
        expect(repository.lastRevenueTimeframe?.month, 12);
      },
    );

    test(
      'passes explicit quarter and year to repository for quarter queries',
      () async {
        final repository = _FakeOwnerDashboardAiRepository();
        final registry = AiToolRegistry(repository);

        await registry.invoke(
          const FunctionCall('getTopBarbers', {
            'salonId': 'salon-1',
            'range': 'quarter',
            'year': 2025,
            'quarter': 2,
          }),
        );

        expect(repository.lastTopBarbersTimeframe?.range, AiTimeRange.quarter);
        expect(repository.lastTopBarbersTimeframe?.year, 2025);
        expect(repository.lastTopBarbersTimeframe?.quarter, 2);
      },
    );

    test('passes explicit custom date ranges to repository', () async {
      final repository = _FakeOwnerDashboardAiRepository();
      final registry = AiToolRegistry(repository);

      await registry.invoke(
        const FunctionCall('getSalonRevenueSummary', {
          'salonId': 'salon-1',
          'range': 'custom',
          'startDate': '2025-03-01',
          'endDate': '2025-03-15',
        }),
      );

      expect(repository.lastRevenueTimeframe?.range, AiTimeRange.custom);
      expect(repository.lastRevenueTimeframe?.startDate, DateTime(2025, 3, 1));
      expect(repository.lastRevenueTimeframe?.endDate, DateTime(2025, 3, 15));
    });

    test('rejects malformed month arguments', () async {
      final registry = AiToolRegistry(_FakeOwnerDashboardAiRepository());

      expect(
        () => registry.invoke(
          const FunctionCall('getTopBarbers', {
            'salonId': 'salon-1',
            'range': 'month',
            'year': '2025',
            'month': 'not-a-month',
          }),
        ),
        throwsFormatException,
      );
    });

    test('rejects incomplete custom date ranges', () async {
      final registry = AiToolRegistry(_FakeOwnerDashboardAiRepository());

      expect(
        () => registry.invoke(
          const FunctionCall('getSalonRevenueSummary', {
            'salonId': 'salon-1',
            'range': 'custom',
            'startDate': '2025-03-01',
          }),
        ),
        throwsFormatException,
      );
    });

    test('shapes top barber payload with ranked compact items', () async {
      final registry = AiToolRegistry(_FakeOwnerDashboardAiRepository());

      final payload = await registry.invoke(
        const FunctionCall('getTopBarbers', {
          'salonId': 'salon-1',
          'range': 'month',
        }),
      );

      expect(payload['ok'], true);
      expect(payload['recommendedRoute'], AppRoutes.ownerSales);
      expect(payload['barbers'], [
        {
          'employeeId': 'e1',
          'employeeName': 'Omar',
          'photoUrl': 'omar.png',
          'salesAmount': 3000.0,
          'transactionsCount': 12,
          'averageTicket': 250.0,
          'rank': 1,
        },
        {
          'employeeId': 'e2',
          'employeeName': 'Adam',
          'salesAmount': 2000.0,
          'transactionsCount': 10,
          'averageTicket': 200.0,
          'rank': 2,
        },
      ]);
    });
  });
}

class _FakeOwnerDashboardAiRepository implements OwnerDashboardAiRepository {
  AiTimeframe? lastRevenueTimeframe;
  AiTimeframe? lastTopBarbersTimeframe;

  @override
  Future<SalonRevenueSummary> getSalonRevenueSummary({
    required String salonId,
    required AiTimeframe timeframe,
  }) async {
    lastRevenueTimeframe = timeframe;
    return SalonRevenueSummary(
      range: timeframe.range,
      rangeLabel: timeframe.hasCustomDateRange
          ? '${_formatDate(timeframe.startDate!)}_${_formatDate(timeframe.endDate!)}'
          : timeframe.hasSpecificQuarter
          ? '${timeframe.year}-Q${timeframe.quarter}'
          : timeframe.hasSpecificMonth
          ? '${timeframe.year}-${timeframe.month}'
          : timeframe.range.wireValue,
      currencyCode: 'USD',
      grossSales: 1250,
      transactionCount: 5,
      averageTicket: 250,
    );
  }

  @override
  Future<List<TopBarberSnapshot>> getTopBarbers({
    required String salonId,
    required AiTimeframe timeframe,
  }) async {
    lastTopBarbersTimeframe = timeframe;
    return const [
      TopBarberSnapshot(
        employeeId: 'e1',
        employeeName: 'Omar',
        photoUrl: 'omar.png',
        salesAmount: 3000,
        transactionsCount: 12,
        averageTicket: 250,
        rank: 1,
      ),
      TopBarberSnapshot(
        employeeId: 'e2',
        employeeName: 'Adam',
        salesAmount: 2000,
        transactionsCount: 10,
        averageTicket: 200,
        rank: 2,
      ),
    ];
  }
}

String _formatDate(DateTime value) {
  final year = value.year.toString().padLeft(4, '0');
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  return '$year-$month-$day';
}
