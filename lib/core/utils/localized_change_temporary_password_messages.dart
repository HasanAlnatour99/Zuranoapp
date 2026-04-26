import 'package:firebase_auth/firebase_auth.dart';

import '../../l10n/app_localizations.dart';

/// User-facing errors for [ChangeTemporaryPasswordScreen] (no raw Firebase text).
abstract final class LocalizedChangeTemporaryPasswordMessages {
  static String fromFirebaseAuthException(
    AppLocalizations l10n,
    FirebaseAuthException e,
  ) {
    switch (e.code) {
      case 'wrong-password':
      case 'invalid-credential':
        return l10n.changeTemporaryPasswordErrorWrongPassword;
      case 'weak-password':
        return l10n.changeTemporaryPasswordErrorWeakPassword;
      case 'requires-recent-login':
        return l10n.changeTemporaryPasswordErrorRequiresRecentLogin;
      case 'network-request-failed':
        return l10n.changeTemporaryPasswordErrorNetwork;
      default:
        return l10n.changeTemporaryPasswordErrorGeneric;
    }
  }
}
