import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_countries.dart';
import '../domain/models/country.dart';
import '../../../providers/onboarding_providers.dart';
import 'device_country_iso.dart';

@immutable
class SelectCountryState {
  const SelectCountryState({
    required this.searchQuery,
    required this.selectedIsoCode,
    required this.allCountries,
  });

  final String searchQuery;

  /// ISO-3166 alpha-2, set from prefs / device locale / QA on first [SelectCountryController.build].
  final String selectedIsoCode;
  final List<Country> allCountries;

  bool get hasSelection => selectedIsoCode.isNotEmpty;

  static List<Country> _buildAll() =>
      AppCountries.choices.map(Country.fromChoice).toList(growable: false);

  static bool _matches(Country c, String rawQuery) {
    final t = rawQuery.trim();
    if (t.isEmpty) return true;
    final lower = t.toLowerCase();
    if (c.nameEn.toLowerCase().contains(lower)) return true;
    if (c.nameAr.contains(t)) return true;
    if (c.isoCode.toLowerCase().contains(lower)) return true;
    final qDigits = t.replaceAll(RegExp(r'\D'), '');
    if (qDigits.isNotEmpty) {
      final dialDigits = c.dialCode.replaceAll(RegExp(r'\D'), '');
      if (dialDigits.contains(qDigits)) return true;
    }
    return c.dialCode.contains(t) || c.dialCode.contains(lower);
  }

  /// When searching, one flat list (name, ISO, dial).
  List<Country> get filtered {
    return allCountries.where((c) => _matches(c, searchQuery)).toList();
  }

  Country? get selectedCountry {
    for (final c in allCountries) {
      if (c.isoCode == selectedIsoCode) return c;
    }
    return null;
  }

  SelectCountryState copyWith({String? searchQuery, String? selectedIsoCode}) {
    return SelectCountryState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedIsoCode: selectedIsoCode ?? this.selectedIsoCode,
      allCountries: allCountries,
    );
  }
}

class SelectCountryController extends Notifier<SelectCountryState> {
  @override
  SelectCountryState build() {
    final all = SelectCountryState._buildAll();
    final prefs = ref.read(onboardingPrefsProvider);
    final existing = prefs.countryCode;
    final fromPrefs = existing != null && existing.trim().isNotEmpty
        ? existing.toUpperCase()
        : null;
    final fromDevice = tryDeviceLocaleCountryIso();
    final fallbackIso = all.any((c) => c.isoCode == 'QA')
        ? 'QA'
        : (all.isNotEmpty ? all.first.isoCode : '');
    var initial = fallbackIso;
    if (fromPrefs != null && all.any((c) => c.isoCode == fromPrefs)) {
      initial = fromPrefs;
    } else if (fromDevice != null && all.any((c) => c.isoCode == fromDevice)) {
      initial = fromDevice;
    }
    return SelectCountryState(
      searchQuery: '',
      selectedIsoCode: initial,
      allCountries: all,
    );
  }

  void setSearchQuery(String q) {
    if (q == state.searchQuery) return;
    state = state.copyWith(searchQuery: q);
  }

  void selectCountry(String isoCode) {
    state = state.copyWith(selectedIsoCode: isoCode.toUpperCase());
  }

  /// Persists the current selection (same as tapping Continue on the screen).
  Future<void> confirmSelectedCountry() async {
    final c = state.selectedCountry;
    if (c == null) return;
    await ref
        .read(onboardingPrefsProvider.notifier)
        .completeCountrySelection(
          c.isoCode,
          countryName: c.nameForFirestore,
          countryDialCode: c.dialCode,
        );
  }
}

final selectCountryControllerProvider =
    NotifierProvider.autoDispose<SelectCountryController, SelectCountryState>(
      SelectCountryController.new,
    );
