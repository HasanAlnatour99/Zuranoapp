import 'package:fpdart/fpdart.dart';

import '../connectivity/connectivity_service.dart';
import '../failures/app_failure.dart';
import '../failures/app_failure_mapper.dart';
import '../logging/app_logger.dart';
import 'app_result.dart';

Future<AppResult<T>> guardResult<T>({
  required ConnectivityService connectivityService,
  required AppLogger logger,
  required String operation,
  required Future<T> Function() run,
  bool requiresNetwork = true,
}) async {
  final isOnline = requiresNetwork
      ? await connectivityService.isOnline()
      : true;
  if (!isOnline) {
    const failure = AppFailure.network(
      code: 'offline',
      message: 'No internet connection is available.',
    );
    logger.warn('$operation skipped while offline.');
    return left(failure);
  }

  try {
    final value = await run();
    logger.debug('$operation succeeded.');
    return right(value);
  } on Object catch (error, stackTrace) {
    final failure = AppFailureMapper.fromException(
      error,
      stackTrace: stackTrace,
      isOnline: isOnline,
    );
    logger.error(
      '$operation failed: ${failure.userMessage}',
      error: error,
      stackTrace: stackTrace,
    );
    return left(failure);
  }
}
