import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/notifications/data/notification_model.dart';
import '../features/notifications/logic/fcm_registration_service.dart';
import '../core/session/app_session_status.dart';
import 'firebase_providers.dart';
import 'repository_providers.dart';
import 'session_provider.dart';

final fcmRegistrationServiceProvider = Provider<FcmRegistrationService>((ref) {
  return FcmRegistrationService(
    notificationRepository: ref.read(notificationRepositoryProvider),
    secureStorageService: ref.read(secureStorageServiceProvider),
    logger: ref.read(appLoggerProvider),
  );
});

/// Inbox path is `users/{uid}/notifications` where [uid] must equal
/// `request.auth.uid` in Firestore rules. Use Auth UID, not [AppUser.uid]
/// from the user document (that field can be missing or stale).
final userNotificationsStreamProvider =
    StreamProvider.autoDispose<List<AppNotificationItem>>((ref) {
      ref.watch(sessionUserProvider);
      final authUid = ref.watch(firebaseAuthProvider).currentUser?.uid;
      final status = ref.watch(appSessionBootstrapProvider).status;
      if (authUid == null ||
          authUid.isEmpty ||
          status == AppSessionStatus.unauthenticated) {
        return Stream.value(const <AppNotificationItem>[]);
      }
      return ref
          .read(notificationRepositoryProvider)
          .watchNotifications(authUid);
    });

final unreadNotificationCountProvider = Provider.autoDispose<int>((ref) {
  final async = ref.watch(userNotificationsStreamProvider);
  return async.maybeWhen(
    data: (list) => list.where((e) => e.isUnread).length,
    orElse: () => 0,
  );
});
