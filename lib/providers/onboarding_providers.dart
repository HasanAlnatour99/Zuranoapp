import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/pre_auth_portal.dart';
import '../core/constants/user_roles.dart';
import '../features/onboarding/domain/value_objects/country_option.dart';
import 'app_settings_providers.dart';

/// Persists onboarding progress, region, and intended auth role.
@immutable
class OnboardingPrefsState {
  const OnboardingPrefsState({
    required this.languageCompleted,
    required this.selectedLanguageCode,
    required this.countryCompleted,
    required this.countryCode,
    required this.countryName,
    required this.countryDialCode,
    required this.selectedAuthRole,
    required this.customerOnboardingCompleted,
    required this.preAuthSetupCompleted,
    required this.customerPreauthDisplayName,
    required this.customerPreauthPhone,
  });

  /// Legacy: language picked (kept for migration / settings).
  final bool languageCompleted;
  final String? selectedLanguageCode;

  /// Legacy: country picked.
  final bool countryCompleted;

  /// ISO 3166-1 alpha-2 (e.g. QA).
  final String? countryCode;

  /// English name for `users/{uid}.countryName` and UI fallbacks.
  final String? countryName;

  /// E.164-style dial prefix, e.g. +974, for `users/{uid}.countryDialCode`.
  final String? countryDialCode;

  /// [UserRoles.owner] or [UserRoles.customer]; set before login/signup.
  final String? selectedAuthRole;
  final bool customerOnboardingCompleted;
  final bool preAuthSetupCompleted;

  /// Optional display name collected before customer signup.
  final String? customerPreauthDisplayName;

  /// Optional phone collected before customer signup.
  final String? customerPreauthPhone;

  bool get hasRegion => (countryCode != null && countryCode!.isNotEmpty);

  bool get hasAuthIntent {
    final r = selectedAuthRole?.trim();
    return r == UserRoles.owner ||
        r == UserRoles.customer ||
        r == PreAuthPortal.staff;
  }

  bool get isCustomerFlow => selectedAuthRole?.trim() == UserRoles.customer;

  bool get isStaffLoginFlow => selectedAuthRole?.trim() == PreAuthPortal.staff;

  /// Language + country + role are complete.
  bool get isPreAuthReady =>
      languageCompleted && countryCompleted && hasAuthIntent;

  bool get isOnboardingFlowComplete => isPreAuthReady;
}

class OnboardingPrefs extends Notifier<OnboardingPrefsState> {
  static const _languageKey = 'onboarding_language_completed';
  static const _selectedLanguageCodeKey = 'selected_language_code';
  static const _countryKey = 'onboarding_country_completed';
  static const _countryCodeKey = 'selected_country_code';
  static const _countryNameKey = 'selected_country_name';
  static const _countryDialKey = 'selected_country_dial_code';
  static const _authRoleKey = 'auth_selected_role';
  static const _customerOnboardingCompletedKey =
      'onboarding_completed_customer';
  static const _preAuthSetupCompletedKey = 'preauth_setup_completed';
  static const _legacyWelcomeCompletedKey = 'onboarding_welcome_completed';
  static const _customerPreauthNameKey = 'customer_preauth_display_name';
  static const _customerPreauthPhoneKey = 'customer_preauth_phone';

  @override
  OnboardingPrefsState build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return _read(prefs);
  }

  OnboardingPrefsState _read(SharedPreferences prefs) {
    final languageCompleted = prefs.getBool(_languageKey) ?? false;
    final countryCompleted = prefs.getBool(_countryKey) ?? false;
    final rawSelectedRole = prefs.getString(_authRoleKey);
    final selectedRole = switch (rawSelectedRole) {
      PreAuthPortal.staff => PreAuthPortal.staff,
      UserRoles.employee => UserRoles.customer,
      _ => rawSelectedRole,
    };
    final hasIntent =
        selectedRole == UserRoles.owner ||
        selectedRole == UserRoles.customer ||
        selectedRole == PreAuthPortal.staff;
    final preAuthReady = languageCompleted && countryCompleted && hasIntent;
    final persistedPreAuthDone =
        prefs.getBool(_preAuthSetupCompletedKey) ?? false;
    final preAuthSetupCompleted = preAuthReady || persistedPreAuthDone;
    final customerDone =
        prefs.getBool(_customerOnboardingCompletedKey) ?? false;

    final rawCode = prefs.getString(_countryCodeKey);
    String? name = prefs.getString(_countryNameKey);
    String? dial = prefs.getString(_countryDialKey);
    if (rawCode != null &&
        rawCode.isNotEmpty &&
        (name == null || name.isEmpty || dial == null || dial.isEmpty)) {
      final c = CountryOption.tryFindByIso(rawCode);
      if (c != null) {
        name ??= c.nameEn;
        dial ??= c.dialCode;
      }
    }
    return OnboardingPrefsState(
      languageCompleted: languageCompleted,
      selectedLanguageCode: prefs.getString(_selectedLanguageCodeKey),
      countryCompleted: countryCompleted,
      countryCode: rawCode,
      countryName: name,
      countryDialCode: dial,
      selectedAuthRole: selectedRole,
      customerOnboardingCompleted: customerDone,
      preAuthSetupCompleted: preAuthSetupCompleted,
      customerPreauthDisplayName: prefs.getString(_customerPreauthNameKey),
      customerPreauthPhone: prefs.getString(_customerPreauthPhoneKey),
    );
  }

  Future<void> _syncPreAuthCompletion(SharedPreferences prefs) async {
    final state = _read(prefs);
    await prefs.setBool(_preAuthSetupCompletedKey, state.isPreAuthReady);
  }

  Future<void> completeLanguageSelection(Locale locale) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await ref.read(appLocalePreferenceProvider.notifier).setLocale(locale);
    await prefs.setBool(_languageKey, true);
    await prefs.setString(_selectedLanguageCodeKey, locale.languageCode);
    await _syncPreAuthCompletion(prefs);
    state = _read(prefs);
  }

  Future<void> completeCountrySelection(
    String isoCode, {
    String? countryName,
    String? countryDialCode,
  }) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final code = isoCode.trim().toUpperCase();
    final meta = _resolveCountryMeta(
      code,
      name: countryName,
      dial: countryDialCode,
    );
    await prefs.setString(_countryCodeKey, code);
    await prefs.setString(_countryNameKey, meta.$1);
    await prefs.setString(_countryDialKey, meta.$2);
    await prefs.setBool(_countryKey, true);
    await _syncPreAuthCompletion(prefs);
    state = _read(prefs);
  }

  (String, String) _resolveCountryMeta(
    String iso, {
    String? name,
    String? dial,
  }) {
    final opt = CountryOption.tryFindByIso(iso);
    final n = (name != null && name.trim().isNotEmpty)
        ? name.trim()
        : (opt?.nameEn ?? iso);
    final d = (dial != null && dial.trim().isNotEmpty)
        ? dial.trim()
        : (opt?.dialCode ?? '');
    return (n, d);
  }

  /// Backward-compatible legacy helper (single-page onboarding).
  Future<void> completeWelcomeOnboarding({
    required Locale locale,
    required String countryIso,
  }) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await ref.read(appLocalePreferenceProvider.notifier).setLocale(locale);
    final code = countryIso.trim().toUpperCase();
    final meta = _resolveCountryMeta(code);
    await prefs.setString(_countryCodeKey, code);
    await prefs.setString(_countryNameKey, meta.$1);
    await prefs.setString(_countryDialKey, meta.$2);
    await prefs.setBool(_languageKey, true);
    await prefs.setBool(_countryKey, true);
    await prefs.setString(_selectedLanguageCodeKey, locale.languageCode);
    await _syncPreAuthCompletion(prefs);
    state = _read(prefs);
  }

  Future<void> setSelectedAuthRole(String role) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final rawRole = role.trim();
    final r = rawRole == UserRoles.employee ? UserRoles.customer : rawRole;
    if (r != UserRoles.owner &&
        r != UserRoles.customer &&
        r != PreAuthPortal.staff) {
      return;
    }
    await prefs.setString(_authRoleKey, r);
    await _syncPreAuthCompletion(prefs);
    state = _read(prefs);
  }

  /// Pre-auth only: routes to [AppRoutes.staffLogin]. Does not set Firestore role.
  Future<void> setPreAuthStaffLogin() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_authRoleKey, PreAuthPortal.staff);
    await _syncPreAuthCompletion(prefs);
    state = _read(prefs);
  }

  Future<void> setCustomerPreauthDraft({
    required String name,
    required String phone,
  }) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final n = name.trim();
    final p = phone.trim();
    if (n.isEmpty) {
      await prefs.remove(_customerPreauthNameKey);
    } else {
      await prefs.setString(_customerPreauthNameKey, n);
    }
    if (p.isEmpty) {
      await prefs.remove(_customerPreauthPhoneKey);
    } else {
      await prefs.setString(_customerPreauthPhoneKey, p);
    }
    state = _read(prefs);
  }

  Future<void> completeCustomerOnboarding() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_customerOnboardingCompletedKey, true);
    state = _read(prefs);
  }

  /// Update country from Settings (does not reset onboarding flags).
  Future<void> updateCountryCode(String isoCode) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final code = isoCode.trim().toUpperCase();
    final meta = _resolveCountryMeta(code);
    await prefs.setString(_countryCodeKey, code);
    await prefs.setString(_countryNameKey, meta.$1);
    await prefs.setString(_countryDialKey, meta.$2);
    state = _read(prefs);
  }

  /// Clears persisted pre-login portal ([PreAuthPortal.staff] / role intent).
  Future<void> clearPreAuthPortal() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.remove(_authRoleKey);
    await _syncPreAuthCompletion(prefs);
    state = _read(prefs);
  }

  /// Clears draft customer pre-auth fields (not language/country).
  Future<void> clearOnboardingTempData() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.remove(_customerPreauthNameKey);
    await prefs.remove(_customerPreauthPhoneKey);
    await prefs.remove(_customerOnboardingCompletedKey);
    state = _read(prefs);
  }

  /// Full sign-out cleanup: portal, temp drafts, and bootstrap completion flags.
  Future<void> clearSessionBootstrapFlags() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.remove(_authRoleKey);
    await prefs.remove(_customerOnboardingCompletedKey);
    await prefs.remove(_preAuthSetupCompletedKey);
    await prefs.remove(_legacyWelcomeCompletedKey);
    await prefs.remove(_customerPreauthNameKey);
    await prefs.remove(_customerPreauthPhoneKey);
    await _syncPreAuthCompletion(prefs);
    state = _read(prefs);
  }
}

final onboardingPrefsProvider =
    NotifierProvider<OnboardingPrefs, OnboardingPrefsState>(
      OnboardingPrefs.new,
    );

/// Resolved role for signup / OAuth profile creation (prefers persisted value).
/// Owner/customer only — `null` for staff pre-auth portal (no customer signup role).
final authIntentRoleProvider = Provider<String?>((ref) {
  final s = ref.watch(onboardingPrefsProvider);
  if (s.isStaffLoginFlow) {
    return null;
  }
  return s.selectedAuthRole;
});
