// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AttendanceRecord _$AttendanceRecordFromJson(Map<String, dynamic> json) =>
    _AttendanceRecord(
      id: looseStringFromJson(json['id']),
      salonId: looseStringFromJson(json['salonId']),
      employeeId: looseStringFromJson(json['employeeId']),
      employeeName: looseStringFromJson(json['employeeName']),
      workDate: firestoreDateTimeFromJson(json['workDate']),
      dateKey: json['dateKey'] == null
          ? ''
          : looseStringFromJson(json['dateKey']),
      status: _statusFromJson(json['status']),
      checkInAt: nullableFirestoreDateTimeFromJson(json['checkInAt']),
      checkOutAt: nullableFirestoreDateTimeFromJson(json['checkOutAt']),
      minutesLate: json['minutesLate'] == null
          ? 0
          : looseIntFromJson(json['minutesLate']),
      needsCorrection: json['needsCorrection'] == null
          ? false
          : falseBoolFromJson(json['needsCorrection']),
      notes: nullableLooseStringFromJson(json['notes']),
      approvalStatus: json['approvalStatus'] == null
          ? AttendanceApprovalStatuses.pending
          : _approvalStatusFromJson(json['approvalStatus']),
      approvedByUid: nullableLooseStringFromJson(json['approvedByUid']),
      approvedByName: nullableLooseStringFromJson(json['approvedByName']),
      approvedAt: nullableFirestoreDateTimeFromJson(json['approvedAt']),
      rejectionReason: nullableLooseStringFromJson(json['rejectionReason']),
      createdAt: nullableFirestoreDateTimeFromJson(json['createdAt']),
      updatedAt: nullableFirestoreDateTimeFromJson(json['updatedAt']),
    );

Map<String, dynamic> _$AttendanceRecordToJson(_AttendanceRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'salonId': instance.salonId,
      'employeeId': instance.employeeId,
      'employeeName': instance.employeeName,
      'workDate': firestoreDateTimeToJson(instance.workDate),
      'dateKey': instance.dateKey,
      'status': instance.status,
      'checkInAt': nullableFirestoreDateTimeToJson(instance.checkInAt),
      'checkOutAt': nullableFirestoreDateTimeToJson(instance.checkOutAt),
      'minutesLate': instance.minutesLate,
      'needsCorrection': instance.needsCorrection,
      'notes': instance.notes,
      'approvalStatus': instance.approvalStatus,
      'approvedByUid': instance.approvedByUid,
      'approvedByName': instance.approvedByName,
      'approvedAt': nullableFirestoreDateTimeToJson(instance.approvedAt),
      'rejectionReason': instance.rejectionReason,
      'createdAt': nullableFirestoreDateTimeToJson(instance.createdAt),
      'updatedAt': nullableFirestoreDateTimeToJson(instance.updatedAt),
    };
