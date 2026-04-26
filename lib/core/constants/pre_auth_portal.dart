/// Values used only for **pre-authentication** routing and onboarding prefs.
/// Not Firestore `users/{uid}.role` values — use [UserRoles] for persisted roles.
abstract final class PreAuthPortal {
  static const staff = 'staff';
}
