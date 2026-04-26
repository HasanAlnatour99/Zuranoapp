import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceCorrectionRequestModel {
  const AttendanceCorrectionRequestModel({
    required this.id,
    required this.salonId,
    required this.employeeId,
    required this.employeeName,
    required this.attendanceId,
    required this.attendanceDate,
    required this.dateKey,
    required this.requestType,
    required this.requestedCheckInAt,
    required this.requestedCheckOutAt,
    required this.reason,
    required this.status,
    required this.reviewNote,
  });

  final String id;
  final String salonId;
  final String employeeId;
  final String employeeName;
  final String attendanceId;
  final String attendanceDate;
  final int dateKey;
  final String requestType;
  final DateTime? requestedCheckInAt;
  final DateTime? requestedCheckOutAt;
  final String reason;
  final String status;
  final String reviewNote;

  factory AttendanceCorrectionRequestModel.fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};

    DateTime? readTimestamp(String key) {
      final value = data[key];
      if (value is Timestamp) return value.toDate();
      return null;
    }

    final dateKeyRaw = data['dateKey'];
    final int dateKeyParsed = switch (dateKeyRaw) {
      int v => v,
      num v => v.toInt(),
      String v => int.tryParse(v.replaceAll('-', '')) ?? 0,
      _ => 0,
    };

    return AttendanceCorrectionRequestModel(
      id: doc.id,
      salonId: data['salonId']?.toString() ?? '',
      employeeId: data['employeeId']?.toString() ?? '',
      employeeName: data['employeeName']?.toString() ?? '',
      attendanceId: data['attendanceId']?.toString() ?? '',
      attendanceDate: data['attendanceDate']?.toString() ?? '',
      dateKey: dateKeyParsed,
      requestType: data['requestType']?.toString() ?? '',
      requestedCheckInAt: readTimestamp('requestedCheckInAt'),
      requestedCheckOutAt: readTimestamp('requestedCheckOutAt'),
      reason: data['reason']?.toString() ?? '',
      status: data['status']?.toString() ?? 'pending',
      reviewNote: data['reviewNote']?.toString() ?? '',
    );
  }
}
