import '../../../core/connectivity/connectivity_service.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/result/app_result.dart';
import '../../../core/result/app_result_guard.dart';
import '../data/default_payroll_elements.dart';
import '../data/models/payroll_result_model.dart';
import '../data/payroll_calculation_service.dart';
import '../data/payroll_constants.dart';
import '../data/payroll_element_repository.dart';
import '../data/payroll_run_repository.dart';
import '../../violations/data/violation_repository.dart';

class PayrollRunUseCase {
  PayrollRunUseCase({
    required PayrollCalculationService payrollCalculationService,
    required PayrollRunRepository payrollRunRepository,
    required PayrollElementRepository payrollElementRepository,
    required ViolationRepository violationRepository,
    required ConnectivityService connectivityService,
    required AppLogger logger,
  }) : _payrollCalculationService = payrollCalculationService,
       _payrollRunRepository = payrollRunRepository,
       _payrollElementRepository = payrollElementRepository,
       _violationRepository = violationRepository,
       _connectivityService = connectivityService,
       _logger = logger;

  final PayrollCalculationService _payrollCalculationService;
  final PayrollRunRepository _payrollRunRepository;
  final PayrollElementRepository _payrollElementRepository;
  final ViolationRepository _violationRepository;
  final ConnectivityService _connectivityService;
  final AppLogger _logger;

  Future<AppResult<PayrollCalculationBundle>> calculate({
    required String salonId,
    required int year,
    required int month,
    required String createdBy,
    Iterable<String>? employeeIds,
    String? existingRunId,
  }) {
    return guardResult(
      connectivityService: _connectivityService,
      logger: _logger,
      operation: 'calculatePayrollRun',
      run: () async {
        await _ensureDefaultsSeeded(salonId);
        return _payrollCalculationService.calculatePayrollRun(
          salonId: salonId,
          year: year,
          month: month,
          createdBy: createdBy,
          employeeIds: employeeIds,
          existingRunId: existingRunId,
        );
      },
    );
  }

  Future<AppResult<String>> saveDraft(PayrollCalculationBundle bundle) {
    return _persistBundle(bundle, status: PayrollRunStatuses.draft);
  }

  Future<AppResult<String>> approve(
    PayrollCalculationBundle bundle, {
    required String approvedBy,
  }) {
    return _persistBundle(
      bundle,
      status: PayrollRunStatuses.approved,
      approvedBy: approvedBy,
    );
  }

  Future<AppResult<String>> pay(
    PayrollCalculationBundle bundle, {
    required String paidBy,
    String? approvedBy,
  }) {
    return _persistBundle(
      bundle,
      status: PayrollRunStatuses.paid,
      approvedBy: approvedBy ?? paidBy,
      paidBy: paidBy,
    );
  }

  Future<AppResult<void>> rollback({
    required String salonId,
    required String runId,
  }) {
    return guardResult(
      connectivityService: _connectivityService,
      logger: _logger,
      operation: 'rollbackPayrollRun',
      run: () async {
        final run = await _payrollRunRepository.getRun(salonId, runId);
        if (run == null) {
          throw ArgumentError.value(runId, 'runId', 'Payroll run not found.');
        }
        if (!PayrollRunStatuses.canRollback(run.status)) {
          throw StateError(
            'Only draft or approved payroll runs can be rolled back.',
          );
        }

        final results = await _payrollRunRepository.getResults(salonId, runId);
        final violationIds = _violationIdsFromResults(results);
        if (violationIds.isNotEmpty &&
            run.status == PayrollRunStatuses.approved) {
          await _violationRepository.rollbackPayrollRun(
            salonId,
            violationIds,
            payrollRunId: runId,
          );
        }

        await _payrollRunRepository.updateRun(
          salonId,
          run.copyWith(status: PayrollRunStatuses.rolledBack),
        );
      },
    );
  }

  Future<AppResult<String>> _persistBundle(
    PayrollCalculationBundle bundle, {
    required String status,
    String? approvedBy,
    String? paidBy,
  }) {
    return guardResult(
      connectivityService: _connectivityService,
      logger: _logger,
      operation: 'persistPayrollBundle',
      run: () async {
        await _ensureDefaultsSeeded(bundle.run.salonId);

        final now = DateTime.now();
        final run = bundle.run.copyWith(
          status: status,
          approvedBy:
              status == PayrollRunStatuses.approved ||
                  status == PayrollRunStatuses.paid
              ? approvedBy
              : null,
          approvedAt:
              status == PayrollRunStatuses.approved ||
                  status == PayrollRunStatuses.paid
              ? now
              : null,
          paidBy: status == PayrollRunStatuses.paid ? paidBy : null,
          paidAt: status == PayrollRunStatuses.paid ? now : null,
        );

        final runId = run.id.isEmpty
            ? await _payrollRunRepository.createRun(run.salonId, run)
            : run.id;

        if (run.id.isNotEmpty) {
          await _payrollRunRepository.updateRun(
            run.salonId,
            run.copyWith(id: runId),
          );
        }

        final persistedResults = bundle.results
            .map((result) => result.copyWith(payrollRunId: runId))
            .toList(growable: false);
        await _payrollRunRepository.replaceResults(
          run.salonId,
          runId,
          persistedResults,
        );

        if (status == PayrollRunStatuses.approved ||
            status == PayrollRunStatuses.paid) {
          final violationIds = _violationIdsFromResults(persistedResults);
          await _violationRepository.applyToPayrollRun(
            run.salonId,
            violationIds,
            payrollRunId: runId,
          );
        }

        return runId;
      },
    );
  }

  Future<void> _ensureDefaultsSeeded(String salonId) async {
    final existing = await _payrollElementRepository.getElements(
      salonId,
      activeOnly: false,
    );
    if (existing.length >= buildDefaultPayrollElements().length) {
      return;
    }
    await _payrollElementRepository.seedDefaultElements(salonId);
  }

  List<String> _violationIdsFromResults(List<PayrollResultModel> results) {
    return results
        .where(
          (result) =>
              result.sourceType == PayrollResultSourceTypes.systemGenerated &&
              (result.elementCode == 'attendance_deduction' ||
                  result.elementCode == 'absence_deduction' ||
                  result.elementCode == 'late_penalty'),
        )
        .expand((result) => result.sourceRefIds)
        .where((id) => id.trim().isNotEmpty)
        .toSet()
        .toList(growable: false);
  }
}
