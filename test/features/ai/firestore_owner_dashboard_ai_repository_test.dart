import 'package:barber_shop_app/features/ai/data/firestore_owner_dashboard_ai_repository.dart';
import 'package:barber_shop_app/features/ai/domain/models/ai_surface_response.dart';
import 'package:barber_shop_app/features/employees/data/models/employee.dart';
import 'package:barber_shop_app/features/sales/data/models/sale.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FirestoreOwnerDashboardAiRepository.buildRevenueSummary', () {
    test('returns zero-safe average for empty results', () {
      final summary = FirestoreOwnerDashboardAiRepository.buildRevenueSummary(
        range: AiTimeRange.today,
        rangeLabel: 'today',
        currencyCode: 'USD',
        grossSales: 0,
        transactionCount: 0,
      );

      expect(summary.grossSales, 0);
      expect(summary.transactionCount, 0);
      expect(summary.averageTicket, 0);
      expect(summary.rangeLabel, 'today');
    });
  });

  group('FirestoreOwnerDashboardAiRepository.resolveRangeWindow', () {
    test('builds a rolling last 7 days window', () {
      final window = FirestoreOwnerDashboardAiRepository.resolveRangeWindow(
        const AiTimeframe(range: AiTimeRange.last7Days),
        now: DateTime(2026, 4, 19, 14, 30),
      );

      expect(window.start, DateTime(2026, 4, 13));
      expect(window.end, DateTime(2026, 4, 20));
      expect(window.label, 'last_7_days');
    });

    test('builds explicit calendar month windows', () {
      final window = FirestoreOwnerDashboardAiRepository.resolveRangeWindow(
        const AiTimeframe(range: AiTimeRange.month, year: 2025, month: 12),
        now: DateTime(2026, 4, 19, 14, 30),
      );

      expect(window.start, DateTime(2025, 12, 1));
      expect(window.end, DateTime(2026, 1, 1));
      expect(window.label, '2025-12');
    });

    test('builds explicit quarter windows', () {
      final window = FirestoreOwnerDashboardAiRepository.resolveRangeWindow(
        const AiTimeframe(range: AiTimeRange.quarter, year: 2025, quarter: 2),
        now: DateTime(2026, 4, 19, 14, 30),
      );

      expect(window.start, DateTime(2025, 4, 1));
      expect(window.end, DateTime(2025, 7, 1));
      expect(window.label, '2025-Q2');
    });

    test('builds inclusive custom date windows', () {
      final window = FirestoreOwnerDashboardAiRepository.resolveRangeWindow(
        AiTimeframe(
          range: AiTimeRange.custom,
          startDate: DateTime(2025, 3, 1),
          endDate: DateTime(2025, 3, 15),
        ),
        now: DateTime(2026, 4, 19, 14, 30),
      );

      expect(window.start, DateTime(2025, 3, 1));
      expect(window.end, DateTime(2025, 3, 16));
      expect(window.label, '2025-03-01_2025-03-15');
    });
  });

  group('FirestoreOwnerDashboardAiRepository.buildTopBarberSnapshots', () {
    test('sorts by sales amount and assigns ranks deterministically', () {
      final sales = [
        _sale(id: 's1', employeeId: 'e1', employeeName: 'Omar', total: 220),
        _sale(id: 's2', employeeId: 'e2', employeeName: 'Adam', total: 300),
        _sale(id: 's3', employeeId: 'e1', employeeName: 'Omar', total: 180),
        _sale(
          id: 's4',
          employeeId: 'e3',
          employeeName: 'Zaid',
          total: 400,
          status: 'pending',
        ),
      ];

      final employees = {
        'e1': _employee(id: 'e1', name: 'Omar A', avatarUrl: 'omar.png'),
        'e2': _employee(id: 'e2', name: 'Adam B'),
      };

      final result =
          FirestoreOwnerDashboardAiRepository.buildTopBarberSnapshots(
            sales: sales,
            employeesById: employees,
          );

      expect(result.length, 2);
      expect(result.first.employeeId, 'e1');
      expect(result.first.employeeName, 'Omar A');
      expect(result.first.salesAmount, 400);
      expect(result.first.transactionsCount, 2);
      expect(result.first.averageTicket, 200);
      expect(result.first.rank, 1);
      expect(result.first.photoUrl, 'omar.png');

      expect(result[1].employeeId, 'e2');
      expect(result[1].rank, 2);
    });

    test(
      'falls back to denormalized sale data when employee doc is missing',
      () {
        final sales = [
          _sale(
            id: 's1',
            employeeId: '',
            barberId: 'missing-barber',
            employeeName: 'Fallback Barber',
            total: 150,
          ),
        ];

        final result =
            FirestoreOwnerDashboardAiRepository.buildTopBarberSnapshots(
              sales: sales,
              employeesById: const {},
            );

        expect(result.length, 1);
        expect(result.first.employeeId, 'missing-barber');
        expect(result.first.employeeName, 'Fallback Barber');
        expect(result.first.salesAmount, 150);
        expect(result.first.transactionsCount, 1);
        expect(result.first.averageTicket, 150);
        expect(result.first.rank, 1);
      },
    );

    test('returns empty list when there are no completed sales', () {
      final result =
          FirestoreOwnerDashboardAiRepository.buildTopBarberSnapshots(
            sales: [
              _sale(
                id: 's1',
                employeeId: 'e1',
                employeeName: 'Omar',
                total: 150,
                status: 'pending',
              ),
            ],
            employeesById: const {},
          );

      expect(result, isEmpty);
    });
  });
}

Sale _sale({
  required String id,
  required String employeeId,
  required String employeeName,
  required double total,
  String barberId = '',
  String status = 'completed',
}) {
  return Sale(
    id: id,
    salonId: 'salon-1',
    employeeId: employeeId,
    barberId: barberId,
    employeeName: employeeName,
    lineItems: const [],
    serviceNames: const ['Cut'],
    subtotal: total,
    tax: 0,
    discount: 0,
    total: total,
    paymentMethod: 'cash',
    status: status,
    soldAt: DateTime(2026, 4, 19, 10),
  );
}

Employee _employee({
  required String id,
  required String name,
  String? avatarUrl,
}) {
  return Employee(
    id: id,
    salonId: 'salon-1',
    name: name,
    email: '$id@example.com',
    role: 'barber',
    avatarUrl: avatarUrl,
  );
}
