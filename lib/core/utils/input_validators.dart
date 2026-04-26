class InputValidators {
  const InputValidators._();

  static final RegExp _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  /// Locale-agnostic checks (for [isFormValid] / controllers).
  static bool isNonEmptyTrimmed(String value) => value.trim().isNotEmpty;

  static bool isValidEmail(String value) => email(value) == null;

  static bool isValidPassword(String value) => password(value) == null;

  /// Signup / low-friction flows (Firebase allows 6+).
  static bool isValidPasswordMinSix(String value) =>
      passwordMinSix(value) == null;

  static String? passwordMinSix(String value) {
    if (value.isEmpty) {
      return 'Choose a password to protect your account.';
    }
    if (value.trim().length < 6) {
      return 'Use at least 6 characters.';
    }
    return null;
  }

  static bool isValidPhone(String value) => phone(value) == null;

  static final RegExp _staffUsernamePattern = RegExp(r'^[a-z0-9_.]{4,20}$');

  /// Normalized staff username (lowercase a–z, 0–9, underscore, dot; length 4–20).
  static bool isValidStaffUsername(String value) {
    final u = value.trim().toLowerCase();
    return _staffUsernamePattern.hasMatch(u);
  }

  /// Email or staff username for the shared user login screen.
  static bool isValidUserLoginIdentifier(String value) {
    final t = value.trim();
    if (t.isEmpty) {
      return false;
    }
    if (t.contains('@')) {
      return isValidEmail(t);
    }
    return isValidStaffUsername(t);
  }

  static String? email(String value) {
    final trimmedValue = value.trim();
    if (trimmedValue.isEmpty) {
      return 'We need your email so we can sign you in securely.';
    }

    if (!_emailPattern.hasMatch(trimmedValue)) {
      return 'Use a valid email format, like name@salon.com.';
    }

    return null;
  }

  static String? password(String value) {
    if (value.isEmpty) {
      return 'Choose a password to protect your owner account.';
    }

    if (value.trim().length < 8) {
      return 'Use at least 8 characters.';
    }

    return null;
  }

  /// Accepts pasted formats; validates digit count after stripping decoration.
  static String? phone(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      return 'Add a phone number your team and clients can reach.';
    }
    if (digits.length < 8) {
      return 'That number looks too short—include the full local or mobile number.';
    }

    return null;
  }

  static String? requiredField(String value, String label) {
    if (value.trim().isEmpty) {
      return '$label is required.';
    }

    return null;
  }

  static bool passwordsMatch({
    required String password,
    required String confirmValue,
  }) {
    if (confirmValue.isEmpty) {
      return false;
    }
    return password == confirmValue;
  }

  static String? confirmPassword({
    required String password,
    required String confirmPassword,
  }) {
    if (confirmPassword.isEmpty) {
      return 'Re-enter your password so we know it was typed correctly.';
    }

    if (password != confirmPassword) {
      return 'Those passwords do not match. Try again.';
    }

    return null;
  }
}
