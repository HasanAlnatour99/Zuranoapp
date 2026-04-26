import '../../features/users/data/models/app_user.dart';

enum AppSessionStatus {
  initializing,
  unauthenticated,
  profileIncomplete,
  ownerNeedsSalon,
  ready,
  error,
}

class AppSessionState {
  const AppSessionState({
    required this.status,
    this.user,
    this.error,
    this.firebaseUid,
  });

  final AppSessionStatus status;
  final AppUser? user;
  final Object? error;

  /// Best-effort Firebase Auth uid for this snapshot (routing / diagnostics).
  final String? firebaseUid;

  bool get isResolved => status != AppSessionStatus.initializing;

  /// Maps to “authenticated, no `users/{uid}` yet” (or staff linkage recovery).
  bool get isAuthenticatedNoProfile =>
      status == AppSessionStatus.profileIncomplete;

  /// Maps to “signed in + profile ready for role-based home” (incl. salon step).
  bool get isAuthenticatedReady =>
      status == AppSessionStatus.ready ||
      status == AppSessionStatus.ownerNeedsSalon;
}
