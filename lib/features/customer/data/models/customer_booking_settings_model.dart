import 'package:cloud_firestore/cloud_firestore.dart';

/// Salon owner policy for public customer booking (`salons/{salonId}/settings/customerBooking`).
class CustomerBookingSettingsModel {
  const CustomerBookingSettingsModel({
    required this.salonId,
    required this.customerBookingEnabled,
    required this.allowSameDayBooking,
    required this.requireCustomerPhone,
    required this.requireCustomerName,
    required this.autoConfirmBookings,
    required this.allowGuestBooking,
    required this.minimumNoticeMinutes,
    required this.maxBookingDaysAhead,
    required this.slotDurationMinutes,
    required this.bufferMinutes,
    required this.allowCustomerCancellation,
    required this.cancellationNoticeHours,
    required this.publicBookingMessage,
    this.createdAt,
    this.updatedAt,
    this.updatedBy,
  });

  final String salonId;
  final bool customerBookingEnabled;
  final bool allowSameDayBooking;
  final bool requireCustomerPhone;
  final bool requireCustomerName;
  final bool autoConfirmBookings;
  final bool allowGuestBooking;
  final int minimumNoticeMinutes;
  final int maxBookingDaysAhead;
  final int slotDurationMinutes;
  final int bufferMinutes;
  final bool allowCustomerCancellation;
  final int cancellationNoticeHours;
  final String publicBookingMessage;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? updatedBy;

  static const String defaultPublicMessage =
      'Welcome! Choose your service and preferred time.';

  factory CustomerBookingSettingsModel.defaults(String salonId) {
    return CustomerBookingSettingsModel(
      salonId: salonId,
      customerBookingEnabled: true,
      allowSameDayBooking: true,
      requireCustomerPhone: true,
      requireCustomerName: true,
      autoConfirmBookings: false,
      allowGuestBooking: true,
      minimumNoticeMinutes: 60,
      maxBookingDaysAhead: 30,
      slotDurationMinutes: 30,
      bufferMinutes: 10,
      allowCustomerCancellation: true,
      cancellationNoticeHours: 4,
      publicBookingMessage: defaultPublicMessage,
    );
  }

  factory CustomerBookingSettingsModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snap,
  ) {
    final data = snap.data();
    final salonIdFromPath = snap.reference.parent.parent?.id ?? '';
    final salonId = (data?['salonId'] as String?)?.trim().isNotEmpty == true
        ? data!['salonId'] as String
        : salonIdFromPath;
    if (data == null || !snap.exists) {
      return CustomerBookingSettingsModel.defaults(salonId);
    }
    return CustomerBookingSettingsModel(
      salonId: salonId,
      customerBookingEnabled: _bool(data['customerBookingEnabled'], true),
      allowSameDayBooking: _bool(data['allowSameDayBooking'], true),
      requireCustomerPhone: _bool(data['requireCustomerPhone'], true),
      requireCustomerName: _bool(data['requireCustomerName'], true),
      autoConfirmBookings: _bool(data['autoConfirmBookings'], false),
      allowGuestBooking: _bool(data['allowGuestBooking'], true),
      minimumNoticeMinutes: _int(data['minimumNoticeMinutes'], 60),
      maxBookingDaysAhead: _int(data['maxBookingDaysAhead'], 30),
      slotDurationMinutes: _int(data['slotDurationMinutes'], 30),
      bufferMinutes: _int(data['bufferMinutes'], 10),
      allowCustomerCancellation: _bool(data['allowCustomerCancellation'], true),
      cancellationNoticeHours: _int(data['cancellationNoticeHours'], 4),
      publicBookingMessage: _string(
        data['publicBookingMessage'],
        defaultPublicMessage,
      ),
      createdAt: _dateTime(data['createdAt']),
      updatedAt: _dateTime(data['updatedAt']),
      updatedBy: data['updatedBy'] as String?,
    );
  }

  static bool _bool(Object? value, bool fallback) =>
      value is bool ? value : fallback;

  static int _int(Object? value, int fallback) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.round();
    }
    return fallback;
  }

  static String _string(Object? value, String fallback) {
    if (value is String) {
      return value;
    }
    return fallback;
  }

  static DateTime? _dateTime(Object? value) {
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    return null;
  }

  CustomerBookingSettingsModel copyWith({
    String? salonId,
    bool? customerBookingEnabled,
    bool? allowSameDayBooking,
    bool? requireCustomerPhone,
    bool? requireCustomerName,
    bool? autoConfirmBookings,
    bool? allowGuestBooking,
    int? minimumNoticeMinutes,
    int? maxBookingDaysAhead,
    int? slotDurationMinutes,
    int? bufferMinutes,
    bool? allowCustomerCancellation,
    int? cancellationNoticeHours,
    String? publicBookingMessage,
  }) {
    return CustomerBookingSettingsModel(
      salonId: salonId ?? this.salonId,
      customerBookingEnabled: customerBookingEnabled ?? this.customerBookingEnabled,
      allowSameDayBooking: allowSameDayBooking ?? this.allowSameDayBooking,
      requireCustomerPhone: requireCustomerPhone ?? this.requireCustomerPhone,
      requireCustomerName: requireCustomerName ?? this.requireCustomerName,
      autoConfirmBookings: autoConfirmBookings ?? this.autoConfirmBookings,
      allowGuestBooking: allowGuestBooking ?? this.allowGuestBooking,
      minimumNoticeMinutes: minimumNoticeMinutes ?? this.minimumNoticeMinutes,
      maxBookingDaysAhead: maxBookingDaysAhead ?? this.maxBookingDaysAhead,
      slotDurationMinutes: slotDurationMinutes ?? this.slotDurationMinutes,
      bufferMinutes: bufferMinutes ?? this.bufferMinutes,
      allowCustomerCancellation:
          allowCustomerCancellation ?? this.allowCustomerCancellation,
      cancellationNoticeHours:
          cancellationNoticeHours ?? this.cancellationNoticeHours,
      publicBookingMessage: publicBookingMessage ?? this.publicBookingMessage,
      createdAt: createdAt,
      updatedAt: updatedAt,
      updatedBy: updatedBy,
    );
  }

  Map<String, dynamic> toFirestoreWrite({
    required FieldValue timestamp,
    required String updatedByUid,
    bool includeCreated = false,
  }) {
    final map = <String, dynamic>{
      'salonId': salonId,
      'customerBookingEnabled': customerBookingEnabled,
      'allowSameDayBooking': allowSameDayBooking,
      'requireCustomerPhone': requireCustomerPhone,
      'requireCustomerName': requireCustomerName,
      'autoConfirmBookings': autoConfirmBookings,
      'allowGuestBooking': allowGuestBooking,
      'minimumNoticeMinutes': minimumNoticeMinutes,
      'maxBookingDaysAhead': maxBookingDaysAhead,
      'slotDurationMinutes': slotDurationMinutes,
      'bufferMinutes': bufferMinutes,
      'allowCustomerCancellation': allowCustomerCancellation,
      'cancellationNoticeHours': cancellationNoticeHours,
      'publicBookingMessage': publicBookingMessage,
      'updatedAt': timestamp,
      'updatedBy': updatedByUid,
    };
    if (includeCreated) {
      map['createdAt'] = timestamp;
    }
    return map;
  }

  /// Nested map on `publicSalons/{salonId}` for guest-safe reads.
  Map<String, dynamic> toPublicSalonSettingsMap() {
    return <String, dynamic>{
      'enabled': customerBookingEnabled,
      'customerBookingEnabled': customerBookingEnabled,
      'autoConfirmBookings': autoConfirmBookings,
      'allowSameDayBooking': allowSameDayBooking,
      'requireCustomerPhone': requireCustomerPhone,
      'requireCustomerName': requireCustomerName,
      'allowGuestBooking': allowGuestBooking,
      'minimumNoticeMinutes': minimumNoticeMinutes,
      'maxBookingDaysAhead': maxBookingDaysAhead,
      'maxAdvanceBookingDays': maxBookingDaysAhead,
      'slotDurationMinutes': slotDurationMinutes,
      'bookingSlotIntervalMinutes': slotDurationMinutes,
      'bufferMinutes': bufferMinutes,
      'allowCustomerCancellation': allowCustomerCancellation,
      'cancellationNoticeHours': cancellationNoticeHours,
      'cancellationCutoffMinutes': cancellationNoticeHours * 60,
      'publicBookingMessage': publicBookingMessage,
      'allowAnyAvailableEmployee': true,
      'requireBookingCodeForLookup': false,
      'showPricesToCustomers': true,
      'allowCustomerNotes': true,
      'allowCustomerFeedback': true,
      'rescheduleCutoffMinutes': 120,
    };
  }

  /// Compare editable fields (ignores timestamps / updatedBy).
  bool samePolicyAs(CustomerBookingSettingsModel other) {
    return customerBookingEnabled == other.customerBookingEnabled &&
        allowSameDayBooking == other.allowSameDayBooking &&
        requireCustomerPhone == other.requireCustomerPhone &&
        requireCustomerName == other.requireCustomerName &&
        autoConfirmBookings == other.autoConfirmBookings &&
        allowGuestBooking == other.allowGuestBooking &&
        minimumNoticeMinutes == other.minimumNoticeMinutes &&
        maxBookingDaysAhead == other.maxBookingDaysAhead &&
        slotDurationMinutes == other.slotDurationMinutes &&
        bufferMinutes == other.bufferMinutes &&
        allowCustomerCancellation == other.allowCustomerCancellation &&
        cancellationNoticeHours == other.cancellationNoticeHours &&
        publicBookingMessage == other.publicBookingMessage;
  }

  /// Returns a localization key suffix or null if valid.
  String? validationErrorKey() {
    if (minimumNoticeMinutes < 0) {
      return 'minNotice';
    }
    if (maxBookingDaysAhead <= 0) {
      return 'maxDays';
    }
    if (slotDurationMinutes <= 0) {
      return 'slotDuration';
    }
    if (bufferMinutes < 0) {
      return 'buffer';
    }
    if (allowCustomerCancellation && cancellationNoticeHours <= 0) {
      return 'cancelHours';
    }
    if (publicBookingMessage.length > 250) {
      return 'messageLength';
    }
    return null;
  }
}
