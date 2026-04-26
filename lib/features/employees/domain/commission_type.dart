/// String constants for `Employee.commissionType` and Firestore `commissionType`.
abstract final class EmployeeCommissionTypes {
  static const percentage = 'percentage';
  static const fixed = 'fixed';
  static const percentagePlusFixed = 'percentagePlusFixed';
}

/// How barber commission is calculated. Stored in Firestore as [firestoreValue].
enum CommissionType {
  percentage,
  fixed,
  percentagePlusFixed;

  static CommissionType fromFirestore(String? value) {
    switch (value?.trim()) {
      case EmployeeCommissionTypes.fixed:
        return CommissionType.fixed;
      case EmployeeCommissionTypes.percentagePlusFixed:
        return CommissionType.percentagePlusFixed;
      case EmployeeCommissionTypes.percentage:
      default:
        return CommissionType.percentage;
    }
  }

  String get firestoreValue => switch (this) {
    CommissionType.percentage => EmployeeCommissionTypes.percentage,
    CommissionType.fixed => EmployeeCommissionTypes.fixed,
    CommissionType.percentagePlusFixed =>
      EmployeeCommissionTypes.percentagePlusFixed,
  };
}
