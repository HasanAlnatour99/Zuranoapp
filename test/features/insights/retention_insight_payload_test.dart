import 'package:barber_shop_app/features/insights/data/models/retention_insight_payload.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('RetentionInsightPayload.tryParse reads ints from JSON-like map', () {
    final p = RetentionInsightPayload.tryParse({
      'timeZone': 'America/New_York',
      'calendarYear': 2026,
      'calendarMonth': 4,
      'repeatCustomersThisMonth': 5,
      'firstTimeCustomersThisMonth': 3,
      'distinctCustomersCompletedThisMonth': 10,
      'returningCustomersThisMonth': 4,
      'retentionRate': 0.4,
      'customersWithNoVisit30Days': 7,
      'noShowCountLastLocalWeek': 1,
      'noShowCountPreviousLocalWeek': 4,
      'noShowDeltaLastVsPrevious': -3,
    });
    expect(p, isNotNull);
    expect(p!.timeZone, 'America/New_York');
    expect(p.retentionRate, 0.4);
    expect(p.customersWithNoVisit30Days, 7);
  });
}
