import 'package:barber_shop_app/features/insights/data/models/salon_insight.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('SalonInsight.fromJson maps Firestore-shaped maps', () {
    final i = SalonInsight.fromJson('2026_W16_top_barber_revenue', {
      'type': 'top_barber_revenue',
      'title': 'Top barber by revenue',
      'message': 'Ann led with 120.00 in completed sales.',
      'period': 'weekly',
      'value': 120.0,
      'weekKey': '2026_W15',
      'createdAt': DateTime.utc(2026, 4, 20, 5, 0, 0),
    });

    expect(i.id, '2026_W16_top_barber_revenue');
    expect(i.type, 'top_barber_revenue');
    expect(i.title, 'Top barber by revenue');
    expect(i.message, contains('Ann'));
    expect(i.period, 'weekly');
    expect(i.value, 120.0);
    expect(i.weekKey, '2026_W15');
    expect(i.createdAt, isNotNull);
  });

  test('SalonInsight.fromJson uses defaults for missing fields', () {
    final i = SalonInsight.fromJson('x', {});
    expect(i.type, '');
    expect(i.period, 'weekly');
    expect(i.value, 0.0);
    expect(i.title, '');
  });

  test('SalonInsight parses customer_retention payload', () {
    final i = SalonInsight.fromJson('2026_W16_customer_retention', {
      'type': 'customer_retention',
      'period': 'weekly',
      'value': 0,
      'payload': {
        'timeZone': 'UTC',
        'calendarYear': 2026,
        'calendarMonth': 4,
        'repeatCustomersThisMonth': 2,
        'firstTimeCustomersThisMonth': 1,
        'distinctCustomersCompletedThisMonth': 4,
        'returningCustomersThisMonth': 2,
        'retentionRate': 0.5,
        'customersWithNoVisit30Days': 3,
        'noShowCountLastLocalWeek': 1,
        'noShowCountPreviousLocalWeek': 2,
        'noShowDeltaLastVsPrevious': -1,
      },
    });
    expect(i.retentionPayload, isNotNull);
    expect(i.retentionPayload!.repeatCustomersThisMonth, 2);
    expect(i.retentionPayload!.retentionRate, 0.5);
    expect(i.retentionPayload!.noShowDeltaLastVsPrevious, -1);
  });
}
