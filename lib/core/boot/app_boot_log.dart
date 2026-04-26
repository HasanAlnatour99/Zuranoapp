import 'package:flutter/foundation.dart';

/// Debug-only structured logs for startup, session, and routing.
abstract final class AppBootLog {
  static void app(String message, [Map<String, Object?>? data]) {
    if (!kDebugMode) {
      return;
    }
    final suffix = data == null || data.isEmpty ? '' : ' ${data.toString()}';
    debugPrint('[APP_BOOT] $message$suffix');
  }

  static void session(String message, [Map<String, Object?>? data]) {
    if (!kDebugMode) {
      return;
    }
    final suffix = data == null || data.isEmpty ? '' : ' ${data.toString()}';
    debugPrint('[SESSION] $message$suffix');
  }

  static void router(String message, [Map<String, Object?>? data]) {
    if (!kDebugMode) {
      return;
    }
    final suffix = data == null || data.isEmpty ? '' : ' ${data.toString()}';
    debugPrint('[ROUTER] $message$suffix');
  }
}
