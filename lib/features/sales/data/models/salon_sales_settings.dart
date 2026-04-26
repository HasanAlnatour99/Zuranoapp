import '../../../../core/firestore/firestore_serializers.dart';

/// `salons/{salonId}/settings/sales` — POS policy for staff-created sales.
class SalonSalesSettings {
  const SalonSalesSettings({
    required this.allowEmployeeAddSale,
    required this.requireCardReceiptPhoto,
    required this.requireCashReceiptPhoto,
    required this.allowMixedPayment,
    required this.allowEmployeeDiscount,
    required this.maxDiscountPercentForEmployee,
    required this.saleNeedsApproval,
  });

  final bool allowEmployeeAddSale;
  final bool requireCardReceiptPhoto;
  final bool requireCashReceiptPhoto;
  final bool allowMixedPayment;
  final bool allowEmployeeDiscount;
  final double maxDiscountPercentForEmployee;
  final bool saleNeedsApproval;

  static SalonSalesSettings defaults() => const SalonSalesSettings(
    allowEmployeeAddSale: true,
    requireCardReceiptPhoto: false,
    requireCashReceiptPhoto: false,
    allowMixedPayment: true,
    allowEmployeeDiscount: false,
    maxDiscountPercentForEmployee: 0,
    saleNeedsApproval: false,
  );

  factory SalonSalesSettings.fromMap(Map<String, dynamic>? data) {
    if (data == null || data.isEmpty) {
      return defaults();
    }
    return SalonSalesSettings(
      allowEmployeeAddSale: FirestoreSerializers.boolValue(
        data['allowEmployeeAddSale'],
        fallback: true,
      ),
      requireCardReceiptPhoto: FirestoreSerializers.boolValue(
        data['requireCardReceiptPhoto'],
        fallback: false,
      ),
      requireCashReceiptPhoto: FirestoreSerializers.boolValue(
        data['requireCashReceiptPhoto'],
        fallback: false,
      ),
      allowMixedPayment: FirestoreSerializers.boolValue(
        data['allowMixedPayment'],
        fallback: true,
      ),
      allowEmployeeDiscount: FirestoreSerializers.boolValue(
        data['allowEmployeeDiscount'],
        fallback: false,
      ),
      maxDiscountPercentForEmployee: FirestoreSerializers.doubleValue(
        data['maxDiscountPercentForEmployee'],
      ),
      saleNeedsApproval: FirestoreSerializers.boolValue(
        data['saleNeedsApproval'],
        fallback: false,
      ),
    );
  }
}
