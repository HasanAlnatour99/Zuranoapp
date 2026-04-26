import 'dart:async';
import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'app_failure.dart';

abstract final class AppFailureMapper {
  static AppFailure fromException(
    Object error, {
    StackTrace? stackTrace,
    bool? isOnline,
  }) {
    if (error is AppFailure) {
      return error;
    }

    if (isOnline == false) {
      return const AppFailure.network(
        code: 'offline',
        message: 'No internet connection is available.',
      );
    }

    if (error is TimeoutException || error is SocketException) {
      return const AppFailure.network(
        code: 'network-timeout',
        message: 'A network error occurred. Please try again.',
      );
    }

    if (error is FirebaseAuthException) {
      return _fromFirebaseAuth(error);
    }

    if (error is FirebaseFunctionsException) {
      return _fromFunctions(error);
    }

    if (error is FirebaseException) {
      return _fromFirebase(error);
    }

    if (error is ArgumentError) {
      return AppFailure.validation(
        code: error.name,
        message: error.message?.toString() ?? 'The provided data is invalid.',
      );
    }

    if (error is StateError) {
      return AppFailure.server(
        code: 'invalid-state',
        message: error.message.toString(),
      );
    }

    return AppFailure.unknown(
      code: error.runtimeType.toString(),
      message: error.toString(),
    );
  }

  static AppFailure _fromFirebaseAuth(FirebaseAuthException error) {
    return switch (error.code) {
      'network-request-failed' => const AppFailure.network(
        code: 'network-request-failed',
        message: 'A network error occurred. Please try again.',
      ),
      'user-not-found' ||
      'wrong-password' ||
      'invalid-credential' => const AppFailure.validation(
        code: 'invalid-credential',
        message: 'The email or password is incorrect.',
      ),
      'email-already-in-use' => const AppFailure.validation(
        code: 'email-already-in-use',
        message: 'An account already exists for this email address.',
      ),
      'requires-recent-login' => const AppFailure.unauthenticated(
        code: 'requires-recent-login',
        message: 'Please sign in again to continue.',
      ),
      'user-disabled' => const AppFailure.permission(
        code: 'user-disabled',
        message: 'This account has been disabled.',
      ),
      _ => AppFailure.server(
        code: error.code,
        message: error.message ?? 'Authentication failed.',
      ),
    };
  }

  static AppFailure _fromFunctions(FirebaseFunctionsException error) {
    return switch (error.code) {
      'unavailable' || 'deadline-exceeded' => AppFailure.network(
        code: error.code,
        message: error.message ?? 'A network error occurred. Please try again.',
      ),
      'unauthenticated' => AppFailure.unauthenticated(
        code: error.code,
        message: error.message ?? 'Please sign in again to continue.',
      ),
      'permission-denied' => AppFailure.permission(
        code: error.code,
        message: error.message ?? 'You do not have access to this action.',
      ),
      'not-found' => AppFailure.notFound(
        code: error.code,
        message: error.message ?? 'The requested record was not found.',
      ),
      'invalid-argument' || 'failed-precondition' => AppFailure.validation(
        code: error.code,
        message: error.message ?? 'The submitted data is invalid.',
      ),
      _ => AppFailure.server(
        code: error.code,
        message: error.message ?? 'The operation could not be completed.',
      ),
    };
  }

  static AppFailure _fromFirebase(FirebaseException error) {
    return switch (error.code) {
      'permission-denied' => AppFailure.permission(
        code: error.code,
        message: error.message ?? 'You do not have access to this action.',
      ),
      'not-found' => AppFailure.notFound(
        code: error.code,
        message: error.message ?? 'The requested record was not found.',
      ),
      'unavailable' || 'network-request-failed' => AppFailure.network(
        code: error.code,
        message: error.message ?? 'A network error occurred. Please try again.',
      ),
      _ => AppFailure.server(
        code: error.code,
        message: error.message ?? 'The operation could not be completed.',
      ),
    };
  }
}
