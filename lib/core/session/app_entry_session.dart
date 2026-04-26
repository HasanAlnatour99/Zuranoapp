import '../constants/app_routes.dart';
import '../../features/users/data/models/app_user.dart';

/// Resolved startup / routing state: Firebase Auth + Firestore `users/{uid}`.
///
/// **Flow summary (see [session_provider.dart]):**
/// - **Signed out** — no Firebase user → [AppEntrySessionSignedOut].
/// - **Signed in, no `users/{uid}` yet** — first read may race signup; we watch
///   the doc until it exists (timeout → [AppEntrySessionProfileMissing] /
///   [AppRoutes.accountProfileBootstrap] for true gaps).
/// - **Signed in, customer** — [AppEntrySessionReady] with [UserRoles.customer].
/// - **Signed in, owner without salon** — [AppEntrySessionReady], router sends to
///   [AppRoutes.createSalon].
/// - **Signed in, owner with salon** — [AppEntrySessionReady], owner shell.
/// - **Signed in, admin / barber** — [AppEntrySessionReady] when salonId +
///   employeeId present; else [AppEntrySessionStaffLinkageIncomplete].
/// - **Read errors** (e.g. network, rules) — [AppEntrySessionError].
sealed class AppEntrySession {
  const AppEntrySession();
}

/// Firebase Auth has no user.
final class AppEntrySessionSignedOut extends AppEntrySession {
  const AppEntrySessionSignedOut();
}

/// Auth user exists but `users/{uid}` is absent (or deleted while watching).
final class AppEntrySessionProfileMissing extends AppEntrySession {
  const AppEntrySessionProfileMissing({required this.uid});
  final String uid;
}

/// Failed to load or parse the profile (distinct from “doc missing”).
final class AppEntrySessionError extends AppEntrySession {
  const AppEntrySessionError(this.error, [this.stackTrace]);
  final Object error;
  final StackTrace? stackTrace;
}

/// Profile loaded and passes integrity checks for routing.
final class AppEntrySessionReady extends AppEntrySession {
  const AppEntrySessionReady(this.user);
  final AppUser user;
}

/// Admin / barber doc exists but salon linkage is incomplete — cannot safely
/// enter staff dashboards (controlled recovery only; no salon auto-create).
final class AppEntrySessionStaffLinkageIncomplete extends AppEntrySession {
  const AppEntrySessionStaffLinkageIncomplete(this.user);
  final AppUser user;
}
