import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/currency_for_country.dart';
import '../../../core/utils/firebase_error_message.dart';
import '../../../core/utils/input_validators.dart';
import '../../../core/utils/localized_input_validators.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/onboarding_providers.dart';
import '../../../providers/repository_providers.dart';
import '../../../providers/session_provider.dart';
import '../../../providers/firebase_providers.dart';
import '../../../router/router_session_refresh.dart';
import '../../onboarding/domain/value_objects/salon_business_type.dart';
import '../../onboarding/domain/value_objects/user_address.dart';
import '../../onboarding/domain/value_objects/country_option.dart';

final class CreateSalonOnboardingSubmitResult {
  const CreateSalonOnboardingSubmitResult._({
    required this.didSucceed,
    this.salonId,
    this.errorMessage,
  });

  const CreateSalonOnboardingSubmitResult.success(String salonId)
    : this._(didSucceed: true, salonId: salonId);

  const CreateSalonOnboardingSubmitResult.failure(String message)
    : this._(didSucceed: false, errorMessage: message);

  const CreateSalonOnboardingSubmitResult.validationFailed()
    : this._(didSucceed: false);

  final bool didSucceed;
  final String? salonId;
  final String? errorMessage;
}

final createSalonOnboardingControllerProvider =
    NotifierProvider.autoDispose<
      CreateSalonOnboardingController,
      CreateSalonOnboardingFormState
    >(CreateSalonOnboardingController.new);

class CreateSalonOnboardingController
    extends Notifier<CreateSalonOnboardingFormState> {
  @override
  CreateSalonOnboardingFormState build() =>
      const CreateSalonOnboardingFormState();

  Future<void> _waitUntilUserDocShowsSalonId(String uid) async {
    final userRepo = ref.read(userRepositoryProvider);
    const step = Duration(milliseconds: 200);
    final deadline = DateTime.now().add(const Duration(seconds: 15));
    refreshSessionAndRouter(ref);
    while (DateTime.now().isBefore(deadline)) {
      final u = await userRepo.getUser(uid);
      final sid = u?.salonId?.trim();
      if (sid != null && sid.isNotEmpty) {
        refreshSessionAndRouter(ref);
        await Future<void>.delayed(const Duration(milliseconds: 80));
        return;
      }
      await Future<void>.delayed(step);
    }
    refreshSessionAndRouter(ref);
  }

  Future<CreateSalonOnboardingSubmitResult> submit() async {
    if (state.isSubmitting) {
      return const CreateSalonOnboardingSubmitResult.validationFailed();
    }

    state = state.copyWith(hasSubmitted: true, submissionError: null);
    final prefs = ref.read(onboardingPrefsProvider);
    final hasCountry =
        prefs.countryCompleted &&
        (prefs.countryCode != null && prefs.countryCode!.trim().isNotEmpty);
    if (!hasCountry) {
      return const CreateSalonOnboardingSubmitResult.validationFailed();
    }
    if (!state.isFormValid) {
      return const CreateSalonOnboardingSubmitResult.validationFailed();
    }

    var session = ref.read(sessionUserProvider).asData?.value;
    final authRepo = ref.read(authRepositoryProvider);
    var authUid = authRepo.lastCredentialUid;
    if (authUid == null || authUid.isEmpty) {
      authUid = ref.read(firebaseAuthProvider).currentUser?.uid;
    }
    if (session == null && authUid != null) {
      session = await ref.read(userRepositoryProvider).getUser(authUid);
    }
    if (session == null) {
      const msg =
          'No active authenticated user/profile found. Please sign in again.';
      state = state.copyWith(submissionError: msg);
      return const CreateSalonOnboardingSubmitResult.failure(msg);
    }

    final userRepo = ref.read(userRepositoryProvider);
    final fresh = await userRepo.getUser(session.uid);
    if (fresh != null) {
      final existingSalon = fresh.salonId?.trim();
      if (existingSalon != null && existingSalon.isNotEmpty) {
        await _waitUntilUserDocShowsSalonId(session.uid);
        if (!ref.mounted) {
          return CreateSalonOnboardingSubmitResult.success(existingSalon);
        }
        return CreateSalonOnboardingSubmitResult.success(existingSalon);
      }
      session = fresh;
    }

    final prefsCountry = ref.read(onboardingPrefsProvider).countryCode;
    final country =
        CountryOption.tryFindByIso(prefsCountry) ??
        CountryOption.tryFindByIso('QA')!;

    state = state.copyWith(isSubmitting: true);

    final street = state.optionalAddress.trim().isEmpty
        ? '—'
        : state.optionalAddress.trim();

    final address = UserAddress.salonLocation(
      countryCode: country.isoCode,
      countryName: country.nameEn,
      city: state.city.trim(),
      street: street,
      building: '',
      postalCode: null,
    );

    final currency = currencyCodeForCountryIso(country.isoCode);

    try {
      final created = await ref
          .read(salonRepositoryProvider)
          .createSalonForOwner(
            owner: session,
            salonName: state.salonName.trim(),
            businessType: SalonBusinessType.barber,
            address: address,
            contactPhone: null,
            currencyCode: currency,
          );
      await _waitUntilUserDocShowsSalonId(session.uid);
      if (!ref.mounted) {
        return CreateSalonOnboardingSubmitResult.success(created.salonId);
      }
      state = state.copyWith(isSubmitting: false);
      return CreateSalonOnboardingSubmitResult.success(created.salonId);
    } on FirebaseAuthException catch (error) {
      final msg = FirebaseErrorMessage.fromException(error);
      if (!ref.mounted) {
        return CreateSalonOnboardingSubmitResult.failure(msg);
      }
      state = state.copyWith(isSubmitting: false, submissionError: msg);
      return CreateSalonOnboardingSubmitResult.failure(msg);
    } on FirebaseException catch (error) {
      final msg = FirebaseErrorMessage.fromException(error);
      if (!ref.mounted) {
        return CreateSalonOnboardingSubmitResult.failure(msg);
      }
      state = state.copyWith(isSubmitting: false, submissionError: msg);
      return CreateSalonOnboardingSubmitResult.failure(msg);
    } catch (error) {
      final msg = FirebaseErrorMessage.fromException(error);
      if (!ref.mounted) {
        return CreateSalonOnboardingSubmitResult.failure(msg);
      }
      state = state.copyWith(isSubmitting: false, submissionError: msg);
      return CreateSalonOnboardingSubmitResult.failure(msg);
    }
  }

  void updateSalonName(String value) {
    state = state.copyWith(
      salonName: value,
      salonNameTouched: true,
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

  void updateOptionalAddress(String value) {
    state = state.copyWith(
      optionalAddress: value,
      addressTouched: true,
      submissionError: null,
    );
  }
}

class CreateSalonOnboardingFormState {
  const CreateSalonOnboardingFormState({
    this.salonName = '',
    this.city = '',
    this.optionalAddress = '',
    this.salonNameTouched = false,
    this.cityTouched = false,
    this.addressTouched = false,
    this.hasSubmitted = false,
    this.isSubmitting = false,
    this.submissionError,
  });

  final String salonName;
  final String city;
  final String optionalAddress;
  final bool salonNameTouched;
  final bool cityTouched;
  final bool addressTouched;
  final bool hasSubmitted;
  final bool isSubmitting;
  final String? submissionError;

  bool get _show => hasSubmitted;

  String? salonNameErrorFor(AppLocalizations l10n) => salonNameTouched || _show
      ? LocalizedInputValidators.requiredField(
          l10n,
          salonName,
          l10n.fieldLabelSalonName,
        )
      : null;

  String? cityErrorFor(AppLocalizations l10n) => cityTouched || _show
      ? LocalizedInputValidators.requiredField(l10n, city, l10n.fieldLabelCity)
      : null;

  bool get isFormValid =>
      InputValidators.isNonEmptyTrimmed(salonName) &&
      InputValidators.isNonEmptyTrimmed(city);

  CreateSalonOnboardingFormState copyWith({
    String? salonName,
    String? city,
    String? optionalAddress,
    bool? salonNameTouched,
    bool? cityTouched,
    bool? addressTouched,
    bool? hasSubmitted,
    bool? isSubmitting,
    Object? submissionError = _sentinel,
  }) {
    return CreateSalonOnboardingFormState(
      salonName: salonName ?? this.salonName,
      city: city ?? this.city,
      optionalAddress: optionalAddress ?? this.optionalAddress,
      salonNameTouched: salonNameTouched ?? this.salonNameTouched,
      cityTouched: cityTouched ?? this.cityTouched,
      addressTouched: addressTouched ?? this.addressTouched,
      hasSubmitted: hasSubmitted ?? this.hasSubmitted,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submissionError: submissionError == _sentinel
          ? this.submissionError
          : submissionError as String?,
    );
  }
}

const Object _sentinel = Object();
