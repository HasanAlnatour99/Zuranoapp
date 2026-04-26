class CustomerPhoneNormalizer {
  const CustomerPhoneNormalizer._();

  static String normalizePhone(String input) {
    var value = input.trim().replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (value.startsWith('00')) {
      value = '+${value.substring(2)}';
    }
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    if (isValidQatarLocalMobile(digitsOnly)) {
      return '+974$digitsOnly';
    }
    if (value.startsWith('+')) {
      return '+${digitsOnly.replaceFirst(RegExp(r'^0+'), '')}';
    }
    return digitsOnly.isEmpty ? '' : '+$digitsOnly';
  }

  static bool isValidPhone(String normalizedPhone) {
    final value = normalizedPhone.trim();
    if (!value.startsWith('+')) {
      return false;
    }
    final digits = value.substring(1);
    return RegExp(r'^\d{8,15}$').hasMatch(digits);
  }

  static bool isValidQatarLocalMobile(String input) {
    final digits = input.trim().replaceAll(RegExp(r'\D'), '');
    return RegExp(r'^[3567]\d{7}$').hasMatch(digits);
  }

  static String displayPhone(String normalizedPhone) {
    final value = normalizedPhone.trim();
    if (value.startsWith('+974') && value.length == 12) {
      final local = value.substring(4);
      return '+974 ${local.substring(0, 4)} ${local.substring(4)}';
    }
    return value;
  }
}
