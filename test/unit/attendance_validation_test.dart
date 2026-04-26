import 'package:barber_shop_app/core/constants/attendance_approval.dart';
import 'package:barber_shop_app/features/attendance/data/models/attendance_record.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Unit - attendance validation logic', () {
    test('fromJson normalizes missing dateKey from workDate', () {
      final record = AttendanceRecord.fromJson({
        'id': 'a-1',
        'salonId': 'salon-1',
        'employeeId': 'emp-1',
        'employeeName': 'Barber',
        'status': 'present',
        'workDate': DateTime.utc(2026, 4, 22),
      });

      expect(record.dateKey, '2026-04-22');
      expect(record.approvalStatus, AttendanceApprovalStatuses.pending);
    });
  });
}
