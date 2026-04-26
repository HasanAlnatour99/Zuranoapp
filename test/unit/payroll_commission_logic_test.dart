import 'package:barber_shop_app/features/payroll/data/payroll_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Unit - payroll commission calculation logic', () {
    test('commission and net are rounded and computed correctly', () {
      final commission = PayrollService.commissionAmountFromSales(1234.56, 10);
      final net = PayrollService.netFromParts(
        baseAmount: 0,
        commissionAmount: commission,
        bonusAmount: 50,
        deductionAmount: 20.123,
      );

      expect(commission, 123.46);
      expect(net, 153.34);
    });
  });
}
