import 'package:cloud_firestore/cloud_firestore.dart';

/// Customer-safe service row from `publicSalons/{salonId}/services/{serviceId}`.
class CustomerServicePublicModel {
  const CustomerServicePublicModel({
    required this.id,
    required this.salonId,
    required this.name,
    required this.displayName,
    required this.category,
    required this.categoryLabel,
    this.description,
    required this.price,
    required this.durationMinutes,
    this.imageUrl,
    required this.isActive,
    required this.isCustomerVisible,
    required this.sortOrder,
    this.searchKeywords = const [],
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String salonId;
  final String name;
  final String displayName;
  final String category;
  final String categoryLabel;
  final String? description;
  final double price;
  final int durationMinutes;
  final String? imageUrl;
  final bool isActive;
  final bool isCustomerVisible;
  final int sortOrder;
  final List<String> searchKeywords;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Title line (display name with name fallback).
  String get displayTitle =>
      displayName.trim().isNotEmpty ? displayName.trim() : name.trim();

  static DateTime? _ts(Object? value) {
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    return null;
  }

  static List<String> _stringList(Object? v) {
    if (v is List) {
      return v
          .map((e) => '$e'.trim().toLowerCase())
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

  factory CustomerServicePublicModel.fromFirestore(
    DocumentSnapshot doc,
    String salonId,
  ) {
    final raw = doc.data();
    final data = raw is Map<String, dynamic> ? raw : const <String, dynamic>{};

    final nameRaw = _string(data['name']);
    final displayNameRaw = _string(data['displayName']);
    final name = nameRaw.isNotEmpty ? nameRaw : 'Service';
    final displayName = displayNameRaw.isNotEmpty ? displayNameRaw : name;

    final categoryRaw = _string(data['category']);
    final categoryLabelRaw = _string(data['categoryLabel']);
    final category = categoryRaw.isNotEmpty ? categoryRaw : 'Other';
    final categoryLabel = categoryLabelRaw.isNotEmpty
        ? categoryLabelRaw
        : category;

    final vis = data['isCustomerVisible'];
    final isCustomerVisible = vis is bool ? vis : true;

    var duration = _int(data['durationMinutes'], 0);
    if (duration <= 0) {
      duration = _int(data['duration'], 30);
    }
    if (duration <= 0) {
      duration = 30;
    }

    return CustomerServicePublicModel(
      id: doc.id,
      salonId: _string(data['salonId']).isNotEmpty
          ? _string(data['salonId'])
          : salonId,
      name: name,
      displayName: displayName,
      category: category,
      categoryLabel: categoryLabel,
      description: _string(data['description']).isNotEmpty
          ? _string(data['description'])
          : null,
      price: _double(data['price'], 0),
      durationMinutes: duration,
      imageUrl: _string(data['imageUrl']).isNotEmpty
          ? _string(data['imageUrl'])
          : null,
      isActive: data['isActive'] == true,
      isCustomerVisible: isCustomerVisible,
      sortOrder: _int(data['sortOrder'], 999),
      searchKeywords: _stringList(data['searchKeywords']),
      createdAt: _ts(data['createdAt']),
      updatedAt: _ts(data['updatedAt']),
    );
  }
}
