import 'package:cloud_firestore/cloud_firestore.dart';

/// Public review row under `salons/{salonId}/reviews/{reviewId}`.
class CustomerReviewModel {
  const CustomerReviewModel({
    required this.id,
    required this.salonId,
    this.bookingId,
    this.customerId,
    required this.customerName,
    required this.rating,
    this.comment,
    this.createdAt,
  });

  final String id;
  final String salonId;
  final String? bookingId;
  final String? customerId;
  final String customerName;
  final double rating;
  final String? comment;
  final DateTime? createdAt;

  static DateTime? _ts(Timestamp? t) => t?.toDate();

  /// First name or anonymized label for display.
  static String displayCustomerName(String? raw) {
    final s = raw?.trim();
    if (s == null || s.isEmpty) {
      return 'Customer';
    }
    final parts = s.split(RegExp(r'\s+'));
    return parts.first;
  }

  factory CustomerReviewModel.fromFirestore(
    DocumentSnapshot doc,
    String salonId,
  ) {
    final raw = doc.data();
    final data = raw is Map<String, dynamic> ? raw : const <String, dynamic>{};
    final nameRaw = (data['customerName'] as String?)?.trim();
    return CustomerReviewModel(
      id: doc.id,
      salonId: (data['salonId'] as String?)?.trim().isNotEmpty == true
          ? (data['salonId'] as String).trim()
          : salonId,
      bookingId: (data['bookingId'] as String?)?.trim(),
      customerId: (data['customerId'] as String?)?.trim(),
      customerName: displayCustomerName(nameRaw),
      rating: _double(data['rating'], 0).clamp(0.0, 5.0),
      comment: (data['comment'] as String?)?.trim(),
      createdAt: _ts(data['createdAt'] as Timestamp?),
    );
  }

  static double _double(Object? v, double fallback) {
    if (v is num) {
      return v.toDouble();
    }
    return fallback;
  }
}
