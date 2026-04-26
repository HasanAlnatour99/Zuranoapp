/// Common `salons/{salonId}/sales/{id}.paymentMethod` values (extend as needed).
abstract final class SalePaymentMethods {
  static const cash = 'cash';
  static const card = 'card';

  /// Split payment (cash + card, etc.).
  static const mixed = 'mixed';
  static const digitalWallet = 'digital_wallet';
  static const other = 'other';
}

/// Common `salons/{salonId}/sales/{id}.status` values for analytics and refunds.
abstract final class SaleStatuses {
  static const completed = 'completed';
  static const pending = 'pending';
  static const refunded = 'refunded';
  static const voided = 'voided';
}
