import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../employee_dashboard/application/employee_dashboard_providers.dart';
import '../../../providers/repository_providers.dart';
import '../data/models/payroll_ai_summary_model.dart';
import '../data/models/payslip_model.dart';

class PayrollSelectedMonthNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    final now = DateTime.now();
    return DateTime(now.year, now.month);
  }

  void setMonth(DateTime value) => state = DateTime(value.year, value.month);
}

final payrollSelectedMonthProvider =
    NotifierProvider<PayrollSelectedMonthNotifier, DateTime>(
      PayrollSelectedMonthNotifier.new,
    );

final currentEmployeePayslipProvider =
    StreamProvider.family<PayslipModel?, DateTime>((ref, month) {
      final repo = ref.watch(payslipRepositoryProvider);
      final scope = ref.watch(employeeWorkspaceScopeProvider);
      if (scope == null) {
        return Stream<PayslipModel?>.value(null);
      }
      return repo.watchEmployeePayslip(
        salonId: scope.salonId,
        employeeId: scope.employeeId,
        year: month.year,
        month: month.month,
      );
    });

final employeeRecentPayslipsProvider = StreamProvider<List<PayslipModel>>((
  ref,
) {
  final repo = ref.watch(payslipRepositoryProvider);
  final scope = ref.watch(employeeWorkspaceScopeProvider);
  if (scope == null) {
    return Stream<List<PayslipModel>>.value(const []);
  }
  return repo.watchRecentEmployeePayslips(
    salonId: scope.salonId,
    employeeId: scope.employeeId,
    limit: 6,
  );
});

final employeeSalaryNotesProvider =
    StreamProvider.family<PayrollAiSummaryModel?, String>((ref, payslipId) {
      final repo = ref.watch(payslipRepositoryProvider);
      final scope = ref.watch(employeeWorkspaceScopeProvider);
      if (scope == null) {
        return Stream<PayrollAiSummaryModel?>.value(null);
      }
      return repo.watchSalaryNotes(
        salonId: scope.salonId,
        payslipId: payslipId,
      );
    });

final employeePayslipDetailProvider =
    FutureProvider.family<PayslipModel?, String>((ref, payslipId) async {
      final repo = ref.watch(payslipRepositoryProvider);
      final scope = ref.watch(employeeWorkspaceScopeProvider);
      if (scope == null) {
        return null;
      }
      return repo.getPayslipForEmployee(
        salonId: scope.salonId,
        employeeId: scope.employeeId,
        payslipId: payslipId,
      );
    });
