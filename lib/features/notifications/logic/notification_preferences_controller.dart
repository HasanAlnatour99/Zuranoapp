import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/repository_providers.dart';
import '../../../providers/session_provider.dart';
import '../data/user_notification_prefs.dart';

final notificationPreferencesControllerProvider =
    NotifierProvider<NotificationPreferencesController, UserNotificationPrefs>(
      NotificationPreferencesController.new,
    );

class NotificationPreferencesController
    extends Notifier<UserNotificationPrefs> {
  @override
  UserNotificationPrefs build() {
    final user = ref.watch(sessionUserProvider).asData?.value;
    return user?.notificationPrefs ?? UserNotificationPrefs.defaults();
  }

  Future<void> persist(UserNotificationPrefs prefs) async {
    await ref
        .read(notificationRepositoryProvider)
        .updateNotificationPreferences(prefs);
  }
}
