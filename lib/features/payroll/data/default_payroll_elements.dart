import 'models/payroll_element_model.dart';
import 'payroll_constants.dart';

List<PayrollElementModel> buildDefaultPayrollElements() {
  return const [
    _SeedElement(
      code: 'basic_salary',
      name: 'Basic Salary',
      classification: PayrollElementClassifications.earning,
      recurrenceType: PayrollRecurrenceTypes.recurring,
      calculationMethod: PayrollCalculationMethods.fixed,
      isSystemElement: true,
      displayOrder: 10,
    ),
    _SeedElement(
      code: 'commission',
      name: 'Commission',
      classification: PayrollElementClassifications.earning,
      recurrenceType: PayrollRecurrenceTypes.nonrecurring,
      calculationMethod: PayrollCalculationMethods.derived,
      isSystemElement: true,
      displayOrder: 20,
    ),
    _SeedElement(
      code: 'bonus',
      name: 'Bonus',
      classification: PayrollElementClassifications.earning,
      recurrenceType: PayrollRecurrenceTypes.nonrecurring,
      calculationMethod: PayrollCalculationMethods.fixed,
      displayOrder: 30,
    ),
    _SeedElement(
      code: 'overtime',
      name: 'Overtime',
      classification: PayrollElementClassifications.earning,
      recurrenceType: PayrollRecurrenceTypes.nonrecurring,
      calculationMethod: PayrollCalculationMethods.derived,
      displayOrder: 40,
    ),
    _SeedElement(
      code: 'manual_earning',
      name: 'Manual Earning',
      classification: PayrollElementClassifications.earning,
      recurrenceType: PayrollRecurrenceTypes.nonrecurring,
      calculationMethod: PayrollCalculationMethods.fixed,
      displayOrder: 50,
    ),
    _SeedElement(
      code: 'attendance_deduction',
      name: 'Attendance Deduction',
      classification: PayrollElementClassifications.deduction,
      recurrenceType: PayrollRecurrenceTypes.nonrecurring,
      calculationMethod: PayrollCalculationMethods.derived,
      isSystemElement: true,
      displayOrder: 110,
    ),
    _SeedElement(
      code: 'absence_deduction',
      name: 'Absence Deduction',
      classification: PayrollElementClassifications.deduction,
      recurrenceType: PayrollRecurrenceTypes.nonrecurring,
      calculationMethod: PayrollCalculationMethods.derived,
      isSystemElement: true,
      displayOrder: 120,
    ),
    _SeedElement(
      code: 'late_penalty',
      name: 'Late Penalty',
      classification: PayrollElementClassifications.deduction,
      recurrenceType: PayrollRecurrenceTypes.nonrecurring,
      calculationMethod: PayrollCalculationMethods.derived,
      isSystemElement: true,
      displayOrder: 130,
    ),
    _SeedElement(
      code: 'manual_deduction',
      name: 'Manual Deduction',
      classification: PayrollElementClassifications.deduction,
      recurrenceType: PayrollRecurrenceTypes.nonrecurring,
      calculationMethod: PayrollCalculationMethods.fixed,
      displayOrder: 140,
    ),
    _SeedElement(
      code: 'loan_deduction',
      name: 'Loan Deduction',
      classification: PayrollElementClassifications.deduction,
      recurrenceType: PayrollRecurrenceTypes.recurring,
      calculationMethod: PayrollCalculationMethods.fixed,
      displayOrder: 150,
    ),
    _SeedElement(
      code: 'advance_salary_deduction',
      name: 'Advance Salary Deduction',
      classification: PayrollElementClassifications.deduction,
      recurrenceType: PayrollRecurrenceTypes.nonrecurring,
      calculationMethod: PayrollCalculationMethods.fixed,
      displayOrder: 160,
    ),
    _SeedElement(
      code: 'worked_days',
      name: 'Worked Days',
      classification: PayrollElementClassifications.information,
      recurrenceType: PayrollRecurrenceTypes.nonrecurring,
      calculationMethod: PayrollCalculationMethods.derived,
      isSystemElement: true,
      affectsNetPay: false,
      displayOrder: 210,
    ),
    _SeedElement(
      code: 'late_minutes',
      name: 'Late Minutes',
      classification: PayrollElementClassifications.information,
      recurrenceType: PayrollRecurrenceTypes.nonrecurring,
      calculationMethod: PayrollCalculationMethods.derived,
      isSystemElement: true,
      affectsNetPay: false,
      displayOrder: 220,
    ),
    _SeedElement(
      code: 'violation_count',
      name: 'Violation Count',
      classification: PayrollElementClassifications.information,
      recurrenceType: PayrollRecurrenceTypes.nonrecurring,
      calculationMethod: PayrollCalculationMethods.derived,
      isSystemElement: true,
      affectsNetPay: false,
      displayOrder: 230,
    ),
  ].map((e) => e.toModel()).toList(growable: false);
}

class _SeedElement {
  const _SeedElement({
    required this.code,
    required this.name,
    required this.classification,
    required this.recurrenceType,
    required this.calculationMethod,
    this.isSystemElement = false,
    this.affectsNetPay = true,
    this.displayOrder = 0,
  });

  final String code;
  final String name;
  final String classification;
  final String recurrenceType;
  final String calculationMethod;
  final bool isSystemElement;
  final bool affectsNetPay;
  final int displayOrder;

  PayrollElementModel toModel() {
    return PayrollElementModel(
      id: code,
      code: code,
      name: name,
      classification: classification,
      recurrenceType: recurrenceType,
      calculationMethod: calculationMethod,
      isSystemElement: isSystemElement,
      affectsNetPay: affectsNetPay,
      displayOrder: displayOrder,
    );
  }
}
