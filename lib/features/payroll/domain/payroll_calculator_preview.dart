/// Payroll totals are computed only on the backend (Cloud Functions) and stored
/// on [PayslipModel]. The employee app must not derive net pay from raw inputs.
abstract final class PayrollCalculatorPreview {
  const PayrollCalculatorPreview._();
}
