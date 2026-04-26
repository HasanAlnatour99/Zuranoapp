import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/firebase_error_message.dart';
import '../../../core/utils/input_validators.dart';
import '../../../core/utils/localized_input_validators.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/repository_providers.dart';
import '../domain/value_objects/country_option.dart';
import '../domain/value_objects/user_address.dart';
import '../domain/value_objects/user_phone.dart';

final salonOwnerSignupControllerProvider =
    NotifierProvider.autoDispose<
      SalonOwnerSignupController,
      SalonOwnerSignupState
    >(SalonOwnerSignupController.new);

class SalonOwnerSignupController extends Notifier<SalonOwnerSignupState> {
  @override
  SalonOwnerSignupState build() => const SalonOwnerSignupState();

  void updateFullName(String v) => state = state.copyWith(
    fullName: v,
    fullNameTouched: true,
    submissionError: null,
  );

  void updateEmail(String v) => state = state.copyWith(
    email: v,
    emailTouched: true,
    submissionError: null,
  );

  void updatePassword(String v) => state = state.copyWith(
    password: v,
    passwordTouched: true,
    submissionError: null,
  );

  void updateConfirmPassword(String v) => state = state.copyWith(
    confirmPassword: v,
    confirmPasswordTouched: true,
    submissionError: null,
  );

  void updateCountry(CountryOption? v) => state = state.copyWith(
    country: v,
    countryTouched: true,
    submissionError: null,
  );

  void updatePhoneNational(String v) => state = state.copyWith(
    phoneNational: v,
    phoneTouched: true,
    submissionError: null,
  );

  Future<bool> submit() async {
    state = state.copyWith(hasSubmitted: true, submissionError: null);
    if (!state.isFormValid) {
      return false;
    }
    if (state.isSubmitting) {
      return false;
    }

    final country = state.country!;
    final phone = UserPhone.fromDialAndNational(
      countryIsoCode: country.isoCode,
      dialCode: country.dialCode,
      nationalDigits: state.phoneNational,
    );

    final ownerCountryAddress = UserAddress(
      countryCode: country.isoCode,
      countryName: country.nameEn,
      city: '',
      street: '',
      building: null,
      postalCode: null,
      formattedAddress: country.nameEn,
    );

    final trimmedFullName = state.fullName.trim();
    final trimmedEmail = state.email.trim();
    final password = state.password;

    final authRepository = ref.read(authRepositoryProvider);

    state = state.copyWith(isSubmitting: true);

    try {
      await authRepository.registerSalonOwnerAccount(
        fullName: trimmedFullName,
        email: trimmedEmail,
        password: password,
        phone: phone,
        ownerCountryAddress: ownerCountryAddress,
      );
      if (!ref.mounted) return false;
      state = state.copyWith(isSubmitting: false);
      return true;
    } catch (e) {
      if (!ref.mounted) return false;
      state = state.copyWith(
        isSubmitting: false,
        submissionError: FirebaseErrorMessage.fromException(e),
      );
      return false;
    }
  }
}

class SalonOwnerSignupState {
  const SalonOwnerSignupState({
    this.fullName = '',
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.country,
    this.phoneNational = '',
    this.fullNameTouched = false,
    this.emailTouched = false,
    this.passwordTouched = false,
    this.confirmPasswordTouched = false,
    this.countryTouched = false,
    this.phoneTouched = false,
    this.hasSubmitted = false,
    this.isSubmitting = false,
    this.submissionError,
  });

  final String fullName;
  final String email;
  final String password;
  final String confirmPassword;
  final CountryOption? country;
  final String phoneNational;
  final bool fullNameTouched;
  final bool emailTouched;
  final bool passwordTouched;
  final bool confirmPasswordTouched;
  final bool countryTouched;
  final bool phoneTouched;
  final bool hasSubmitted;
  final bool isSubmitting;
  final String? submissionError;

  bool get _showErrors => hasSubmitted;

  String? fullNameError(AppLocalizations l10n) =>
      (fullNameTouched || _showErrors)
      ? LocalizedInputValidators.requiredField(
          l10n,
          fullName,
          l10n.fieldLabelFullName,
        )
      : null;

  String? emailError(AppLocalizations l10n) => (emailTouched || _showErrors)
      ? LocalizedInputValidators.email(l10n, email)
      : null;

  String? passwordError(AppLocalizations l10n) =>
      (passwordTouched || _showErrors)
      ? LocalizedInputValidators.password(l10n, password)
      : null;

  String? confirmPasswordError(AppLocalizations l10n) =>
      (confirmPasswordTouched || _showErrors)
      ? LocalizedInputValidators.confirmPassword(
          l10n,
          password: password,
          confirmPassword: confirmPassword,
        )
      : null;

  String? countryError(AppLocalizations l10n) =>
      (countryTouched || _showErrors) && country == null
      ? l10n.validationCountryRequired
      : null;

  String? phoneError(AppLocalizations l10n) {
    if (!(phoneTouched || _showErrors)) return null;
    if (country == null) return l10n.validationCountryRequired;
    final combined =
        '${country!.dialCode}${phoneNational.replaceAll(RegExp(r'\D'), '')}';
    return LocalizedInputValidators.phone(l10n, combined);
  }

  bool get isFormValid {
    if (!InputValidators.isNonEmptyTrimmed(fullName)) return false;
    if (!InputValidators.isValidEmail(email)) return false;
    if (!InputValidators.isValidPassword(password)) return false;
    if (!InputValidators.passwordsMatch(
      password: password,
      confirmValue: confirmPassword,
    )) {
      return false;
    }
    if (country == null) return false;
    final combined =
        '${country!.dialCode}${phoneNational.replaceAll(RegExp(r'\D'), '')}';
    if (!InputValidators.isValidPhone(combined)) return false;
    return true;
  }

  SalonOwnerSignupState copyWith({
    String? fullName,
    String? email,
    String? password,
    String? confirmPassword,
    Object? country = _sentinel,
    String? phoneNational,
    bool? fullNameTouched,
    bool? emailTouched,
    bool? passwordTouched,
    bool? confirmPasswordTouched,
    bool? countryTouched,
    bool? phoneTouched,
    bool? hasSubmitted,
    bool? isSubmitting,
    Object? submissionError = _sentinel2,
  }) {
    return SalonOwnerSignupState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      country: country == _sentinel ? this.country : country as CountryOption?,
      phoneNational: phoneNational ?? this.phoneNational,
      fullNameTouched: fullNameTouched ?? this.fullNameTouched,
      emailTouched: emailTouched ?? this.emailTouched,
      passwordTouched: passwordTouched ?? this.passwordTouched,
      confirmPasswordTouched:
          confirmPasswordTouched ?? this.confirmPasswordTouched,
      countryTouched: countryTouched ?? this.countryTouched,
      phoneTouched: phoneTouched ?? this.phoneTouched,
      hasSubmitted: hasSubmitted ?? this.hasSubmitted,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submissionError: submissionError == _sentinel2
          ? this.submissionError
          : submissionError as String?,
    );
  }
}

const Object _sentinel = Object();
const Object _sentinel2 = Object();
