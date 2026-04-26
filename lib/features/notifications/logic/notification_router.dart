import 'package:go_router/go_router.dart';

import '../../../core/constants/app_routes.dart';
import '../../users/data/models/app_user.dart';

Map<String, dynamic> stringifyDataMap(Map<String, dynamic> raw) {
  return raw.map((k, v) => MapEntry(k, v?.toString() ?? ''));
}

/// Maps FCM / in-app [data] payloads to app navigation (go_router).
///
/// MVP: all signed-in users are routed as salon owners (see [app_router.dart]).
void navigateForNotificationPayload({
  required GoRouter router,
  required Map<String, dynamic> data,
  required AppUser? session,
}) {
  final route = data['route']?.toString() ?? '';
  final salonId = data['salonId']?.toString() ?? '';
  final bookingId = data['bookingId']?.toString() ?? '';

  switch (route) {
    case 'booking':
      if (session == null) {
        return;
      }
      if (salonId.isNotEmpty && bookingId.isNotEmpty) {
        router.go(AppRoutes.ownerDashboard);
      }
      return;
    case 'payroll':
      if (session == null) {
        return;
      }
      router.go(AppRoutes.ownerPayroll);
      return;
    case 'violation':
      if (session == null) {
        return;
      }
      router.go(AppRoutes.ownerDashboard);
      return;
    default:
      return;
  }
}
