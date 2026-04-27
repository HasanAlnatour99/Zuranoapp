import 'package:barber_shop_app/core/connectivity/connectivity_service.dart';
import 'package:barber_shop_app/core/logging/app_logger.dart';
import 'package:barber_shop_app/core/result/app_result_guard.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

class _MockConnectivityService extends Mock implements ConnectivityService {}

class _MockAppLogger extends Mock implements AppLogger {}

void main() {
  test('logs error when booking operation fails', () async {
    final connectivity = _MockConnectivityService();
    final logger = _MockAppLogger();

    when(() => connectivity.isOnline()).thenAnswer((_) async => true);
    when(
      () => logger.error(
        any(),
        error: any(named: 'error'),
        stackTrace: any(named: 'stackTrace'),
      ),
    ).thenReturn(null);
    when(
      () => logger.debug(
        any(),
        error: any(named: 'error'),
        stackTrace: any(named: 'stackTrace'),
      ),
    ).thenReturn(null);
    when(
      () => logger.warn(
        any(),
        error: any(named: 'error'),
        stackTrace: any(named: 'stackTrace'),
      ),
    ).thenReturn(null);

    await guardResult<void>(
      connectivityService: connectivity,
      logger: logger,
      operation: 'createBooking',
      run: () async {
        throw StateError('booking failure');
      },
    );

    verify(
      () => logger.error(
        any(that: contains('createBooking failed')),
        error: any(named: 'error'),
        stackTrace: any(named: 'stackTrace'),
      ),
    ).called(1);
  }, tags: ['critical']);
}
