import 'package:barber_shop_app/features/ai/data/firebase_owner_dashboard_ai_service.dart';
import 'package:barber_shop_app/features/ai/domain/models/ai_surface_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OwnerDashboardAiService.inferTimeframe', () {
    test('detects rolling last 7 days prompts', () {
      final timeframe = OwnerDashboardAiService.inferTimeframe(
        'show revenue for the last 7 days',
        now: DateTime(2026, 4, 19),
      );

      expect(timeframe.range, AiTimeRange.last7Days);
      expect(timeframe.hasSpecificMonth, false);
    });

    test('detects explicit english month prompts', () {
      final timeframe = OwnerDashboardAiService.inferTimeframe(
        'show top barbers for March 2025',
        now: DateTime(2026, 4, 19),
      );

      expect(timeframe.range, AiTimeRange.month);
      expect(timeframe.year, 2025);
      expect(timeframe.month, 3);
    });

    test('detects explicit arabic month prompts', () {
      final timeframe = OwnerDashboardAiService.inferTimeframe(
        'اعرض ايرادات يناير 2024',
        now: DateTime(2026, 4, 19),
      );

      expect(timeframe.range, AiTimeRange.month);
      expect(timeframe.year, 2024);
      expect(timeframe.month, 1);
    });

    test('uses current month for generic month prompts', () {
      final timeframe = OwnerDashboardAiService.inferTimeframe(
        'show this month revenue',
        now: DateTime(2026, 4, 19),
      );

      expect(timeframe.range, AiTimeRange.month);
      expect(timeframe.year, 2026);
      expect(timeframe.month, 4);
    });

    test('detects explicit english quarter prompts', () {
      final timeframe = OwnerDashboardAiService.inferTimeframe(
        'show revenue for Q2 2025',
        now: DateTime(2026, 4, 19),
      );

      expect(timeframe.range, AiTimeRange.quarter);
      expect(timeframe.year, 2025);
      expect(timeframe.quarter, 2);
    });

    test('detects generic quarter prompts', () {
      final timeframe = OwnerDashboardAiService.inferTimeframe(
        'show top barbers this quarter',
        now: DateTime(2026, 4, 19),
      );

      expect(timeframe.range, AiTimeRange.quarter);
      expect(timeframe.year, 2026);
      expect(timeframe.quarter, 2);
    });

    test('detects explicit ISO date ranges', () {
      final timeframe = OwnerDashboardAiService.inferTimeframe(
        'show revenue from 2025-03-01 to 2025-03-15',
        now: DateTime(2026, 4, 19),
      );

      expect(timeframe.range, AiTimeRange.custom);
      expect(timeframe.startDate, DateTime(2025, 3, 1));
      expect(timeframe.endDate, DateTime(2025, 3, 15));
    });
  });
}
