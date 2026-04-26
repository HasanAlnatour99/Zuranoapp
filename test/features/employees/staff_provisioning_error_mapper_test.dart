import 'package:flutter_test/flutter_test.dart';

import 'package:barber_shop_app/features/employees/data/staff_provisioning_error_mapper.dart';
import 'package:barber_shop_app/features/employees/domain/staff_provisioning_exception.dart';

void main() {
  group('staffProvisioningFailureKindForCode', () {
    test('maps already-exists to emailAlreadyExists', () {
      expect(
        staffProvisioningFailureKindForCode('already-exists'),
        StaffProvisioningFailureKind.emailAlreadyExists,
      );
    });

    test('maps permission-denied and unauthenticated', () {
      expect(
        staffProvisioningFailureKindForCode('permission-denied'),
        StaffProvisioningFailureKind.permissionDenied,
      );
      expect(
        staffProvisioningFailureKindForCode('unauthenticated'),
        StaffProvisioningFailureKind.permissionDenied,
      );
    });

    test('maps transport-style codes to network', () {
      for (final code in <String>[
        'unavailable',
        'deadline-exceeded',
        'resource-exhausted',
      ]) {
        expect(
          staffProvisioningFailureKindForCode(code),
          StaffProvisioningFailureKind.network,
        );
      }
    });

    test('maps unknown codes to unknown', () {
      expect(
        staffProvisioningFailureKindForCode('internal'),
        StaffProvisioningFailureKind.unknown,
      );
    });
  });
}
