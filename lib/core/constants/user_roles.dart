/// Firestore `users/{uid}.role` values.
///
/// **Security rules:** use [allowsMissingSalon] for whether `salonId` may be
/// absent on `users/{uid}`. Use [usesSalonScopedFirestore] for roles that read
/// and write under `salons/{salonId}/...`. Owners may lack `salonId` until
/// salon creation completes; enforce that with app routing, not role alone.
abstract final class UserRoles {
  static const owner = 'owner';
  static const employee = 'employee';

  // Legacy roles kept temporarily for non-user-document compatibility paths.
  static const admin = 'admin';
  static const barber = 'barber';
  static const readonly = 'readonly';
  static const customer = 'customer';

  /// Legacy empty `users/{uid}.role` from older builds; use [needsRoleSelection].
  static const pending = '';

  static bool needsRoleSelection(String role) => role.isEmpty;

  static bool isIdentityRole(String role) => role == owner || role == employee;

  static bool isStaffRole(String role) =>
      role == employee || role == admin || role == barber || role == readonly;

  /// `users/{uid}.salonId` may be null (e.g. customers, or pre-onboarding).
  static bool allowsMissingSalon(String role) =>
      needsRoleSelection(role) || role == owner;

  /// Roles whose data lives primarily under `salons/{salonId}/...`.
  static bool usesSalonScopedFirestore(String role) =>
      role == owner ||
      role == employee ||
      role == admin ||
      role == barber ||
      role == readonly;
}
