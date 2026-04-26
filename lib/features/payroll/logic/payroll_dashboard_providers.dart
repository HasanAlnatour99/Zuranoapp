import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/user_roles.dart';
import '../../../providers/repository_providers.dart';
import '../../../providers/session_provider.dart';
import '../../employees/data/models/employee.dart';
import '../data/models/employee_element_entry_model.dart';
import '../data/models/payroll_element_model.dart';
import '../data/models/payroll_result_model.dart';
import '../data/models/payroll_run_model.dart';
import '../data/payroll_constants.dart';

class PayrollDashboardSummary {
  const PayrollDashboardSummary({
    required this.month,
    required this.totalNetPay,
    required this.totalEarnings,
    required this.totalDeductions,
    required this.draftCount,
    required this.approvedCount,
    required this.paidCount,
    required this.rolledBackCount,
    required this.recentRuns,
  });

  final DateTime month;
  final double totalNetPay;
  final double totalEarnings;
  final double totalDeductions;
  final int draftCount;
  final int approvedCount;
  final int paidCount;
  final int rolledBackCount;
  final List<PayrollRunModel> recentRuns;
}

class PayrollStatusBreakdown {
  const PayrollStatusBreakdown({
    required this.draft,
    required this.approved,
    required this.paid,
    required this.rolledBack,
  });

  final int draft;
  final int approved;
  final int paid;
  final int rolledBack;
}

final payrollRunsStreamProvider = StreamProvider<List<PayrollRunModel>>((ref) {
  final repo = ref.watch(payrollRunRepositoryProvider);
  return watchSessionSalonId(ref).asyncExpand((salonId) {
    if (salonId == null || salonId.isEmpty) {
      return Stream.value(const <PayrollRunModel>[]);
    }
    return repo.watchRuns(salonId, limit: 60);
  });
});

final payrollElementsStreamProvider = StreamProvider<List<PayrollElementModel>>(
  (ref) {
    final repo = ref.watch(payrollElementRepositoryProvider);
    return watchSessionSalonId(ref).asyncExpand((salonId) {
      if (salonId == null || salonId.isEmpty) {
        return Stream.value(const <PayrollElementModel>[]);
      }
      return repo.watchElements(salonId, activeOnly: false);
    });
  },
);

class PayrollDashboardMonthNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    final now = DateTime.now();
    return DateTime(now.year, now.month);
  }

  void selectMonth(DateTime month) {
    state = DateTime(month.year, month.month);
  }
}

final payrollDashboardMonthProvider =
    NotifierProvider<PayrollDashboardMonthNotifier, DateTime>(
      PayrollDashboardMonthNotifier.new,
    );

final payrollDashboardSummaryProvider =
    Provider<AsyncValue<PayrollDashboardSummary>>((ref) {
      final selectedMonth = ref.watch(payrollDashboardMonthProvider);
      final runsAsync = ref.watch(payrollRunsStreamProvider);
      return runsAsync.whenData((runs) {
        final monthRuns = runs
            .where(
              (run) =>
                  run.year == selectedMonth.year &&
                  run.month == selectedMonth.month,
            )
            .toList(growable: false);
        return PayrollDashboardSummary(
          month: selectedMonth,
          totalNetPay: monthRuns.fold<double>(
            0,
            (sum, run) => sum + run.netPay,
          ),
          totalEarnings: monthRuns.fold<double>(
            0,
            (sum, run) => sum + run.totalEarnings,
          ),
          totalDeductions: monthRuns.fold<double>(
            0,
            (sum, run) => sum + run.totalDeductions,
          ),
          draftCount: monthRuns
              .where((run) => run.status == PayrollRunStatuses.draft)
              .length,
          approvedCount: monthRuns
              .where((run) => run.status == PayrollRunStatuses.approved)
              .length,
          paidCount: monthRuns
              .where((run) => run.status == PayrollRunStatuses.paid)
              .length,
          rolledBackCount: monthRuns
              .where((run) => run.status == PayrollRunStatuses.rolledBack)
              .length,
          recentRuns: runs.take(6).toList(growable: false),
        );
      });
    });

final payrollStatusBreakdownProvider =
    Provider<AsyncValue<PayrollStatusBreakdown>>((ref) {
      final runsAsync = ref.watch(payrollRunsStreamProvider);
      return runsAsync.whenData(
        (runs) => PayrollStatusBreakdown(
          draft: runs
              .where((run) => run.status == PayrollRunStatuses.draft)
              .length,
          approved: runs
              .where((run) => run.status == PayrollRunStatuses.approved)
              .length,
          paid: runs
              .where((run) => run.status == PayrollRunStatuses.paid)
              .length,
          rolledBack: runs
              .where((run) => run.status == PayrollRunStatuses.rolledBack)
              .length,
        ),
      );
    });

final employeesMissingPayrollSetupProvider = FutureProvider<List<Employee>>((
  ref,
) async {
  final salonId = ref.watch(sessionUserProvider).asData?.value?.salonId?.trim();
  if (salonId == null || salonId.isEmpty) {
    return const <Employee>[];
  }
  final employeeRepository = ref.read(employeeRepositoryProvider);
  final entryRepository = ref.read(employeeElementEntryRepositoryProvider);

  final employees = await employeeRepository.getEmployees(
    salonId,
    onlyActive: true,
  );
  final eligibleEmployees = employees
      .where((employee) => employee.role != UserRoles.owner)
      .toList(growable: false);

  final missing = <Employee>[];
  for (final employee in eligibleEmployees) {
    final entries = await entryRepository.getEntriesForEmployee(
      salonId,
      employee.id,
      activeOnly: true,
    );
    final hasBasicSalary = entries.any(
      (entry) =>
          entry.elementCode == 'basic_salary' &&
          entry.recurrenceType == PayrollRecurrenceTypes.recurring,
    );
    if (!hasBasicSalary) {
      missing.add(employee);
    }
  }
  return missing;
});

final employeePayrollEntriesProvider =
    FutureProvider.family<List<EmployeeElementEntryModel>, String>((
      ref,
      employeeId,
    ) async {
      final salonId = ref
          .watch(sessionUserProvider)
          .asData
          ?.value
          ?.salonId
          ?.trim();
      if (salonId == null || salonId.isEmpty || employeeId.trim().isEmpty) {
        return const <EmployeeElementEntryModel>[];
      }
      return ref
          .read(employeeElementEntryRepositoryProvider)
          .getEntriesForEmployee(salonId, employeeId);
    });

final employeePayrollHistoryProvider =
    StreamProvider.family<List<PayrollRunModel>, String>((ref, employeeId) {
      final salonId = ref
          .watch(sessionUserProvider)
          .asData
          ?.value
          ?.salonId
          ?.trim();
      if (salonId == null || salonId.isEmpty || employeeId.trim().isEmpty) {
        return Stream.value(const <PayrollRunModel>[]);
      }
      return ref
          .read(payrollRunRepositoryProvider)
          .watchRunsForEmployee(salonId, employeeId);
    });

typedef PayslipQuery = ({String runId, String employeeId});

class PayslipData {
  const PayslipData({required this.run, required this.results});

  final PayrollRunModel? run;
  final List<PayrollResultModel> results;
}

final payslipDataProvider = FutureProvider.family<PayslipData, PayslipQuery>((
  ref,
  query,
) async {
  final salonId = ref.watch(sessionUserProvider).asData?.value?.salonId?.trim();
  if (salonId == null ||
      salonId.isEmpty ||
      query.runId.trim().isEmpty ||
      query.employeeId.trim().isEmpty) {
    return const PayslipData(run: null, results: <PayrollResultModel>[]);
  }

  final runRepository = ref.read(payrollRunRepositoryProvider);
  final run = await runRepository.getRun(salonId, query.runId);
  final results = await runRepository.getResults(
    salonId,
    query.runId,
    employeeId: query.employeeId,
  );
  return PayslipData(run: run, results: results);
});
