import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/repository_providers.dart';
import '../../../providers/session_provider.dart';
import '../data/payroll_calculation_service.dart';
import '../data/payroll_constants.dart';

class PayrollRunReviewState {
  const PayrollRunReviewState({
    required this.period,
    this.selectedEmployeeIds = const [],
    this.bundle,
    this.savedRunId,
    this.isBusy = false,
    this.error,
  });

  final DateTime period;
  final List<String> selectedEmployeeIds;
  final PayrollCalculationBundle? bundle;
  final String? savedRunId;
  final bool isBusy;
  final String? error;

  PayrollRunReviewState copyWith({
    DateTime? period,
    List<String>? selectedEmployeeIds,
    Object? bundle = _sentinel,
    Object? savedRunId = _sentinel,
    bool? isBusy,
    Object? error = _sentinel,
  }) {
    return PayrollRunReviewState(
      period: period ?? this.period,
      selectedEmployeeIds: selectedEmployeeIds ?? this.selectedEmployeeIds,
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

final payrollRunReviewControllerProvider =
    NotifierProvider.autoDispose<
      PayrollRunReviewController,
      PayrollRunReviewState
    >(PayrollRunReviewController.new);

class PayrollRunReviewController extends Notifier<PayrollRunReviewState> {
  @override
  PayrollRunReviewState build() {
    final now = DateTime.now();
    return PayrollRunReviewState(period: DateTime(now.year, now.month));
  }

  void selectPeriod(DateTime period) {
    state = state.copyWith(
      period: DateTime(period.year, period.month),
      bundle: null,
      savedRunId: null,
      error: null,
    );
  }

  void toggleEmployee(String employeeId) {
    final current = state.selectedEmployeeIds.toSet();
    if (current.contains(employeeId)) {
      current.remove(employeeId);
    } else {
      current.add(employeeId);
    }
    state = state.copyWith(
      selectedEmployeeIds: current.toList(growable: false),
      bundle: null,
      savedRunId: null,
      error: null,
    );
  }

  void clearEmployeeFilter() {
    state = state.copyWith(
      selectedEmployeeIds: const [],
      bundle: null,
      savedRunId: null,
      error: null,
    );
  }

  Future<void> calculate() async {
    final session = ref.read(sessionUserProvider).asData?.value;
    final salonId = session?.salonId?.trim();
    if (session == null || salonId == null || salonId.isEmpty) {
      state = state.copyWith(error: 'missing');
      return;
    }

    state = state.copyWith(isBusy: true, error: null);
    final result = await ref
        .read(payrollRunUseCaseProvider)
        .calculate(
          salonId: salonId,
          year: state.period.year,
          month: state.period.month,
          createdBy: session.uid,
          employeeIds: state.selectedEmployeeIds.isEmpty
              ? null
              : state.selectedEmployeeIds,
          existingRunId: state.savedRunId,
        );
    result.match(
      (failure) =>
          state = state.copyWith(isBusy: false, error: failure.userMessage),
      (bundle) => state = state.copyWith(isBusy: false, bundle: bundle),
    );
  }

  Future<String?> saveDraft() async {
    final bundle = state.bundle;
    if (bundle == null) {
      return null;
    }
    state = state.copyWith(isBusy: true, error: null);
    final result = await ref.read(payrollRunUseCaseProvider).saveDraft(bundle);
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
        .read(payrollRunUseCaseProvider)
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
        .read(payrollRunUseCaseProvider)
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
        .read(payrollRunUseCaseProvider)
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
