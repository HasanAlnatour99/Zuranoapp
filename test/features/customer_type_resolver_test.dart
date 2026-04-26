import 'package:barber_shop_app/features/customers/domain/customer_type_resolver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2026, 4, 25);

  test('VIP wins when isVip is true regardless of inactivity', () {
    final created = now.subtract(const Duration(days: 400));
    final last = now.subtract(const Duration(days: 120));
    expect(
      resolveCustomerType(
        isVip: true,
        createdAt: created,
        lastVisitAt: last,
        totalVisits: 2,
        now: now,
      ),
      CustomerType.vip,
    );
  });

  test('inactive when last visit over 90 days ago', () {
    final created = now.subtract(const Duration(days: 200));
    final last = now.subtract(const Duration(days: 95));
    expect(
      resolveCustomerType(
        isVip: false,
        createdAt: created,
        lastVisitAt: last,
        totalVisits: 5,
        now: now,
      ),
      CustomerType.inactive,
    );
  });

  test('new customer when age <= 30 days and exactly one visit', () {
    final created = now.subtract(const Duration(days: 10));
    expect(
      resolveCustomerType(
        isVip: false,
        createdAt: created,
        lastVisitAt: now.subtract(const Duration(days: 1)),
        totalVisits: 1,
        now: now,
      ),
      CustomerType.newCustomer,
    );
  });

  test('regular when age > 60 days and at least one visit', () {
    final created = now.subtract(const Duration(days: 70));
    expect(
      resolveCustomerType(
        isVip: false,
        createdAt: created,
        lastVisitAt: now.subtract(const Duration(days: 5)),
        totalVisits: 3,
        now: now,
      ),
      CustomerType.regular,
    );
  });
}
