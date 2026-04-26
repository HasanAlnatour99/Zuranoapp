import '../constants/user_roles.dart';
import '../../l10n/app_localizations.dart';

/// Localized label for salon staff roles shown in UI.
String localizedStaffRole(AppLocalizations l10n, String role) {
  return switch (role) {
    UserRoles.owner => l10n.roleOwner,
    UserRoles.admin => l10n.roleAdmin,
    UserRoles.barber => l10n.roleBarber,
    UserRoles.readonly => 'Read-only',
    UserRoles.customer => l10n.roleCustomer,
    _ => role,
  };
}
