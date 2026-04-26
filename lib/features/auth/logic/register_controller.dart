import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_countries.dart';
import '../../../core/constants/user_roles.dart';
import '../../../core/debug/agent_session_log.dart';
import '../../../core/utils/firebase_error_message.dart';
import '../../../core/utils/input_validators.dart';
import '../../../core/utils/localized_input_validators.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/app_settings_providers.dart';
import '../../../providers/onboarding_providers.dart';
import '../../../providers/repository_providers.dart';
import '../../onboarding/domain/value_objects/user_address.dart';
import '../../onboarding/domain/value_objects/user_phone.dart';

final registerControllerProvider =
    NotifierProvider.autoDispose<RegisterController, RegisterFormState>(
      RegisterController.new,
    );

class RegisterController extends Notifier<RegisterFormState> {
  bool _updateStateIfMounted(
    RegisterFormState Function(RegisterFormState current) update,
  ) {
    if (!ref.mounted) return false;
    state = update(state);
    return true;
  }

  @override
  RegisterFormState build() {
    final onboarding = ref.read(onboardingPrefsProvider);
    final initialRole = onboarding.isStaffLoginFlow
        ? null
        : onboarding.selectedAuthRole;
    return RegisterFormState(intendedRole: initialRole);
  }

  void setIntendedRole(String role) {
    state = state.copyWith(intendedRole: role);
  }

  String? _resolvedAuthRole() {
    final r =
        state.intendedRole?.trim() ??
        ref.read(onboardingPrefsProvider).selectedAuthRole?.trim();
    if (r == UserRoles.owner || r == UserRoles.customer) {
      return r;
    }
    return null;
  }

  void updateName(String value) {
    state = state.copyWith(
      fullName: value,
      nameTouched: true,
      submissionError: null,
    );
  }

  void updateEmail(String value) {
    state = state.copyWith(
      email: value,
      emailTouched: true,
      submissionError: null,
    );
  }

  void updatePassword(String value) {
    state = state.copyWith(
      password: value,
      passwordTouched: true,
      submissionError: null,
    );
  }

  void updatePhone(String value) {
    state = state.copyWith(
      phone: value,
      phoneTouched: true,
      submissionError: null,
    );
  }

  void updateCity(String value) {
    state = state.copyWith(
      city: value,
      cityTouched: true,
      submissionError: null,
    );
  }

  void updateConfirmPassword(String value) {
    state = state.copyWith(
      confirmPassword: value,
      confirmPasswordTouched: true,
      submissionError: null,
    );
  }

  UserPhone? _structuredPhoneFromForm() {
    final raw = state.phone.trim();
    if (raw.isEmpty || !InputValidators.isValidPhone(raw)) {
      return null;
    }
    final nationalDigits = raw.replaceAll(RegExp(r'\D'), '');
    final iso =
        ref.read(onboardingPrefsProvider).countryCode?.toUpperCase() ?? 'SA';
    CountryChoice country = AppCountries.choices.first;
    for (final c in AppCountries.choices) {
      if (c.code == iso) {
        country = c;
        break;
      }
    }
    return UserPhone.fromDialAndNational(
      countryIsoCode: country.code,
      dialCode: country.dialCode,
      nationalDigits: nationalDigits,
    );
  }

  UserAddress _customerCityAddress() {
    final iso =
        ref.read(onboardingPrefsProvider).countryCode?.toUpperCase() ?? 'SA';
    final locale = ref.read(appLocalePreferenceProvider);
    final countryName = AppCountries.nameForCode(iso, locale) ?? iso;
    return UserAddress.customerProfile(
      countryCode: iso,
      countryName: countryName,
      city: state.city.trim(),
      street: '-',
      building: null,
      postalCode: null,
    );
  }

  Future<bool> submit() async {
    if (!_updateStateIfMounted(
      (current) => current.copyWith(hasSubmitted: true, submissionError: null),
    )) {
      return false;
    }

    if (!state.isFormValid) {
      return false;
    }

    if (!_updateStateIfMounted(
      (current) => current.copyWith(isSubmitting: true),
    )) {
      return false;
    }

    try {
      final role = _resolvedAuthRole();

      agentSessionLog(
        hypothesisId: 'H2',
        location: 'register_controller.dart:submit',
        message: 'attempting_registration',
        data: <String, Object?>{
          'resolvedRole': role ?? 'null',
          'intendedRoleInState': state.intendedRole ?? 'null',
        },
      );

      if (role == null) {
        _updateStateIfMounted(
          (current) => current.copyWith(
            isSubmitting: false,
            submissionError:
                'Choose Customer or Salon owner before signing up.',
          ),
        );
        return false;
      }

      final auth = ref.read(authRepositoryProvider);
      late final String authUid;
      if (role == UserRoles.customer) {
        final phone = _structuredPhoneFromForm();
        if (phone == null) {
          _updateStateIfMounted(
            (current) => current.copyWith(
              isSubmitting: false,
              submissionError: 'Invalid phone number.',
            ),
          );
          return false;
        }
        authUid = await auth.registerCustomerWithEmail(
          fullName: state.fullName.trim(),
          email: state.email.trim(),
          password: state.password,
          phone: phone,
          address: _customerCityAddress(),
        );
      } else {
        authUid = await auth.registerWithEmail(
          fullName: state.fullName.trim(),
          email: state.email.trim(),
          password: state.password,
        );
      }
      if (!ref.mounted) return false;

      if (!_updateStateIfMounted(
        (current) => current.copyWith(
          isSubmitting: false,
          lastAuthCredentialUid: authUid,
        ),
      )) {
        return false;
      }
      return true;
    } catch (error) {
      _updateStateIfMounted(
        (current) => current.copyWith(
          isSubmitting: false,
          submissionError: FirebaseErrorMessage.fromException(error),
        ),
      );
      return false;
    }
  }

  Future<bool> signUpWithGoogle() async {
    if (!_updateStateIfMounted(
      (current) => current.copyWith(
        oauthProviderInFlight: 'google',
        submissionError: null,
      ),
    )) {
      return false;
    }
    try {
      final role = _resolvedAuthRole();
      if (role == null) {
        _updateStateIfMounted(
          (current) => current.copyWith(
            oauthProviderInFlight: null,
            submissionError:
                'Choose Customer or Salon owner before signing up.',
          ),
        );
        return false;
      }
      await ref
          .read(authRepositoryProvider)
          .signInWithGoogle(newUserRole: role);
      if (!ref.mounted) return false;
      _updateStateIfMounted(
        (current) => current.copyWith(oauthProviderInFlight: null),
      );
      return true;
    } catch (error) {
      _updateStateIfMounted(
        (current) => current.copyWith(
          oauthProviderInFlight: null,
          submissionError: FirebaseErrorMessage.fromException(error),
        ),
      );
      return false;
    }
  }

  Future<bool> signUpWithApple() async {
    if (!_updateStateIfMounted(
      (current) => current.copyWith(
        oauthProviderInFlight: 'apple',
        submissionError: null,
      ),
    )) {
      return false;
    }
    try {
      final role = _resolvedAuthRole();
      if (role == null) {
        _updateStateIfMounted(
          (current) => current.copyWith(
            oauthProviderInFlight: null,
            submissionError:
                'Choose Customer or Salon owner before signing up.',
          ),
        );
        return false;
      }
      await ref.read(authRepositoryProvider).signInWithApple(newUserRole: role);
      if (!ref.mounted) return false;
      _updateStateIfMounted(
        (current) => current.copyWith(oauthProviderInFlight: null),
      );
      return true;
    } catch (error) {
      _updateStateIfMounted(
        (current) => current.copyWith(
          oauthProviderInFlight: null,
          submissionError: FirebaseErrorMessage.fromException(error),
        ),
      );
      return false;
    }
  }

  Future<bool> signUpWithFacebook() async {
    if (!_updateStateIfMounted(
      (current) => current.copyWith(
        oauthProviderInFlight: 'facebook',
        submissionError: null,
      ),
    )) {
      return false;
    }
    try {
      final role = _resolvedAuthRole();
      if (role == null) {
        _updateStateIfMounted(
          (current) => current.copyWith(
            oauthProviderInFlight: null,
            submissionError:
                'Choose Customer or Salon owner before signing up.',
          ),
        );
        return false;
      }
      await ref
          .read(authRepositoryProvider)
          .signInWithFacebook(newUserRole: role);
      if (!ref.mounted) return false;
      _updateStateIfMounted(
        (current) => current.copyWith(oauthProviderInFlight: null),
      );
      return true;
    } catch (error) {
      _updateStateIfMounted(
        (current) => current.copyWith(
          oauthProviderInFlight: null,
          submissionError: FirebaseErrorMessage.fromException(error),
        ),
      );
      return false;
    }
  }
}

class RegisterFormState {
  const RegisterFormState({
    this.fullName = '',
    this.email = '',
    this.phone = '',
    this.city = '',
    this.password = '',
    this.confirmPassword = '',
    this.nameTouched = false,
    this.emailTouched = false,
    this.phoneTouched = false,
    this.cityTouched = false,
    this.passwordTouched = false,
    this.confirmPasswordTouched = false,
    this.hasSubmitted = false,
    this.isSubmitting = false,
    this.oauthProviderInFlight,
    this.submissionError,
    this.intendedRole,
    this.lastAuthCredentialUid,
  });

  final String fullName;
  final String email;
  final String phone;
  final String city;
  final String password;
  final String confirmPassword;
  final bool nameTouched;
  final bool emailTouched;
  final bool phoneTouched;
  final bool cityTouched;
  final bool passwordTouched;
  final bool confirmPasswordTouched;
  final bool hasSubmitted;
  final bool isSubmitting;
  final String? oauthProviderInFlight;
  final String? submissionError;
  final String? intendedRole;
  final String? lastAuthCredentialUid;

  bool get isAnyAuthLoading => isSubmitting || oauthProviderInFlight != null;

  String? nameErrorFor(AppLocalizations l10n) => nameTouched || hasSubmitted
      ? LocalizedInputValidators.requiredField(
          l10n,
          fullName,
          l10n.fieldLabelName,
        )
      : null;

  String? emailErrorFor(AppLocalizations l10n) => emailTouched || hasSubmitted
      ? LocalizedInputValidators.email(l10n, email)
      : null;

  String? phoneErrorFor(AppLocalizations l10n) => phoneTouched || hasSubmitted
      ? LocalizedInputValidators.phone(l10n, phone)
      : null;

  String? cityErrorFor(AppLocalizations l10n) => cityTouched || hasSubmitted
      ? LocalizedInputValidators.requiredField(l10n, city, l10n.fieldLabelCity)
      : null;

  String? passwordErrorFor(AppLocalizations l10n) =>
      passwordTouched || hasSubmitted
      ? LocalizedInputValidators.passwordSignupMinSix(l10n, password)
      : null;

  String? confirmPasswordErrorFor(AppLocalizations l10n) =>
      confirmPasswordTouched || hasSubmitted
      ? LocalizedInputValidators.confirmPassword(
          l10n,
          password: password,
          confirmPassword: confirmPassword,
        )
      : null;

  bool get isFormValid {
    final isCustomer = intendedRole == UserRoles.customer;
    return InputValidators.isNonEmptyTrimmed(fullName) &&
        InputValidators.isValidEmail(email) &&
        InputValidators.isValidPhone(phone) &&
        InputValidators.isValidPasswordMinSix(password) &&
        password == confirmPassword &&
        (!isCustomer || InputValidators.isNonEmptyTrimmed(city));
  }

  RegisterFormState copyWith({
    String? fullName,
    String? email,
    String? phone,
    String? city,
    String? password,
    String? confirmPassword,
    bool? nameTouched,
    bool? emailTouched,
    bool? phoneTouched,
    bool? cityTouched,
    bool? passwordTouched,
    bool? confirmPasswordTouched,
    bool? hasSubmitted,
    bool? isSubmitting,
    Object? oauthProviderInFlight = _sentinel,
    Object? submissionError = _sentinel,
    String? intendedRole,
    Object? lastAuthCredentialUid = _sentinel,
  }) {
    return RegisterFormState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      nameTouched: nameTouched ?? this.nameTouched,
      emailTouched: emailTouched ?? this.emailTouched,
      phoneTouched: phoneTouched ?? this.phoneTouched,
      cityTouched: cityTouched ?? this.cityTouched,
      passwordTouched: passwordTouched ?? this.passwordTouched,
      confirmPasswordTouched:
          confirmPasswordTouched ?? this.confirmPasswordTouched,
      hasSubmitted: hasSubmitted ?? this.hasSubmitted,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      oauthProviderInFlight: oauthProviderInFlight == _sentinel
          ? this.oauthProviderInFlight
          : oauthProviderInFlight as String?,
      submissionError: submissionError == _sentinel
          ? this.submissionError
          : submissionError as String?,
      intendedRole: intendedRole ?? this.intendedRole,
      lastAuthCredentialUid: lastAuthCredentialUid == _sentinel
          ? this.lastAuthCredentialUid
          : lastAuthCredentialUid as String?,
    );
  }
}

const Object _sentinel = Object();
