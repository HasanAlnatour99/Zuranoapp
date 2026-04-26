import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';

import '../../../core/logging/app_logger.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../../users/data/models/app_user.dart';
import '../data/device_token_model.dart';
import '../data/notification_repository.dart';

const _deviceIdStorageKey = 'notification_installation_device_id';

/// Set to `true` after **Apple Push Notification service (APNs)** is configured
/// (Apple Developer + Firebase) and you are ready to ship push.
///
/// While `false`, the app does not request notification permission, register
/// FCM tokens, or show local notifications for remote messages.
const kFirebasePushMessagingEnabled = false;

/// Foreground display + device registration against Cloud Functions.
class FcmRegistrationService {
  FcmRegistrationService({
    required NotificationRepository notificationRepository,
    required SecureStorageService secureStorageService,
    required AppLogger logger,
    FirebaseMessaging? messaging,
    FlutterLocalNotificationsPlugin? localNotifications,
  }) : _repository = notificationRepository,
       _secureStorageService = secureStorageService,
       _logger = logger,
       _messaging = messaging ?? FirebaseMessaging.instance,
       _local = localNotifications ?? FlutterLocalNotificationsPlugin();

  final NotificationRepository _repository;
  final SecureStorageService _secureStorageService;
  final AppLogger _logger;
  final FirebaseMessaging _messaging;
  final FlutterLocalNotificationsPlugin _local;

  static const _androidChannelId = 'barber_shop_default';
  static const _androidChannelName = 'General';

  Future<void> initializeLocalNotifications() async {
    if (kIsWeb || !kFirebasePushMessagingEnabled) {
      return;
    }
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    await _local.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
    );

    final android = _local
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await android?.createNotificationChannel(
      const AndroidNotificationChannel(
        _androidChannelId,
        _androidChannelName,
        importance: Importance.defaultImportance,
      ),
    );
  }

  Future<void> requestPermissionIfSupported() async {
    if (kIsWeb || !kFirebasePushMessagingEnabled) {
      return;
    }
    await _messaging.requestPermission(alert: true, badge: true, sound: true);
  }

  Future<String> _resolveDeviceId() async {
    var id = await _secureStorageService.read(_deviceIdStorageKey);
    if (id == null || id.isEmpty) {
      id = const Uuid().v4();
      await _secureStorageService.write(_deviceIdStorageKey, id);
    }
    return id;
  }

  Future<void> _awaitApnsTokenOnIos() async {
    if (!Platform.isIOS) {
      return;
    }
    await _messaging.requestPermission(alert: true, badge: true, sound: true);
    const attempts = 40;
    for (var i = 0; i < attempts; i++) {
      final apns = await _messaging.getAPNSToken();
      if (apns != null && apns.isNotEmpty) {
        return;
      }
      await Future<void>.delayed(const Duration(milliseconds: 500));
    }
  }

  Future<void> registerOrRefreshToken({
    required AppUser user,
    required String localeName,
  }) async {
    if (kIsWeb || !kFirebasePushMessagingEnabled) {
      return;
    }
    await _awaitApnsTokenOnIos();
    if (Platform.isIOS) {
      final apns = await _messaging.getAPNSToken();
      if (apns == null || apns.isEmpty) {
        _logger.debug(
          'FCM registration skipped: no APNs token (use a physical device '
          'and configure APNs in Firebase).',
        );
        return;
      }
    }
    final token = await _messaging.getToken();
    if (token == null || token.isEmpty) {
      return;
    }
    await registerWithExplicitToken(
      user: user,
      token: token,
      localeName: localeName,
    );
  }

  Future<void> registerWithExplicitToken({
    required AppUser user,
    required String token,
    required String localeName,
  }) async {
    if (kIsWeb || !kFirebasePushMessagingEnabled || token.isEmpty) {
      return;
    }
    final deviceId = await _resolveDeviceId();
    final info = await PackageInfo.fromPlatform();
    final platform = Platform.isIOS
        ? 'ios'
        : (Platform.isAndroid ? 'android' : 'unknown');
    final tz = DateTime.now().timeZoneName;

    await _repository.registerDeviceToken(
      DeviceRegistrationPayload(
        deviceId: deviceId,
        token: token,
        platform: platform,
        appVersion: info.version,
        locale: localeName,
        timezone: tz,
        pushEnabled: true,
      ),
    );
    _logger.debug('Registered FCM token for current device.');
  }

  Future<void> unregisterCurrentDevice() async {
    if (kIsWeb || !kFirebasePushMessagingEnabled) {
      return;
    }
    final deviceId = await _secureStorageService.read(_deviceIdStorageKey);
    if (deviceId == null || deviceId.isEmpty) {
      return;
    }
    try {
      await _repository.unregisterDeviceToken(deviceId: deviceId);
      _logger.debug('Unregistered FCM token for current device.');
    } catch (_) {
      // Best-effort on sign-out.
    }
  }

  Future<void> showForegroundNotification(RemoteMessage message) async {
    if (kIsWeb || !kFirebasePushMessagingEnabled) {
      return;
    }
    final notification = message.notification;
    final title =
        notification?.title ?? message.data['title']?.toString() ?? '';
    final body = notification?.body ?? message.data['body']?.toString() ?? '';
    if (title.isEmpty && body.isEmpty) {
      return;
    }
    await _local.show(
      message.hashCode,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannelId,
          _androidChannelName,
          importance: Importance.defaultImportance,
          priority: Priority.defaultPriority,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      payload: message.data['route']?.toString(),
    );
  }
}
