import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_failure.freezed.dart';

@freezed
sealed class AppFailure with _$AppFailure {
  const AppFailure._();

  const factory AppFailure.validation({required String message, String? code}) =
      ValidationFailure;

  const factory AppFailure.network({required String message, String? code}) =
      NetworkFailure;

  const factory AppFailure.permission({required String message, String? code}) =
      PermissionFailure;

  const factory AppFailure.unauthenticated({
    required String message,
    String? code,
  }) = UnauthenticatedFailure;

  const factory AppFailure.notFound({required String message, String? code}) =
      NotFoundFailure;

  const factory AppFailure.server({required String message, String? code}) =
      ServerFailure;

  const factory AppFailure.unknown({required String message, String? code}) =
      UnknownFailure;

  String get userMessage => when(
    validation: (message, _) => message,
    network: (message, _) => message,
    permission: (message, _) => message,
    unauthenticated: (message, _) => message,
    notFound: (message, _) => message,
    server: (message, _) => message,
    unknown: (message, _) => message,
  );
}
