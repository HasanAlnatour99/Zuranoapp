/// Recognizes legacy internal Auth mailboxes (`@staff.zurano.app`) for staff
/// who still sign in with username → resolved email (must match Cloud Functions
/// `staffProvisioningShared.ts`). New barbers use their real email in Auth.
abstract final class StaffInternalAuthEmail {
  static const domain = 'staff.zurano.app';

  /// `{employeeId}__{salonId}@staff.zurano.app`
  static bool isInternalMailbox(String value) {
    final e = value.trim().toLowerCase();
    if (!e.contains('@')) {
      return false;
    }
    return e.endsWith('@$domain');
  }
}
