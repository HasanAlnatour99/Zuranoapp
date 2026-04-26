import 'package:cloud_firestore/cloud_firestore.dart';

/// Customer-safe team row from `publicSalons/{salonId}/team/{employeeId}` (never private `employees` docs).
class CustomerTeamMemberPublicModel {
  const CustomerTeamMemberPublicModel({
    required this.id,
    required this.salonId,
    required this.fullName,
    required this.displayName,
    required this.roleLabel,
    this.profileImageUrl,
    this.specialties = const [],
    required this.isActive,
    required this.isBookable,
    required this.allowCustomerBooking,
    required this.ratingAverage,
    required this.ratingCount,
    required this.sortOrder,
    this.updatedAt,
  });

  final String id;
  final String salonId;
  final String fullName;
  final String displayName;
  final String roleLabel;
  final String? profileImageUrl;
  final List<String> specialties;
  final bool isActive;
  final bool isBookable;
  final bool allowCustomerBooking;
  final double ratingAverage;
  final int ratingCount;
  final int sortOrder;
  final DateTime? updatedAt;

  /// Primary line for name chips / headers (display name with full name fallback).
  String get displayTitle =>
      displayName.trim().isNotEmpty ? displayName.trim() : fullName.trim();

  static DateTime? _ts(Object? value) {
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    return null;
  }

  static List<String> _specialties(Object? v) {
    if (v is List) {
      return v
          .map((e) => '$e'.trim())
          .where((s) => s.isNotEmpty)
          .toList(growable: false);
    }
    return const [];
  }

  static double _double(Object? v, double fallback) {
    if (v is num) {
      return v.toDouble();
    }
    return fallback;
  }

  static int _int(Object? v, int fallback) {
    if (v is int) {
      return v;
    }
    if (v is num) {
      return v.round();
    }
    return fallback;
  }

  static String _string(Object? value) {
    return value is String ? value.trim() : '';
  }

  factory CustomerTeamMemberPublicModel.fromFirestore(
    DocumentSnapshot doc,
    String salonId,
  ) {
    final raw = doc.data();
    final data = raw is Map<String, dynamic> ? raw : const <String, dynamic>{};
    final fullNameRaw = _string(data['fullName']);
    final nameFallback = _string(data['name']);
    final fullName = fullNameRaw.isNotEmpty
        ? fullNameRaw
        : (nameFallback.isNotEmpty ? nameFallback : 'Team member');

    final displayNameRaw = _string(data['displayName']);
    final displayName = displayNameRaw.isNotEmpty ? displayNameRaw : fullName;

    final roleLabelRaw = _string(data['roleLabel']);
    final roleLabel = roleLabelRaw.isNotEmpty ? roleLabelRaw : 'Specialist';

    final avatar = _string(data['profileImageUrl']);
    final legacyAvatar = _string(data['avatarUrl']);
    final profileImageUrl = avatar.isNotEmpty
        ? avatar
        : (legacyAvatar.isNotEmpty ? legacyAvatar : null);

    final bookable = data['isBookable'] == true;
    final allowCustomer = data['allowCustomerBooking'] == true || bookable;

    return CustomerTeamMemberPublicModel(
      id: doc.id,
      salonId: _string(data['salonId']).isNotEmpty
          ? _string(data['salonId'])
          : salonId,
      fullName: fullName,
      displayName: displayName,
      roleLabel: roleLabel,
      profileImageUrl: profileImageUrl,
      specialties: _specialties(data['specialties']),
      isActive: data['isActive'] == true,
      isBookable: bookable,
      allowCustomerBooking: allowCustomer,
      ratingAverage: _double(data['ratingAverage'], 0).clamp(0.0, 5.0),
      ratingCount: _int(data['ratingCount'], 0),
      sortOrder: _int(data['sortOrder'], _int(data['displayOrder'], 999)),
      updatedAt: _ts(data['updatedAt']),
    );
  }
}
