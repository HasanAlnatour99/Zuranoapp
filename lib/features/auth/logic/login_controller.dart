import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/debug/agent_session_log.dart';
import '../../../core/constants/user_roles.dart';
import '../../../core/utils/firebase_error_message.dart';
import '../../../core/utils/input_validators.dart';
import '../../../core/utils/localized_input_validators.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/onboarding_providers.dart';
import '../../../providers/repository_providers.dart';

final loginControllerProvider =
    NotifierProvider.autoDispose<LoginController, LoginFormState>(
      LoginController.new,
    );

class LoginController extends Notifier<LoginFormState> {
  @override
  LoginFormState build() => const LoginFormState();

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

  Future<bool> sendPasswordReset(String email) async {
    try {
      await ref.read(authRepositoryProvider).sendPasswordResetEmail(email);
      return true;
    } catch (error) {
      state = state.copyWith(
        submissionError: FirebaseErrorMessage.fromException(error),
      );
      return false;
    }
  }

  Future<bool> submit() async {
    state = state.copyWith(hasSubmitted: true, submissionError: null);
    // #region agent log
    agentSessionLog(
      hypothesisId: 'H3',
      location: 'login_controller.dart:submit',
      message: 'submit_enter',
      data: <String, Object?>{
        'isFormValid': state.isFormValid,
        'emailLen': state.email.trim().length,
        'pwLen': state.password.length,
      },
    );
    // #endregion
    if (!state.isFormValid) {
      // #region agent log
      agentSessionLog(
        hypothesisId: 'H3',
        location: 'login_controller.dart:submit',
        message: 'submit_blocked_invalid_form',
        data: const <String, Object?>{},
      );
      // #endregion
      return false;
    }

    state = state.copyWith(isSubmitting: true);

    try {
      final authUid = await ref
          .read(authRepositoryProvider)
          .login(email: state.email.trim(), password: state.password);
      agentSessionLog(
        hypothesisId: 'H4',
        location: 'login_controller.dart:submit',
        message: 'login_uid_from_credential',
        data: <String, Object?>{'uid': authUid},
      );
      final intentRole = _resolvedAuthRole();
      if (intentRole != null) {
        await ref
            .read(authRepositoryProvider)
            .ensureMinimalUserDocumentIfMissing(preferredRole: intentRole);
      }
      state = state.copyWith(isSubmitting: false);
      // #region agent log
      agentSessionLog(
        hypothesisId: 'H4',
        location: 'login_controller.dart:submit',
        message: 'submit_ok',
        data: const <String, Object?>{},
      );
      // #endregion
      return true;
    } catch (error) {
      state = state.copyWith(
        isSubmitting: false,
        submissionError: FirebaseErrorMessage.fromException(error),
      );
      // #region agent log
      agentSessionLog(
        hypothesisId: 'H4',
        location: 'login_controller.dart:submit',
        message: 'submit_auth_error',
        data: <String, Object?>{'errType': error.runtimeType.toString()},
      );
      // #endregion
      return false;
    }
  }

  String? _resolvedAuthRole() {
    final r = ref.read(onboardingPrefsProvider).selectedAuthRole?.trim();
    if (r == UserRoles.owner || r == UserRoles.customer) {
      return r;
    }
    return null;
  }

  Future<bool> signInWithGoogle() async {
    state = state.copyWith(
      oauthProviderInFlight: 'google',
      submissionError: null,
    );
    try {
      final role = _resolvedAuthRole();
      if (role == null) {
        state = state.copyWith(
          oauthProviderInFlight: null,
          submissionError:
              'Choose User or Salon owner before signing in with Google.',
        );
        return false;
      }
      await ref
          .read(authRepositoryProvider)
          .signInWithGoogle(newUserRole: role);
      state = state.copyWith(oauthProviderInFlight: null);
      return true;
    } catch (error) {
      state = state.copyWith(
        oauthProviderInFlight: null,
        submissionError: FirebaseErrorMessage.fromException(error),
      );
      return false;
    }
  }

  Future<bool> signInWithApple() async {
    state = state.copyWith(
      oauthProviderInFlight: 'apple',
      submissionError: null,
    );
    try {
      final role = _resolvedAuthRole();
      if (role == null) {
        state = state.copyWith(
          oauthProviderInFlight: null,
          submissionError:
              'Choose User or Salon owner before signing in with Apple.',
        );
        return false;
      }
      await ref.read(authRepositoryProvider).signInWithApple(newUserRole: role);
      state = state.copyWith(oauthProviderInFlight: null);
      return true;
    } catch (error) {
      state = state.copyWith(
        oauthProviderInFlight: null,
        submissionError: FirebaseErrorMessage.fromException(error),
      );
      return false;
    }
  }

  Future<bool> signInWithFacebook() async {
    state = state.copyWith(
      oauthProviderInFlight: 'facebook',
      submissionError: null,
    );
    try {
      final role = _resolvedAuthRole();
      if (role == null) {
        state = state.copyWith(
          oauthProviderInFlight: null,
          submissionError:
              'Choose User or Salon owner before signing in with Facebook.',
        );
        return false;
      }
      await ref
          .read(authRepositoryProvider)
          .signInWithFacebook(newUserRole: role);
      state = state.copyWith(oauthProviderInFlight: null);
      return true;
    } catch (error) {
      state = state.copyWith(
        oauthProviderInFlight: null,
        submissionError: FirebaseErrorMessage.fromException(error),
      );
      return false;
    }
  }
}

class LoginFormState {
  const LoginFormState({
    this.email = '',
    this.password = '',
    this.emailTouched = false,
    this.passwordTouched = false,
    this.hasSubmitted = false,
    this.isSubmitting = false,
    this.oauthProviderInFlight,
    this.submissionError,
  });

  final String email;
  final String password;
  final bool emailTouched;
  final bool passwordTouched;
  final bool hasSubmitted;
  final bool isSubmitting;
  final String? oauthProviderInFlight;
  final String? submissionError;

  bool get isAnyAuthLoading => isSubmitting || oauthProviderInFlight != null;

  String? emailErrorFor(AppLocalizations l10n) => emailTouched || hasSubmitted
      ? LocalizedInputValidators.email(l10n, email)
      : null;

  String? passwordErrorFor(AppLocalizations l10n) =>
      passwordTouched || hasSubmitted
      ? LocalizedInputValidators.password(l10n, password)
      : null;

  bool get isFormValid =>
      InputValidators.isValidEmail(email) &&
      InputValidators.isValidPassword(password);

  LoginFormState copyWith({
    String? email,
    String? password,
    bool? emailTouched,
    bool? passwordTouched,
    bool? hasSubmitted,
    bool? isSubmitting,
    Object? oauthProviderInFlight = _sentinel,
    Object? submissionError = _sentinel,
  }) {
    return LoginFormState(
      email: email ?? this.email,
      password: password ?? this.password,
      emailTouched: emailTouched ?? this.emailTouched,
      passwordTouched: passwordTouched ?? this.passwordTouched,
      hasSubmitted: hasSubmitted ?? this.hasSubmitted,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      oauthProviderInFlight: oauthProviderInFlight == _sentinel
          ? this.oauthProviderInFlight
          : oauthProviderInFlight as String?,
      submissionError: submissionError == _sentinel
          ? this.submissionError
          : submissionError as String?,
    );
  }
}

const Object _sentinel = Object();
