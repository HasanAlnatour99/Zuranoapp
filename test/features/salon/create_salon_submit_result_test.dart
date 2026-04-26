import 'package:barber_shop_app/features/salon/logic/create_salon_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('CreateSalonSubmitResult.success carries salonId', () {
    const r = CreateSalonSubmitResult.success('salon-1');
    expect(r.didSucceed, isTrue);
    expect(r.salonId, 'salon-1');
    expect(r.errorMessage, isNull);
  });

  test('CreateSalonSubmitResult.failure carries message', () {
    const r = CreateSalonSubmitResult.failure('oops');
    expect(r.didSucceed, isFalse);
    expect(r.salonId, isNull);
    expect(r.errorMessage, 'oops');
  });

  test('CreateSalonSubmitResult.validationFailed has no salonId', () {
    const r = CreateSalonSubmitResult.validationFailed();
    expect(r.didSucceed, isFalse);
    expect(r.salonId, isNull);
  });
}
