import '../../../../core/firestore/firestore_json_helpers.dart';

class CustomerNote {
  const CustomerNote({
    required this.id,
    required this.salonId,
    required this.customerId,
    required this.type,
    required this.text,
    this.createdAt,
    this.createdBy,
  });

  final String id;
  final String salonId;
  final String customerId;
  final String type;
  final String text;
  final DateTime? createdAt;
  final String? createdBy;

  factory CustomerNote.fromJson(Map<String, dynamic> json) {
    return CustomerNote(
      id: looseStringFromJson(json['id']),
      salonId: looseStringFromJson(json['salonId']),
      customerId: looseStringFromJson(json['customerId']),
      type: looseStringFromJson(json['type']),
      text: looseStringFromJson(json['text']),
      createdAt: nullableFirestoreDateTimeFromJson(json['createdAt']),
      createdBy: nullableLooseStringFromJson(json['createdBy']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'salonId': salonId,
      'customerId': customerId,
      'type': type,
      'text': text,
      'createdAt': nullableFirestoreDateTimeToJson(createdAt),
      'createdBy': createdBy,
    };
  }
}
