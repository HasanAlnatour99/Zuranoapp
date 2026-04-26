import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/session_provider.dart';
import 'app_router.dart';

/// Reloads Firestore-backed entry session and bumps [GoRouter] so [redirect]
/// runs with fresh `users/{uid}` (e.g. after salon creation).
void refreshSessionAndRouter(Ref ref) {
  ref.invalidate(appEntrySessionProvider);
  ref.read(appRouterRefreshProvider).value++;
}

/// Widget-layer auth / profile changes (same effect as [refreshSessionAndRouter]).
void refreshRouterAfterAuthChange(WidgetRef ref) {
  ref.invalidate(appEntrySessionProvider);
  ref.read(appRouterRefreshProvider).value++;
}
