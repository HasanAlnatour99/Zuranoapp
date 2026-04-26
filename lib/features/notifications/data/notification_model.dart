import '../../../../core/firestore/firestore_serializers.dart';

class AppNotificationItem {
  const AppNotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.data,
    required this.status,
    this.createdAt,
    this.readAt,
    this.actorRole,
    this.salonId,
    this.bookingId,
    this.employeeId,
    this.payrollId,
    this.violationId,
  });

  final String id;
  final String type;
  final String title;
  final String body;
  final Map<String, dynamic> data;
  final String status;
  final DateTime? createdAt;
  final DateTime? readAt;
  final String? actorRole;
  final String? salonId;
  final String? bookingId;
  final String? employeeId;
  final String? payrollId;
  final String? violationId;

  bool get isUnread => status == 'unread';

  factory AppNotificationItem.fromDoc(String id, Map<String, dynamic> json) {
    final rawData = json['data'];
    return AppNotificationItem(
      id: id,
      type: FirestoreSerializers.string(json['type']) ?? '',
      title: FirestoreSerializers.string(json['title']) ?? '',
      body: FirestoreSerializers.string(json['body']) ?? '',
      data: rawData is Map<String, dynamic>
          ? Map<String, dynamic>.from(rawData)
          : <String, dynamic>{},
      status: FirestoreSerializers.string(json['status']) ?? 'unread',
      createdAt: FirestoreSerializers.dateTime(json['createdAt']),
      readAt: FirestoreSerializers.dateTime(json['readAt']),
      actorRole: FirestoreSerializers.string(json['actorRole']),
      salonId: FirestoreSerializers.string(json['salonId']),
      bookingId: FirestoreSerializers.string(json['bookingId']),
      employeeId: FirestoreSerializers.string(json['employeeId']),
      payrollId: FirestoreSerializers.string(json['payrollId']),
      violationId: FirestoreSerializers.string(json['violationId']),
    );
  }
}
