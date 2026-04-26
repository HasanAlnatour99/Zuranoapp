import 'package:barber_shop_app/features/payroll/data/payroll_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('netFromParts subtracts deductions', () {
    expect(
      PayrollService.netFromParts(
        baseAmount: 0,
        commissionAmount: 100,
        bonusAmount: 20,
        deductionAmount: 30,
      ),
      90,
    );
  });

  test('roundMoney uses two decimals', () {
    expect(PayrollService.roundMoney(10.126), 10.13);
  });
}
