// Manual / emulator checklist (Phase 4):
// - Customer creates booking when users.salonId is null (Firestore create + Auth).
// - Customer cancels own booking; Firestore shows cancelledAt / cancelledBy* .
// - Reschedule: old doc status rescheduled + rescheduledToBookingId; new doc pending + rescheduledFromBookingId.
// - Barber stream only returns own barberId; cannot read another barber's doc by id.
// - Owner bookings list + cancel via bookingCancel.
// - Two bookings with identical startAt: pagination has no duplicate rows across pages.

import 'package:barber_shop_app/core/constants/payroll_statuses.dart';
import 'package:barber_shop_app/core/constants/sale_reporting.dart';
import 'package:barber_shop_app/features/expenses/data/models/expense.dart';
import 'package:barber_shop_app/features/owner/logic/owner_money_period.dart';
import 'package:barber_shop_app/features/owner/logic/owner_money_recognition.dart';
import 'package:barber_shop_app/features/payroll/data/models/payroll_record.dart';
import 'package:barber_shop_app/features/sales/data/models/sale.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 4, 18, 14, 30);

  group('OwnerMoneyAggregation operational', () {
    test('matches legacy sumSales / sumPayroll / sumExpenses', () {
      const mode = OwnerMoneyRecognitionMode.operational;
      final sales = [
        Sale(
          id: 's1',
          salonId: 'salon',
          employeeId: 'e1',
          employeeName: 'A',
          lineItems: const [],
          serviceNames: const ['Cut'],
          subtotal: 10,
          tax: 0,
          discount: 0,
          total: 10,
          paymentMethod: 'cash',
          status: SaleStatuses.completed,
          soldAt: DateTime(2026, 4, 18, 10),
          createdByUid: 'u',
          createdByName: 'n',
          reportYear: 2026,
          reportMonth: 4,
        ),
        Sale(
          id: 's2',
          salonId: 'salon',
          employeeId: 'e1',
          employeeName: 'A',
          lineItems: const [],
          serviceNames: const ['Cut'],
          subtotal: 5,
          tax: 0,
          discount: 0,
          total: 5,
          paymentMethod: 'cash',
          status: SaleStatuses.pending,
          soldAt: DateTime(2026, 4, 18, 11),
          createdByUid: 'u',
          createdByName: 'n',
        ),
      ];
      final payroll = [
        PayrollRecord(
          id: 'p1',
          salonId: 'salon',
          employeeId: 'e1',
          employeeName: 'A',
          periodStart: DateTime.utc(2026, 4, 1),
          periodEnd: DateTime.utc(2026, 4, 30),
          baseAmount: 0,
          commissionAmount: 0,
          bonusAmount: 0,
          deductionAmount: 0,
          netAmount: 100,
          status: PayrollStatuses.paid,
          month: 4,
          year: 2026,
          paidAt: DateTime(2026, 4, 18, 9),
        ),
      ];
      final expenses = [
        Expense(
          id: 'x1',
          salonId: 'salon',
          title: 'Supplies',
          category: 'other',
          amount: 20,
          incurredAt: DateTime(2026, 4, 18, 8),
          createdByUid: 'u',
          createdByName: 'n',
        ),
      ];

      for (final period in OwnerMoneyPeriodKind.values) {
        expect(
          OwnerMoneyAggregation.sumSales(sales, mode, period, now),
          sumSales(sales, period, now),
        );
        expect(
          OwnerMoneyAggregation.sumPayroll(payroll, mode, period, now),
          sumPayroll(payroll, period, now),
        );
        expect(
          OwnerMoneyAggregation.sumExpenses(expenses, mode, period, now),
          sumExpenses(expenses, period, now),
        );
      }
    });
  });

  group('OwnerMoneyAggregation cash', () {
    test('month payroll only counts paidAt in calendar month', () {
      const mode = OwnerMoneyRecognitionMode.cash;
      final paidThisMonth = PayrollRecord(
        id: 'p1',
        salonId: 'salon',
        employeeId: 'e1',
        employeeName: 'A',
        periodStart: DateTime.utc(2026, 3, 1),
        periodEnd: DateTime.utc(2026, 3, 31),
        baseAmount: 0,
        commissionAmount: 0,
        bonusAmount: 0,
        deductionAmount: 0,
        netAmount: 50,
        status: PayrollStatuses.paid,
        month: 3,
        year: 2026,
        paidAt: DateTime(2026, 4, 5),
      );
      final accruedOnly = PayrollRecord(
        id: 'p2',
        salonId: 'salon',
        employeeId: 'e1',
        employeeName: 'A',
        periodStart: DateTime.utc(2026, 4, 1),
        periodEnd: DateTime.utc(2026, 4, 30),
        baseAmount: 0,
        commissionAmount: 0,
        bonusAmount: 0,
        deductionAmount: 0,
        netAmount: 200,
        status: PayrollStatuses.approved,
        month: 4,
        year: 2026,
      );

      final sumCash = OwnerMoneyAggregation.sumPayroll(
        [paidThisMonth, accruedOnly],
        mode,
        OwnerMoneyPeriodKind.month,
        now,
      );
      expect(sumCash, 50);

      final sumOp = OwnerMoneyAggregation.sumPayroll(
        [paidThisMonth, accruedOnly],
        OwnerMoneyRecognitionMode.operational,
        OwnerMoneyPeriodKind.month,
        now,
      );
      expect(sumOp, 200);
    });
  });
}
