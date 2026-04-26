/// `salons/{salonId}/payroll/{id}.status` values for reporting and workflows.
abstract final class PayrollStatuses {
  static const draft = 'draft';
  static const pendingApproval = 'pending_approval';
  static const approved = 'approved';
  static const paid = 'paid';
  static const voided = 'voided';

  /// Replaced or discarded monthly payslip (distinct from [voided] legacy payroll).
  static const cancelled = 'cancelled';
}
