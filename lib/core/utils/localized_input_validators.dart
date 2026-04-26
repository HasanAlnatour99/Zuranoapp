import '../../l10n/app_localizations.dart';
import '../constants/staff_internal_auth_email.dart';

/// Validation messages for display; rules mirror [InputValidators].
class LocalizedInputValidators {
  const LocalizedInputValidators._();

  static final RegExp _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  static String? email(AppLocalizations l10n, String value) {
    final trimmedValue = value.trim();
    if (trimmedValue.isEmpty) {
      return l10n.validationEmailRequired;
    }
    if (!_emailPattern.hasMatch(trimmedValue)) {
      return l10n.validationEmailInvalid;
    }
    return null;
  }

  static String? password(AppLocalizations l10n, String value) {
    if (value.isEmpty) {
      return l10n.validationPasswordRequired;
    }
    if (value.trim().length < 8) {
      return l10n.validationPasswordShort;
    }
    return null;
  }

  /// Email/password signup (Firebase minimum 6 characters).
  static String? passwordSignupMinSix(AppLocalizations l10n, String value) {
    if (value.isEmpty) {
      return l10n.validationPasswordRequired;
    }
    if (value.trim().length < 6) {
      return l10n.validationPasswordMinSixChars;
    }
    return null;
  }

  static String? phone(AppLocalizations l10n, String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      return l10n.validationPhoneRequired;
    }
    if (digits.length < 8) {
      return l10n.validationPhoneShort;
    }
    return null;
  }

  /// When phone is optional: valid if empty, otherwise same rules as [phone].
  static String? phoneOptional(AppLocalizations l10n, String value) {
    if (value.trim().isEmpty) {
      return null;
    }
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 8) {
      return l10n.validationPhoneOptionalInvalid;
    }
    return null;
  }

  static String? requiredField(
    AppLocalizations l10n,
    String value,
    String fieldLabel,
  ) {
    if (value.trim().isEmpty) {
      return l10n.validationFieldRequired(fieldLabel);
    }
    return null;
  }

  static String? confirmPassword(
    AppLocalizations l10n, {
    required String password,
    required String confirmPassword,
  }) {
    if (confirmPassword.isEmpty) {
      return l10n.validationConfirmPasswordEmpty;
    }
    if (password != confirmPassword) {
      return l10n.validationConfirmPasswordMismatch;
    }
    return null;
  }

  static final RegExp _barberPasswordUpper = RegExp(r'[A-Z]');
  static final RegExp _barberPasswordLower = RegExp(r'[a-z]');
  static final RegExp _barberPasswordDigit = RegExp(r'[0-9]');

  static String? addBarberEmail(AppLocalizations l10n, String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return l10n.addBarberValidationEmailRequired;
    }
    if (!_emailPattern.hasMatch(trimmed)) {
      return l10n.addBarberValidationEmailInvalid;
    }
    return null;
  }

  /// Add barber: real mailbox for Firebase Auth (not internal staff domain).
  static String? addBarberStaffAuthEmail(AppLocalizations l10n, String value) {
    final formatErr = addBarberEmail(l10n, value);
    if (formatErr != null) {
      return formatErr;
    }
    final lower = value.trim().toLowerCase();
    if (StaffInternalAuthEmail.isInternalMailbox(lower)) {
      return l10n.addBarberValidationEmailInternalNotAllowed;
    }
    return null;
  }

  /// Shared “User” login: valid email, or valid staff username (no @).
  static String? userLoginIdentifier(AppLocalizations l10n, String value) {
    final t = value.trim();
    if (t.isEmpty) {
      return l10n.validationUserLoginIdentifierRequired;
    }
    if (t.contains('@')) {
      return email(l10n, t);
    }
    return staffUsername(l10n, t);
  }

  /// Add barber / staff username rules (must match Cloud Function).
  static String? staffUsername(AppLocalizations l10n, String value) {
    final u = value.trim().toLowerCase();
    if (u.isEmpty) {
      return l10n.validationStaffUsernameRequired;
    }
    if (!RegExp(r'^[a-z0-9_.]{4,20}$').hasMatch(u)) {
      return l10n.validationStaffUsernameInvalid;
    }
    return null;
  }

  /// Minimum 8 characters, at least one upper, one lower, one digit.
  static bool addBarberPasswordRuleMinLengthMet(String value) =>
      value.length >= 8;

  static bool addBarberPasswordRuleUpperMet(String value) =>
      _barberPasswordUpper.hasMatch(value);

  static bool addBarberPasswordRuleLowerMet(String value) =>
      _barberPasswordLower.hasMatch(value);

  static bool addBarberPasswordRuleDigitMet(String value) =>
      _barberPasswordDigit.hasMatch(value);

  static bool addBarberPasswordsMatchMet(String password, String confirm) =>
      confirm.isNotEmpty && password == confirm;

  static String? addBarberPasswordPolicy(AppLocalizations l10n, String value) {
    if (value.isEmpty) {
      return l10n.addBarberValidationPasswordRequired;
    }
    if (!addBarberPasswordRuleMinLengthMet(value)) {
      return l10n.addBarberValidationPasswordMinLength;
    }
    if (!addBarberPasswordRuleUpperMet(value) ||
        !addBarberPasswordRuleLowerMet(value) ||
        !addBarberPasswordRuleDigitMet(value)) {
      return l10n.addBarberValidationPasswordComplexity;
    }
    return null;
  }

  static String? addBarberConfirmPassword(
    AppLocalizations l10n, {
    required String password,
    required String confirm,
  }) {
    if (confirm.isEmpty) {
      return l10n.addBarberValidationConfirmPasswordRequired;
    }
    if (password != confirm) {
      return l10n.addBarberValidationPasswordsMismatch;
    }
    return null;
  }
}
