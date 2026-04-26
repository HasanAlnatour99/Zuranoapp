import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_routes.dart';
import '../core/debug/agent_session_log.dart';
import '../features/owner/logic/owner_overview_controller.dart';
import '../router/app_router.dart';
import 'firebase_providers.dart';
import 'notification_providers.dart';
import 'onboarding_providers.dart';
import 'repository_providers.dart';
import 'salon_streams_provider.dart';
import 'session_provider.dart';

/// Signs out via Firebase and nudges [GoRouter] to re-run redirects.
///
/// Uses [ProviderScope.containerOf] so post-await work does not touch [WidgetRef]
/// after the calling widget unmounts (e.g. router replaced the route mid-sign-out).
Future<void> performAppSignOut(BuildContext context) async {
  if (!context.mounted) {
    return;
  }
  final container = ProviderScope.containerOf(context, listen: false);

  agentSessionLog(
    hypothesisId: 'H1',
    location: 'auth_session_actions.dart:performAppSignOut',
    message: 'sign_out_invoked',
    runId: 'logout-debug',
    data: <String, Object?>{
      'firebaseUidBefore':
          container.read(firebaseAuthProvider).currentUser?.uid ?? '(none)',
      'sessionStatusBefore': container
          .read(appSessionBootstrapProvider)
          .status
          .name,
    },
  );

  try {
    await container
        .read(fcmRegistrationServiceProvider)
        .unregisterCurrentDevice();
  } catch (error) {
    agentSessionLog(
      hypothesisId: 'H2',
      location: 'auth_session_actions.dart:performAppSignOut',
      message: 'fcm_unregister_failed_non_blocking',
      runId: 'logout-debug',
      data: <String, Object?>{'error': error.toString()},
    );
  }

  await container.read(authRepositoryProvider).logout();
  await container
      .read(onboardingPrefsProvider.notifier)
      .clearSessionBootstrapFlags();

  agentSessionLog(
    hypothesisId: 'H2',
    location: 'auth_session_actions.dart:performAppSignOut',
    message: 'after_auth_repository_logout',
    runId: 'logout-debug',
    data: <String, Object?>{
      'firebaseUidAfter':
          container.read(firebaseAuthProvider).currentUser?.uid ?? '(none)',
    },
  );

  container.invalidate(appEntrySessionProvider);
  container.invalidate(appSessionBootstrapProvider);
  container.invalidate(ownerOverviewControllerProvider);
  container.invalidate(sessionSalonStreamProvider);
  container.invalidate(firebaseAuthUidProvider);
  container.invalidate(onboardingPrefsProvider);

  final routerRefresh = container.read(appRouterRefreshProvider);
  routerRefresh.value++;

  agentSessionLog(
    hypothesisId: 'H1',
    location: 'auth_session_actions.dart:performAppSignOut',
    message: 'router_refresh_bumped',
    runId: 'logout-debug',
    data: const <String, Object?>{},
  );

  await Future<void>.microtask(() {});
  if (context.mounted) {
    context.go(AppRoutes.roleSelection);
  }
}
