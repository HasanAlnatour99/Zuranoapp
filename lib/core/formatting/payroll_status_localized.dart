import '../constants/payroll_statuses.dart';
import '../../l10n/app_localizations.dart';

String localizedPayrollStatus(AppLocalizations l10n, String status) {
  return switch (status) {
    PayrollStatuses.draft => l10n.payrollStatusDraft,
    PayrollStatuses.pendingApproval => l10n.payrollStatusPendingApproval,
    PayrollStatuses.approved => l10n.payrollStatusApproved,
    PayrollStatuses.paid => l10n.payrollStatusPaid,
    PayrollStatuses.voided => l10n.payrollStatusVoided,
    'rolled_back' => l10n.payrollStatusRolledBack,
    _ => status,
  };
}
