import 'package:cloud_firestore/cloud_firestore.dart';

import 'firestore_serializers.dart';

String looseStringFromJson(Object? value) =>
    FirestoreSerializers.string(value) ?? '';

String? nullableLooseStringFromJson(Object? value) =>
    FirestoreSerializers.string(value);

int looseIntFromJson(Object? value) => FirestoreSerializers.intValue(value);

int? nullableLooseIntFromJson(Object? value) =>
    value == null ? null : FirestoreSerializers.intValue(value);

double looseDoubleFromJson(Object? value) =>
    FirestoreSerializers.doubleValue(value);

double? nullableLooseDoubleFromJson(Object? value) =>
    value == null ? null : FirestoreSerializers.doubleValue(value);

bool falseBoolFromJson(Object? value) =>
    FirestoreSerializers.boolValue(value, fallback: false);

bool trueBoolFromJson(Object? value) =>
    FirestoreSerializers.boolValue(value, fallback: true);

DateTime? nullableFirestoreDateTimeFromJson(Object? value) =>
    FirestoreSerializers.dateTime(value);

Object? nullableFirestoreDateTimeToJson(DateTime? value) => value;

DateTime firestoreDateTimeFromJson(Object? value) =>
    FirestoreSerializers.dateTime(value) ??
    DateTime.fromMillisecondsSinceEpoch(0);

Object firestoreDateTimeToJson(DateTime value) => value;

List<String> stringListFromJson(Object? value) =>
    FirestoreSerializers.stringList(value);

List<Map<String, dynamic>> mapListFromJson(Object? value) =>
    FirestoreSerializers.mapList(value);

Map<String, dynamic>? nullableStringDynamicMapFromJson(Object? value) {
  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }
  return null;
}

Map<String, int> stringIntMapFromJson(Object? value) {
  if (value is! Map) {
    return const <String, int>{};
  }

  final counts = <String, int>{};
  for (final entry in value.entries) {
    final key = entry.key.toString();
    final parsedValue = FirestoreSerializers.intValue(entry.value);
    if (key.isNotEmpty && parsedValue > 0) {
      counts[key] = parsedValue;
    }
  }
  return counts;
}

Map<String, dynamic>? nullableStringDynamicMapToJson(
  Map<String, dynamic>? value,
) => value;

Map<String, int> stringIntMapToJson(Map<String, int> value) => value;

Timestamp? nullableTimestampFromDateTime(DateTime? value) =>
    value == null ? null : Timestamp.fromDate(value);
