import '../data/models/customer.dart';
import 'customer_type_resolver.dart';

export 'customer_type_resolver.dart' show CustomerType, resolveCustomerType;

/// Domain-facing alias — salon customers are persisted as [Customer].
typedef CustomerModel = Customer;

/// Parsed lifecycle segment for list filters / badges (Firestore `category`).
enum CustomerSegment { newCustomer, regular, vip }

CustomerSegment segmentForCustomer(Customer c) {
  if (c.isVip) return CustomerSegment.vip;
  final t = resolveCustomerType(
    isVip: c.isVip,
    createdAt: c.createdAt ?? DateTime.now(),
    lastVisitAt: c.lastVisitAt,
    totalVisits: c.totalVisits,
    now: DateTime.now(),
  );
  return switch (t) {
    CustomerType.vip => CustomerSegment.vip,
    CustomerType.regular => CustomerSegment.regular,
    CustomerType.inactive => CustomerSegment.regular,
    CustomerType.newCustomer => CustomerSegment.newCustomer,
  };
}
