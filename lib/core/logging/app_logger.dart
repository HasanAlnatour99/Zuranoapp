import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

abstract class AppLogger {
  void trace(String message, {Object? error, StackTrace? stackTrace});

  void debug(String message, {Object? error, StackTrace? stackTrace});

  void info(String message, {Object? error, StackTrace? stackTrace});

  void warn(String message, {Object? error, StackTrace? stackTrace});

  void error(String message, {Object? error, StackTrace? stackTrace});
}

class LoggerAppLogger implements AppLogger {
  LoggerAppLogger({Logger? logger})
    : _logger =
          logger ??
          Logger(
            level: kDebugMode ? Level.trace : Level.info,
            printer: PrettyPrinter(methodCount: 0, errorMethodCount: 8),
          );

  final Logger _logger;

  @override
  void trace(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.t(message, error: error, stackTrace: stackTrace);
  }

  @override
  void debug(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  @override
  void info(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  @override
  void warn(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  @override
  void error(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
}
