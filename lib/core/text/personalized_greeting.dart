import '../../l10n/app_localizations.dart';

/// Time-of-day greeting using existing localized strings (EN / AR).
String getGreeting(AppLocalizations l10n) {
  final hour = DateTime.now().toLocal().hour;
  if (hour < 12) {
    return l10n.ownerOverviewGreetingMorning;
  }
  if (hour < 17) {
    return l10n.ownerOverviewGreetingAfternoon;
  }
  return l10n.ownerOverviewGreetingEvening;
}

extension StringDisplayNameCapitalization on String {
  /// Title-cases each whitespace-separated segment, e.g. `"alice alnatour"` → `"Alice Alnatour"`.
  String toUpperCaseFirst() {
    final source = trim();
    if (source.isEmpty) return this;
    return source.split(RegExp(r'\s+')).map(_titleCaseWord).join(' ');
  }
}

String _titleCaseWord(String word) {
  if (word.isEmpty) return word;
  if (word.length == 1) return word.toUpperCase();
  return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
}
