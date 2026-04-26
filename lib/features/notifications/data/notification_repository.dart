import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

import '../../../core/firebase/cloud_functions_region.dart';
import '../../../core/firestore/firestore_paths.dart';
import '../../../core/firestore/firestore_write_payload.dart';
import 'device_token_model.dart';
import 'notification_model.dart';
import 'user_notification_prefs.dart';

class NotificationRepository {
  NotificationRepository({
    required FirebaseFirestore firestore,
    FirebaseFunctions? functions,
  }) : _firestore = firestore,
       _functions = functions ?? appCloudFunctions();

  final FirebaseFirestore _firestore;
  final FirebaseFunctions _functions;

  CollectionReference<Map<String, dynamic>> _notifications(String uid) {
    return _firestore.collection(FirestorePaths.userNotificationsPath(uid));
  }

  Stream<List<AppNotificationItem>> watchNotifications(
    String uid, {
    int limit = 100,
  }) {
    return _notifications(uid)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => AppNotificationItem.fromDoc(d.id, d.data()))
              .toList(),
        );
  }

  Future<void> markNotificationRead({
    required String uid,
    required String notificationId,
  }) {
    return _notifications(uid)
        .doc(notificationId)
        .set(
          FirestoreWritePayload.withServerTimestampForUpdate({
            'status': 'read',
            'readAt': FieldValue.serverTimestamp(),
          }),
          SetOptions(merge: true),
        );
  }

  Future<void> registerDeviceToken(DeviceRegistrationPayload payload) async {
    final callable = _functions.httpsCallable('registerDeviceToken');
    await callable.call(payload.toCallableMap());
  }

  Future<void> unregisterDeviceToken({required String deviceId}) async {
    final callable = _functions.httpsCallable('unregisterDeviceToken');
    await callable.call({'deviceId': deviceId});
  }

  Future<void> updateNotificationPreferences(
    UserNotificationPrefs prefs,
  ) async {
    final callable = _functions.httpsCallable('updateNotificationPreferences');
    await callable.call({'notificationPrefs': prefs.toCallableUpdatePayload()});
  }
}
