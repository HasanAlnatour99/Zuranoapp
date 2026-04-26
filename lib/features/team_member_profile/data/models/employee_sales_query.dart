class EmployeeSalesQuery {
  const EmployeeSalesQuery({
    required this.salonId,
    required this.employeeId,
    required this.employeeName,
  });

  final String salonId;
  final String employeeId;
  final String employeeName;

  @override
  bool operator ==(Object other) {
    return other is EmployeeSalesQuery &&
        other.salonId == salonId &&
        other.employeeId == employeeId &&
        other.employeeName == employeeName;
  }

  @override
  int get hashCode => Object.hash(salonId, employeeId, employeeName);
}
