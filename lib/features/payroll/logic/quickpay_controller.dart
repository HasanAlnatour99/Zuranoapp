import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/repository_providers.dart';
import '../../../providers/session_provider.dart';
import '../data/payroll_calculation_service.dart';
import '../data/payroll_constants.dart';

class QuickPayState {
  const QuickPayState({
    this.selectedEmployeeId,
    required this.period,
    this.bundle,
    this.savedRunId,
    this.isBusy = false,
    this.error,
  });

  final String? selectedEmployeeId;
  final DateTime period;
  final PayrollCalculationBundle? bundle;
  final String? savedRunId;
  final bool isBusy;
  final String? error;

  QuickPayState copyWith({
    Object? selectedEmployeeId = _sentinel,
    DateTime? period,
    Object? bundle = _sentinel,
    Object? savedRunId = _sentinel,
    bool? isBusy,
    Object? error = _sentinel,
  }) {
    return QuickPayState(
      selectedEmployeeId: identical(selectedEmployeeId, _sentinel)
          ? this.selectedEmployeeId
          : selectedEmployeeId as String?,
      period: period ?? this.period,
      bundle: identical(bundle, _sentinel)
          ? this.bundle
          : bundle as PayrollCalculationBundle?,
      savedRunId: identical(savedRunId, _sentinel)
          ? this.savedRunId
          : savedRunId as String?,
      isBusy: isBusy ?? this.isBusy,
      error: identical(error, _sentinel) ? this.error : error as String?,
    );
  }
}

final quickPayControllerProvider =
    NotifierProvider.autoDispose<QuickPayController, QuickPayState>(
      QuickPayController.new,
    );

class QuickPayController extends Notifier<QuickPayState> {
  @override
  QuickPayState build() {
    final now = DateTime.now();
    return QuickPayState(period: DateTime(now.year, now.month));
  }

  void selectEmployee(String? employeeId) {
    state = state.copyWith(
      selectedEmployeeId: employeeId,
      error: null,
      bundle: null,
      savedRunId: null,
    );
  }

  void selectPeriod(DateTime period) {
    state = state.copyWith(
      period: DateTime(period.year, period.month),
      error: null,
      bundle: null,
      savedRunId: null,
    );
  }

  Future<void> calculate() async {
    final employeeId = state.selectedEmployeeId?.trim();
    final session = ref.read(sessionUserProvider).asData?.value;
    final salonId = session?.salonId?.trim();
    if (employeeId == null ||
        employeeId.isEmpty ||
        salonId == null ||
        salonId.isEmpty ||
        session == null) {
      state = state.copyWith(error: 'missing');
      return;
    }

    state = state.copyWith(isBusy: true, error: null);
    final result = await ref
        .read(quickPayUseCaseProvider)
        .calculate(
          salonId: salonId,
          employeeId: employeeId,
          year: state.period.year,
          month: state.period.month,
          createdBy: session.uid,
          existingRunId: state.savedRunId,
        );
    result.match(
      (failure) =>
          state = state.copyWith(isBusy: false, error: failure.userMessage),
      (bundle) =>
          state = state.copyWith(isBusy: false, bundle: bundle, error: null),
    );
  }

  Future<String?> saveDraft() async {
    final bundle = state.bundle;
    if (bundle == null) {
      return null;
    }
    state = state.copyWith(isBusy: true, error: null);
    final result = await ref.read(quickPayUseCaseProvider).saveDraft(bundle);
    return result.match(
      (failure) {
        state = state.copyWith(isBusy: false, error: failure.userMessage);
        return null;
      },
      (runId) {
        state = state.copyWith(
          isBusy: false,
          savedRunId: runId,
          bundle: PayrollCalculationBundle(
            run: bundle.run.copyWith(
              id: runId,
              status: PayrollRunStatuses.draft,
            ),
            results: bundle.results,
            employeeStatements: bundle.employeeStatements,
          ),
        );
        return runId;
      },
    );
  }

  Future<String?> approve() async {
    final bundle = state.bundle;
    final session = ref.read(sessionUserProvider).asData?.value;
    if (bundle == null || session == null) {
      return null;
    }
    state = state.copyWith(isBusy: true, error: null);
    final result = await ref
        .read(quickPayUseCaseProvider)
        .approve(bundle, approvedBy: session.uid);
    return result.match(
      (failure) {
        state = state.copyWith(isBusy: false, error: failure.userMessage);
        return null;
      },
      (runId) {
        state = state.copyWith(
          isBusy: false,
          savedRunId: runId,
          bundle: PayrollCalculationBundle(
            run: bundle.run.copyWith(
              id: runId,
              status: PayrollRunStatuses.approved,
            ),
            results: bundle.results,
            employeeStatements: bundle.employeeStatements,
          ),
        );
        return runId;
      },
    );
  }

  Future<String?> pay() async {
    final bundle = state.bundle;
    final session = ref.read(sessionUserProvider).asData?.value;
    if (bundle == null || session == null) {
      return null;
    }
    state = state.copyWith(isBusy: true, error: null);
    final result = await ref
        .read(quickPayUseCaseProvider)
        .pay(bundle, paidBy: session.uid);
    return result.match(
      (failure) {
        state = state.copyWith(isBusy: false, error: failure.userMessage);
        return null;
      },
      (runId) {
        state = state.copyWith(
          isBusy: false,
          savedRunId: runId,
          bundle: PayrollCalculationBundle(
            run: bundle.run.copyWith(
              id: runId,
              status: PayrollRunStatuses.paid,
            ),
            results: bundle.results,
            employeeStatements: bundle.employeeStatements,
          ),
        );
        return runId;
      },
    );
  }

  Future<bool> rollback() async {
    final session = ref.read(sessionUserProvider).asData?.value;
    final salonId = session?.salonId?.trim();
    final runId = state.savedRunId?.trim();
    if (salonId == null || salonId.isEmpty || runId == null || runId.isEmpty) {
      return false;
    }
    state = state.copyWith(isBusy: true, error: null);
    final result = await ref
        .read(quickPayUseCaseProvider)
        .rollback(salonId: salonId, runId: runId);
    return result.match(
      (failure) {
        state = state.copyWith(isBusy: false, error: failure.userMessage);
        return false;
      },
      (_) {
        final bundle = state.bundle;
        state = state.copyWith(
          isBusy: false,
          bundle: bundle == null
              ? null
              : PayrollCalculationBundle(
                  run: bundle.run.copyWith(
                    id: runId,
                    status: PayrollRunStatuses.rolledBack,
                  ),
                  results: bundle.results,
                  employeeStatements: bundle.employeeStatements,
                ),
        );
        return true;
      },
    );
  }
}

const Object _sentinel = Object();
