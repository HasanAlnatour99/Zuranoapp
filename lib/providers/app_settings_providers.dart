import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/owner/logic/owner_money_recognition.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in main()',
  );
});

class AppLocalePreference extends Notifier<Locale> {
  static const _prefsKey = 'locale_code';

  @override
  Locale build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final raw = prefs.getString(_prefsKey);
    if (raw == 'ar') return const Locale('ar');
    if (raw == 'en') return const Locale('en');
    return const Locale('en');
  }

  Future<void> setLocale(Locale locale) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_prefsKey, locale.languageCode);
    state = locale;
  }
}

final appLocalePreferenceProvider =
    NotifierProvider<AppLocalePreference, Locale>(AppLocalePreference.new);

class OwnerMoneyRecognitionPreference
    extends Notifier<OwnerMoneyRecognitionMode> {
  static const _prefsKey = 'owner_money_recognition_mode';

  @override
  OwnerMoneyRecognitionMode build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final raw = prefs.getString(_prefsKey);
    if (raw == OwnerMoneyRecognitionMode.cash.name) {
      return OwnerMoneyRecognitionMode.cash;
    }
    return OwnerMoneyRecognitionMode.operational;
  }

  Future<void> setMode(OwnerMoneyRecognitionMode mode) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_prefsKey, mode.name);
    state = mode;
  }
}

final ownerMoneyRecognitionModeProvider =
    NotifierProvider<
      OwnerMoneyRecognitionPreference,
      OwnerMoneyRecognitionMode
    >(OwnerMoneyRecognitionPreference.new);
