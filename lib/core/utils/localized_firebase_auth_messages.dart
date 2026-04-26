import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../l10n/app_localizations.dart';

/// User-facing auth errors for the shared customer + staff login screen.
abstract final class LocalizedFirebaseAuthMessages {
  static String userLoginFailure(
    AppLocalizations l10n,
    Object error, {
    required bool identifierLooksLikePersonalEmail,
    required bool staffCredentialPortal,
  }) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-credential':
        case 'wrong-password':
        case 'user-not-found':
          if (!staffCredentialPortal && identifierLooksLikePersonalEmail) {
            return l10n.authLoginErrorStaffUseUsername;
          }
          return l10n.authLoginErrorIncorrect;
        case 'user-disabled':
          return l10n.authLoginErrorDisabled;
        case 'invalid-email':
          return l10n.authLoginErrorInvalidEmail;
        case 'too-many-requests':
          return l10n.authLoginErrorTooManyRequests;
        case 'network-request-failed':
          return l10n.authLoginErrorNetwork;
        default:
          return l10n.authLoginErrorGeneric;
      }
    }

    if (error is FirebaseFunctionsException) {
      if (error.code == 'not-found') {
        return l10n.authLoginErrorStaffNotFound;
      }
      if (error.code == 'permission-denied') {
        return l10n.authLoginErrorPermission;
      }
      if (error.code == 'unavailable') {
        return l10n.authLoginErrorNetwork;
      }
      return l10n.authLoginErrorGeneric;
    }

    return l10n.authLoginErrorGeneric;
  }
}
