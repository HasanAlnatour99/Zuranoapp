class FirestorePaths {
  const FirestorePaths._();

  static const users = 'users';
  static const salons = 'salons';

  /// Public salon browse index (customer discovery). Doc id = salonId.
  static const publicSalons = 'publicSalons';

  /// Customer-safe team mirror under each public salon doc (`publicSalons/{salonId}/team/{employeeId}`).
  static const publicSalonTeam = 'team';
  static const employees = 'employees';
  static const services = 'services';
  static const sales = 'sales';
  static const attendance = 'attendance';
  static const attendanceEvents = 'events';
  static const settings = 'settings';
  static const attendanceSettingsDocId = 'attendance';
  static const salesSettingsDocId = 'sales';
  static const customerBookingSettingsDocId = 'customerBooking';
  static const attendanceRequests = 'attendanceRequests';
  static const attendanceCorrections = 'attendance_corrections';

  /// Employee Today v2: day aggregate + punch audit trail.
  static const attendanceDays = 'attendanceDays';
  static const attendanceDayPunches = 'punches';

  /// Pending/approved correction flow (camelCase collection id).
  static const attendanceCorrectionRequests = 'attendanceCorrectionRequests';
  static const attendancePolicyReadableDocId = 'attendancePolicyReadable';
  static const auditLogs = 'audit_logs';
  static const violations = 'violations';
  static const payroll = 'payroll';
  static const payrollElements = 'payroll_elements';
  static const employeeElementEntries = 'employee_element_entries';
  static const payrollRuns = 'payroll_runs';
  static const payrollRunResults = 'results';
  static const expenses = 'expenses';
  static const bookings = 'bookings';
  static const reviews = 'reviews';
  static const barberMetrics = 'barberMetrics';
  static const insights = 'insights';

  /// Owner/admin cached text snippets (e.g. team sales digest). Distinct from [insights].
  static const aiInsights = 'aiInsights';
  static const customers = 'customers';
  static String customer(String customerId) => '$customers/$customerId';

  static String user(String uid) => '$users/$uid';

  static const userDevices = 'devices';
  static const userNotifications = 'notifications';

  static String userDevicesPath(String uid) => '${user(uid)}/$userDevices';

  static String userDevice(String uid, String deviceId) =>
      '${userDevicesPath(uid)}/$deviceId';

  static String userNotificationsPath(String uid) =>
      '${user(uid)}/$userNotifications';

  static String salon(String salonId) => '$salons/$salonId';

  static String publicSalon(String salonId) => '$publicSalons/$salonId';

  static String publicSalonTeamCollection(String salonId) =>
      '${publicSalon(salonId)}/$publicSalonTeam';

  static String publicSalonTeamMember(String salonId, String employeeId) =>
      '${publicSalonTeamCollection(salonId)}/$employeeId';

  /// Customer-safe service mirror (`publicSalons/{salonId}/services/{serviceId}`).
  static String publicSalonServicesCollection(String salonId) =>
      '${publicSalon(salonId)}/$services';

  static String publicSalonService(String salonId, String serviceId) =>
      '${publicSalonServicesCollection(salonId)}/$serviceId';

  static String salonEmployees(String salonId) =>
      '${salon(salonId)}/$employees';

  static String salonEmployee(String salonId, String employeeId) =>
      '${salonEmployees(salonId)}/$employeeId';

  static String salonServices(String salonId) => '${salon(salonId)}/$services';

  static String salonService(String salonId, String serviceId) =>
      '${salonServices(salonId)}/$serviceId';

  static String salonReviews(String salonId) => '${salon(salonId)}/$reviews';

  static String salonReview(String salonId, String reviewId) =>
      '${salonReviews(salonId)}/$reviewId';

  static String salonSales(String salonId) => '${salon(salonId)}/$sales';

  static String salonSale(String salonId, String saleId) =>
      '${salonSales(salonId)}/$saleId';

  static String salonAttendance(String salonId) =>
      '${salon(salonId)}/$attendance';

  static String salonAttendanceRecord(String salonId, String attendanceId) =>
      '${salonAttendance(salonId)}/$attendanceId';

  /// `salons/{salonId}/attendance/{attendanceId}/events` (collection path).
  static String salonAttendanceEventsCollection(
    String salonId,
    String attendanceId,
  ) => '${salonAttendanceRecord(salonId, attendanceId)}/$attendanceEvents';

  static String salonAttendanceEventDoc(
    String salonId,
    String attendanceId,
    String eventId,
  ) => '${salonAttendanceEventsCollection(salonId, attendanceId)}/$eventId';

  static String salonSettingsCollection(String salonId) =>
      '${salon(salonId)}/$settings';

  static String salonAttendanceSettingsDoc(String salonId) =>
      '${salonSettingsCollection(salonId)}/$attendanceSettingsDocId';

  static String salonSalesSettingsDoc(String salonId) =>
      '${salonSettingsCollection(salonId)}/$salesSettingsDocId';

  static String salonCustomerBookingSettingsDoc(String salonId) =>
      '${salonSettingsCollection(salonId)}/$customerBookingSettingsDocId';

  static String salonAttendancePolicyReadableDoc(String salonId) =>
      '${salonSettingsCollection(salonId)}/$attendancePolicyReadableDocId';

  /// `salons/{salonId}/attendanceDays`
  static String salonAttendanceDays(String salonId) =>
      '${salon(salonId)}/$attendanceDays';

  static String salonAttendanceDay(String salonId, String attendanceDayId) =>
      '${salonAttendanceDays(salonId)}/$attendanceDayId';

  static String salonAttendanceDayPunchesCollection(
    String salonId,
    String attendanceDayId,
  ) => '${salonAttendanceDay(salonId, attendanceDayId)}/$attendanceDayPunches';

  static String salonAttendanceDayPunch(
    String salonId,
    String attendanceDayId,
    String punchId,
  ) =>
      '${salonAttendanceDayPunchesCollection(salonId, attendanceDayId)}/$punchId';

  static String salonAttendanceCorrectionRequests(String salonId) =>
      '${salon(salonId)}/$attendanceCorrectionRequests';

  static String salonAttendanceCorrectionRequest(
    String salonId,
    String requestId,
  ) => '${salonAttendanceCorrectionRequests(salonId)}/$requestId';

  static String salonAttendanceRequests(String salonId) =>
      '${salon(salonId)}/$attendanceRequests';

  static String salonAttendanceRequest(String salonId, String requestId) =>
      '${salonAttendanceRequests(salonId)}/$requestId';

  static String salonAttendanceCorrections(String salonId) =>
      '${salon(salonId)}/$attendanceCorrections';

  static String salonAuditLogs(String salonId) =>
      '${salon(salonId)}/$auditLogs';

  static String salonViolations(String salonId) =>
      '${salon(salonId)}/$violations';

  static String salonViolation(String salonId, String violationId) =>
      '${salonViolations(salonId)}/$violationId';

  static String salonPayroll(String salonId) => '${salon(salonId)}/$payroll';

  static String salonPayrollRecord(String salonId, String payrollId) =>
      '${salonPayroll(salonId)}/$payrollId';

  static String salonPayrollElements(String salonId) =>
      '${salon(salonId)}/$payrollElements';

  static String salonPayrollElement(String salonId, String elementId) =>
      '${salonPayrollElements(salonId)}/$elementId';

  static String salonEmployeeElementEntries(String salonId) =>
      '${salon(salonId)}/$employeeElementEntries';

  static String salonEmployeeElementEntry(String salonId, String entryId) =>
      '${salonEmployeeElementEntries(salonId)}/$entryId';

  static String salonPayrollRuns(String salonId) =>
      '${salon(salonId)}/$payrollRuns';

  static String salonPayrollRun(String salonId, String runId) =>
      '${salonPayrollRuns(salonId)}/$runId';

  static String salonPayrollRunResults(String salonId, String runId) =>
      '${salonPayrollRun(salonId, runId)}/$payrollRunResults';

  static String salonPayrollRunResult(
    String salonId,
    String runId,
    String resultId,
  ) => '${salonPayrollRunResults(salonId, runId)}/$resultId';

  static String salonExpenses(String salonId) => '${salon(salonId)}/$expenses';

  static String salonExpense(String salonId, String expenseId) =>
      '${salonExpenses(salonId)}/$expenseId';

  static String salonBookings(String salonId) => '${salon(salonId)}/$bookings';

  static String salonBooking(String salonId, String bookingId) =>
      '${salonBookings(salonId)}/$bookingId';

  static String salonBarberMetrics(String salonId) =>
      '${salon(salonId)}/$barberMetrics';

  static String salonBarberMetric(String salonId, String employeeId) =>
      '${salonBarberMetrics(salonId)}/$employeeId';

  static String salonInsights(String salonId) => '${salon(salonId)}/$insights';

  static String salonAiInsights(String salonId) =>
      '${salon(salonId)}/$aiInsights';

  static String salonCustomers(String salonId) =>
      '${salon(salonId)}/$customers';

  static String salonCustomer(String salonId, String customerId) =>
      '${salonCustomers(salonId)}/$customerId';

  /// Monthly payslips (`{employeeId}_{yyyyMM}`) with `lines` + `aiAnalysis` subcollections.
  static const payslips = 'payslips';
  static const payslipLines = 'lines';
  static const payslipAiAnalysis = 'aiAnalysis';
  static const payrollSettings = 'payroll_settings';
  static const payrollSettingsMainDocId = 'main';
  static const payrollAdjustments = 'payroll_adjustments';
  static const violationRules = 'violation_rules';

  static String salonPayslips(String salonId) => '${salon(salonId)}/$payslips';

  static String salonPayslip(String salonId, String payslipId) =>
      '${salonPayslips(salonId)}/$payslipId';

  static String salonPayslipLines(String salonId, String payslipId) =>
      '${salonPayslip(salonId, payslipId)}/$payslipLines';

  static String salonPayslipAiAnalysis(String salonId, String payslipId) =>
      '${salonPayslip(salonId, payslipId)}/$payslipAiAnalysis';

  static String salonPayrollSettingsDoc(String salonId) =>
      '${salon(salonId)}/$payrollSettings/$payrollSettingsMainDocId';

  static String salonPayrollAdjustments(String salonId) =>
      '${salon(salonId)}/$payrollAdjustments';

  static String salonViolationRules(String salonId) =>
      '${salon(salonId)}/$violationRules';
}
