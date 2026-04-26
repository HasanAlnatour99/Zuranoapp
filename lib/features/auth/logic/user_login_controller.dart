import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/staff_internal_auth_email.dart';
import '../../../core/constants/user_roles.dart';
import '../../../core/debug/agent_session_log.dart';
import '../../../core/utils/firebase_error_message.dart';
import '../../../core/utils/input_validators.dart';
import '../../../core/utils/localized_firebase_auth_messages.dart';
import '../../../core/utils/localized_input_validators.dart';
import '../../../l10n/app_localizations.dart';
import '../../../providers/repository_providers.dart';
import '../data/staff_login_remote_data_source.dart';

const Object _oauthSentinel = Object();

final staffLoginRemoteDataSourceProvider = Provider<StaffLoginRemoteDataSource>(
  (ref) {
    return StaffLoginRemoteDataSource();
  },
);

final userLoginControllerProvider =
    NotifierProvider.autoDispose<UserLoginController, UserLoginFormState>(
      UserLoginController.new,
    );

class UserLoginController extends Notifier<UserLoginFormState> {
  @override
  UserLoginFormState build() => const UserLoginFormState();

  void updateIdentifier(String value) {
    // Emails and staff usernames are matched case-insensitively; keep state canonical
    // so validation, autofill, and submit never depend on casing the user typed.
    final canonical = value.trim().toLowerCase();
    state = state.copyWith(
      identifier: canonical,
      identifierTouched: true,
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
      await ref
          .read(authRepositoryProvider)
          .sendPasswordResetEmail(email.trim().toLowerCase());
      return true;
    } catch (error) {
      state = state.copyWith(
        submissionError: FirebaseErrorMessage.fromException(error),
      );
      return false;
    }
  }

  Future<bool> submit(
    AppLocalizations l10n, {
    bool staffCredentialPortal = false,
  }) async {
    state = state.copyWith(hasSubmitted: true, submissionError: null);
    if (!state.isFormValid) {
      return false;
    }

    state = state.copyWith(isSubmitting: true);

    final trimmedId = state.identifier.trim();
    final hasAt = trimmedId.contains('@');
    final normalizedIdentifier = trimmedId.toLowerCase();
    final trimmedPassword = state.password.trim();
    final identifierLooksLikePersonalEmail =
        hasAt &&
        !StaffInternalAuthEmail.isInternalMailbox(normalizedIdentifier);

    if (kDebugMode) {
      agentSessionLog(
        hypothesisId: 'H4',
        location: 'user_login_controller.dart:submit',
        message: 'login_attempt_start',
        data: <String, Object?>{
          'staffCredentialPortal': staffCredentialPortal,
          'identifierHasAt': hasAt,
        },
      );
    }

    try {
      late final String authEmail;
      late final bool usedCustomerEmailPath;

      if (!hasAt) {
        authEmail = await ref
            .read(staffLoginRemoteDataSourceProvider)
            .resolveEmailForStaffUsername(normalizedIdentifier);
        usedCustomerEmailPath = false;
      } else {
        authEmail = normalizedIdentifier;
        usedCustomerEmailPath = !StaffInternalAuthEmail.isInternalMailbox(
          normalizedIdentifier,
        );
      }

      if (kDebugMode) {
        agentSessionLog(
          hypothesisId: 'H4',
          location: 'user_login_controller.dart:submit',
          message: 'user_login_attempt',
          data: <String, Object?>{
            'normalizedIdentifier': normalizedIdentifier,
            'authEmailDomain': authEmail.contains('@')
                ? authEmail.split('@').last
                : '',
            'usedCustomerEmailPath': usedCustomerEmailPath,
            'passwordLength': trimmedPassword.length,
          },
        );
      }

      final authUid = await ref
          .read(authRepositoryProvider)
          .login(email: authEmail, password: trimmedPassword);

      if (kDebugMode) {
        agentSessionLog(
          hypothesisId: 'H4',
          location: 'user_login_controller.dart:submit',
          message: 'login_auth_success',
          data: <String, Object?>{'uid': authUid},
        );
      }

      if (staffCredentialPortal) {
        final staffGate = await _validateStaffPortalSession(l10n, authUid);
        if (staffGate != null) {
          state = state.copyWith(
            isSubmitting: false,
            submissionError: staffGate,
          );
          return false;
        }
      }

      if (usedCustomerEmailPath && !staffCredentialPortal) {
        await ref
            .read(authRepositoryProvider)
            .ensureMinimalUserDocumentIfMissing(
              preferredRole: UserRoles.customer,
            );
      }

      state = state.copyWith(isSubmitting: false);
      return true;
    } on FirebaseFunctionsException catch (error) {
      if (kDebugMode) {
        agentSessionLog(
          hypothesisId: 'H4',
          location: 'user_login_controller.dart:submit',
          message: 'user_login_functions_error',
          data: <String, Object?>{
            'code': error.code,
            'message': error.message ?? '',
          },
        );
      }
      state = state.copyWith(
        isSubmitting: false,
        submissionError: LocalizedFirebaseAuthMessages.userLoginFailure(
          l10n,
          error,
          identifierLooksLikePersonalEmail: identifierLooksLikePersonalEmail,
          staffCredentialPortal: staffCredentialPortal,
        ),
      );
      return false;
    } on FirebaseAuthException catch (error) {
      if (kDebugMode) {
        agentSessionLog(
          hypothesisId: 'H4',
          location: 'user_login_controller.dart:submit',
          message: 'user_login_auth_error',
          data: <String, Object?>{
            'code': error.code,
            'message': error.message ?? '',
          },
        );
      }
      state = state.copyWith(
        isSubmitting: false,
        submissionError: LocalizedFirebaseAuthMessages.userLoginFailure(
          l10n,
          error,
          identifierLooksLikePersonalEmail: identifierLooksLikePersonalEmail,
          staffCredentialPortal: staffCredentialPortal,
        ),
      );
      return false;
    } catch (error) {
      if (kDebugMode) {
        agentSessionLog(
          hypothesisId: 'H4',
          location: 'user_login_controller.dart:submit',
          message: 'user_login_unknown_error',
          data: <String, Object?>{'type': error.runtimeType.toString()},
        );
      }
      state = state.copyWith(
        isSubmitting: false,
        submissionError: FirebaseErrorMessage.fromException(error),
      );
      return false;
    }
  }

  /// After Firebase Auth succeeds on the staff portal: require `users/{uid}`,
  /// active staff role, and a linked `employees/{employeeId}` row.
  Future<String?> _validateStaffPortalSession(
    AppLocalizations l10n,
    String uid,
  ) async {
    final authRepo = ref.read(authRepositoryProvider);
    final userRepo = ref.read(userRepositoryProvider);
    final employeeRepo = ref.read(employeeRepositoryProvider);

    final user = await userRepo.getUser(uid);
    if (user == null) {
      if (kDebugMode) {
        agentSessionLog(
          hypothesisId: 'H4',
          location: 'user_login_controller.dart:_validateStaffPortalSession',
          message: 'user_doc_missing',
          data: <String, Object?>{'uid': uid},
        );
      }
      await authRepo.logout();
      return l10n.authStaffLoginUserDocMissing;
    }
    if (!user.isActive) {
      if (kDebugMode) {
        agentSessionLog(
          hypothesisId: 'H4',
          location: 'user_login_controller.dart:_validateStaffPortalSession',
          message: 'user_inactive',
          data: <String, Object?>{'uid': uid},
        );
      }
      await authRepo.logout();
      return l10n.authStaffLoginUserInactive;
    }

    if (user.role == UserRoles.customer || user.role == UserRoles.owner) {
      await authRepo.logout();
      return l10n.authStaffLoginWrongPortal;
    }
    if (!UserRoles.isStaffRole(user.role)) {
      await authRepo.logout();
      return l10n.authStaffLoginWrongPortal;
    }

    final sid = user.salonId?.trim();
    final eid = user.employeeId?.trim();
    if (sid == null || sid.isEmpty || eid == null || eid.isEmpty) {
      if (kDebugMode) {
        agentSessionLog(
          hypothesisId: 'H4',
          location: 'user_login_controller.dart:_validateStaffPortalSession',
          message: 'employee_doc_missing',
          data: <String, Object?>{'uid': uid},
        );
      }
      await authRepo.logout();
      return l10n.authStaffLoginEmployeeDocMissing;
    }

    final employee = await employeeRepo.getEmployee(sid, eid);
    if (employee == null) {
      if (kDebugMode) {
        agentSessionLog(
          hypothesisId: 'H4',
          location: 'user_login_controller.dart:_validateStaffPortalSession',
          message: 'employee_doc_missing',
          data: <String, Object?>{'uid': uid, 'salonId': sid},
        );
      }
      await authRepo.logout();
      return l10n.authStaffLoginEmployeeDocMissing;
    }
    if (!employee.isActive) {
      if (kDebugMode) {
        agentSessionLog(
          hypothesisId: 'H4',
          location: 'user_login_controller.dart:_validateStaffPortalSession',
          message: 'employee_inactive',
          data: <String, Object?>{'uid': uid},
        );
      }
      await authRepo.logout();
      return l10n.authStaffLoginEmployeeInactive;
    }

    if (kDebugMode) {
      agentSessionLog(
        hypothesisId: 'H4',
        location: 'user_login_controller.dart:_validateStaffPortalSession',
        message: 'login_success',
        data: <String, Object?>{'uid': uid, 'role': user.role, 'salonId': sid},
      );
    }
    return null;
  }

  Future<bool> signInWithGoogle() async {
    state = state.copyWith(
      oauthProviderInFlight: 'google',
      submissionError: null,
    );
    try {
      await ref
          .read(authRepositoryProvider)
          .signInWithGoogle(newUserRole: UserRoles.customer);
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
      await ref
          .read(authRepositoryProvider)
          .signInWithApple(newUserRole: UserRoles.customer);
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
      await ref
          .read(authRepositoryProvider)
          .signInWithFacebook(newUserRole: UserRoles.customer);
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

class UserLoginFormState {
  const UserLoginFormState({
    this.identifier = '',
    this.password = '',
    this.identifierTouched = false,
    this.passwordTouched = false,
    this.hasSubmitted = false,
    this.isSubmitting = false,
    this.oauthProviderInFlight,
    this.submissionError,
  });

  final String identifier;
  final String password;
  final bool identifierTouched;
  final bool passwordTouched;
  final bool hasSubmitted;
  final bool isSubmitting;
  final String? oauthProviderInFlight;
  final String? submissionError;

  bool get isAnyAuthLoading => isSubmitting || oauthProviderInFlight != null;

  String? identifierErrorFor(AppLocalizations l10n) =>
      identifierTouched || hasSubmitted
      ? LocalizedInputValidators.userLoginIdentifier(l10n, identifier)
      : null;

  String? passwordErrorFor(AppLocalizations l10n) =>
      passwordTouched || hasSubmitted
      ? LocalizedInputValidators.password(l10n, password)
      : null;

  bool get isFormValid =>
      InputValidators.isValidUserLoginIdentifier(identifier) &&
      InputValidators.isValidPassword(password);

  UserLoginFormState copyWith({
    String? identifier,
    String? password,
    bool? identifierTouched,
    bool? passwordTouched,
    bool? hasSubmitted,
    bool? isSubmitting,
    Object? oauthProviderInFlight = _oauthSentinel,
    Object? submissionError = _sentinel,
  }) {
    return UserLoginFormState(
      identifier: identifier ?? this.identifier,
      password: password ?? this.password,
      identifierTouched: identifierTouched ?? this.identifierTouched,
      passwordTouched: passwordTouched ?? this.passwordTouched,
      hasSubmitted: hasSubmitted ?? this.hasSubmitted,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      oauthProviderInFlight: oauthProviderInFlight == _oauthSentinel
          ? this.oauthProviderInFlight
          : oauthProviderInFlight as String?,
      submissionError: submissionError == _sentinel
          ? this.submissionError
          : submissionError as String?,
    );
  }
}

const Object _sentinel = Object();
