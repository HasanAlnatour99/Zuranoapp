/// Business-facing customer lifecycle (VIP is manual; others are derived).
enum CustomerType { vip, newCustomer, regular, inactive }

/// Priority: VIP → inactive → new → regular → fallback.
CustomerType resolveCustomerType({
  required bool isVip,
  required DateTime createdAt,
  required DateTime? lastVisitAt,
  required int totalVisits,
  required DateTime now,
}) {
  if (isVip) return CustomerType.vip;

  final customerAgeDays = now.difference(createdAt).inDays;
  final daysSinceLastVisit = lastVisitAt == null
      ? null
      : now.difference(lastVisitAt).inDays;

  if (daysSinceLastVisit != null && daysSinceLastVisit > 90) {
    return CustomerType.inactive;
  }

  if (customerAgeDays <= 30 && totalVisits == 1) {
    return CustomerType.newCustomer;
  }

  if (customerAgeDays > 60 && totalVisits >= 1) {
    return CustomerType.regular;
  }

  if (totalVisits == 0) {
    return CustomerType.newCustomer;
  }

  return CustomerType.regular;
}
