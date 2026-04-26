/// Strips decorative characters; keeps digits and leading + for E.164-style storage.
class PhoneNormalizer {
  const PhoneNormalizer._();

  static String normalizeForStorage(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return '';

    final hasPlus = trimmed.startsWith('+');
    final digits = trimmed.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return '';

    return hasPlus ? '+$digits' : digits;
  }

  static int digitCount(String input) {
    return input.replaceAll(RegExp(r'\D'), '').length;
  }
}
