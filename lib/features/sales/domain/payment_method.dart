import 'package:flutter/material.dart';

import '../../../core/constants/sale_reporting.dart';

/// POS payment options on Add Sale (maps to [SalePaymentMethods] strings).
enum PosPaymentMethod { cash, card, mixed }

extension PosPaymentMethodX on PosPaymentMethod {
  String get firestoreValue => switch (this) {
    PosPaymentMethod.cash => SalePaymentMethods.cash,
    PosPaymentMethod.card => SalePaymentMethods.card,
    PosPaymentMethod.mixed => SalePaymentMethods.mixed,
  };

  IconData get icon => switch (this) {
    PosPaymentMethod.cash => Icons.payments_rounded,
    PosPaymentMethod.card => Icons.credit_card_rounded,
    PosPaymentMethod.mixed => Icons.call_split_rounded,
  };
}

PosPaymentMethod? posPaymentMethodFromFirestore(String? raw) {
  switch (raw?.trim()) {
    case SalePaymentMethods.cash:
      return PosPaymentMethod.cash;
    case SalePaymentMethods.card:
      return PosPaymentMethod.card;
    case SalePaymentMethods.mixed:
      return PosPaymentMethod.mixed;
    default:
      return null;
  }
}
