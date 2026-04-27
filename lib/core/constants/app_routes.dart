import 'pre_auth_portal.dart';
import 'user_roles.dart';

class AppRoutes {
  static const splash = '/splash';

  /// Legacy entry; redirects to [splash].
  static const legacyRoot = '/';

  /// Legacy URL; redirects to the first incomplete pre-auth step.
  static const onboarding = '/onboarding';

  static const onboardingLanguage = '/preauth/language';
  static const onboardingCountry = '/preauth/country';

  /// Legacy URL; redirects to [customerOnboarding].
  static const preAuthCustomerOnboarding = '/preauth/customer-onboarding';

  /// First startup step: general user vs salon owner (UI only).
  static const roleSelection = '/role-selection';

  /// Legacy path; redirects to [roleSelection].
  static const legacyRoleSelection = '/preauth/role';

  /// Second step for general users: customer vs staff (UI only).
  static const userSelection = '/user-selection';

  static const customerOnboarding = '/customer/onboarding';
  static const customerProfileSetup = '/customer/profile-setup';

  static const staffLogin = '/staff/login';

  /// Mandatory rotation of salon-provisioned temporary passwords (staff roles).
  static const changeTemporaryPassword = '/change-temporary-password';

  static const settings = '/settings';

  /// Salon owner / admin: violations queue + penalty settings.
  static const ownerHrSettings = '/owner-hr-settings';
  static const login = '/login';

  /// Salon owner email + password (after pre-auth role = owner).
  static const ownerLogin = '/owner/login';

  /// Legacy owner login URL.
  static const legacyOwnerLogin = '/owner-login';

  /// Customer email login (legacy); redirects to [customerAuth].
  static const customerLogin = '/customer/login';

  /// Single customer portal: sign in + link to signup.
  static const customerAuth = '/customer/auth';

  /// Legacy customer/staff login URL.
  static const legacyUserLogin = '/user-login';

  /// Owner signup entry (redirects to [signup] with salon-owner query).
  static const ownerSignup = '/owner/signup';

  static const register = '/register';

  /// Email/password + OAuth signup (replaces multi-step register for MVP).
  static const signup = '/signup';

  static const forgotPassword = '/forgot-password';

  /// Full customer registration with address + structured phone.
  static const customerSignup = '/onboarding/customer-signup';

  /// Salon owner step 1 (account) before [createSalon].
  static const salonOwnerSignup = '/onboarding/salon-owner-signup';

  /// Query value for [register] — new accounts that book as customers (default).
  static const registerFlowCustomer = 'customer';

  /// Query value for [register] — new salon owners; after signup, app opens [createSalon].
  static const registerFlowSalonOwner = 'salon_owner';

  static const registerFlowQueryKey = 'flow';

  static String get registerAsCustomer =>
      '$register?$registerFlowQueryKey=$registerFlowCustomer';

  static String get registerAsSalonOwner =>
      '$register?$registerFlowQueryKey=$registerFlowSalonOwner';

  /// `/register` without a flow (or `flow=customer`) is treated as customer signup.
  static bool registerUriIsSalonOwner(Uri uri) =>
      uri.queryParameters[registerFlowQueryKey] == registerFlowSalonOwner;

  /// Home route after mandatory temporary password rotation (staff roles).
  static String staffPostPasswordChangeHome(String role) {
    final r = role.trim();
    if (r == UserRoles.admin) {
      return adminDashboard;
    }
    return employeeToday;
  }

  static const createSalon = '/create-salon';

  /// New user role selection after social login.
  static const firstTimeRoleSelection = '/first-time-role-selection';

  /// Neutral recovery when Auth exists but `users/{uid}` is missing or staff
  /// linkage is incomplete.
  static const accountProfileBootstrap = '/account-profile-bootstrap';

  /// Deep-link / bookmark compatibility only; router redirects to [accountProfileBootstrap].
  static const legacyAccountProfileBootstrapPath = '/owner-firestore-bootstrap';

  static const customerHome = '/customer/home';

  /// Guest-friendly salon browse (no auth). Doc mirror: `publicSalons/{salonId}`.
  static const customerSalonDiscovery = '/customer/salons';

  static String customerPublicSalonProfile(String salonId) =>
      '$customerSalonDiscovery/$salonId';

  /// Paths for public salon discovery and profile (no login).
  static bool isPublicCustomerSalonBrowsePath(String location) {
    if (location == customerSalonDiscovery) {
      return true;
    }
    if (!location.startsWith('$customerSalonDiscovery/')) {
      return false;
    }
    final rest = location.substring(customerSalonDiscovery.length + 1);
    return rest.isNotEmpty && !rest.contains('/');
  }

  /// Guest booking flow (service selection, …) under `/customer/book/...`.
  static const customerBook = '/customer/book';

  static String customerBookServicesPath(String salonId) =>
      '$customerBook/$salonId/services';

  static String customerBookTeamPath(String salonId) =>
      '$customerBook/$salonId/team';

  static String customerBookTimePath(String salonId) =>
      '$customerBook/$salonId/time';

  static String customerBookDetailsPath(String salonId) =>
      '$customerBook/$salonId/details';

  static String customerBookReviewPath(String salonId) =>
      '$customerBook/$salonId/review';

  static String customerBookSuccessPath(String salonId, String bookingId) =>
      '$customerBook/$salonId/success/$bookingId';

  static const customerBooking = '/customer/booking';

  /// Guest booking lookup (phone + optional booking code, no login).
  static const customerMyBooking = '/customer/my-booking';

  static String customerBookingDetailsPath(String salonId, String bookingId) =>
      '$customerBooking/$salonId/$bookingId';

  static String customerBookingReschedulePath(
    String salonId,
    String bookingId,
  ) => '$customerBooking/$salonId/$bookingId/reschedule';

  static String customerBookingFeedbackPath(String salonId, String bookingId) =>
      '$customerBooking/$salonId/$bookingId/feedback';

  static bool isPublicCustomerBookPath(String location) {
    if (!location.startsWith('$customerBook/')) {
      return false;
    }
    final rest = location.substring(customerBook.length + 1);
    final parts = rest.split('/');
    return parts.length >= 2 &&
        (parts[1] == 'services' ||
            parts[1] == 'team' ||
            parts[1] == 'time' ||
            parts[1] == 'details' ||
            parts[1] == 'review' ||
            parts[1] == 'success');
  }

  static bool isPublicCustomerBookingDetailsPath(String location) {
    if (!location.startsWith('$customerBooking/')) {
      return false;
    }
    final rest = location.substring(customerBooking.length + 1);
    final parts = rest.split('/');
    if (parts.length < 2 || parts.length > 3) {
      return false;
    }
    if (!parts[0].trim().isNotEmpty || !parts[1].trim().isNotEmpty) {
      return false;
    }
    if (parts.length == 3) {
      return parts[2] == 'reschedule' || parts[2] == 'feedback';
    }
    return true;
  }

  static bool isPublicCustomerExperiencePath(String location) {
    return location == customerMyBooking ||
        isPublicCustomerSalonBrowsePath(location) ||
        isPublicCustomerBookPath(location) ||
        isPublicCustomerBookingDetailsPath(location);
  }

  /// Legacy customer home (nested paths preserved via redirect).
  static const legacyCustomerHome = '/customer-home';
  static const ownerDashboard = '/owner';
  static const ownerOverview = '/owner/overview';
  static const ownerBentoDashboard = '/owner/bento';
  static const ownerServices = '/owner/services';
  static const ownerTeam = '/owner/team';

  /// Opens [AddBarberSheet] via [AddTeamMemberGatewayScreen] (root stack).
  static const ownerAddTeamMember = '/owner/add-team-member';

  /// Full-screen team module pushed from the hub (root stack); avoids shell key clashes.
  static const ownerTeamStack = '/owner/team-stack';
  static const ownerCustomers = '/owner/customers';

  static String ownerCustomerDetails(String customerId) =>
      '$ownerCustomers/$customerId';

  static String ownerCustomerEdit(String customerId) =>
      '$ownerCustomers/$customerId/edit';
  static const ownerMoney = '/owner/money';
  static const ownerSettings = '/owner/settings';

  /// HR & violations (nested under owner settings shell — keeps bottom navigation).
  static const ownerSettingsHrViolations = '/owner/settings/hr-violations';
  static const ownerDashboardAssistant = '/owner/assistant';
  static const customers = '/customers';
  static const customerNew = '/customers/new';
  static const bookingsNew = '/bookings/new';

  /// Legacy flat URL — router redirects to [ownerSalesAdd].
  static const ownerAddSale = '/owner-add-sale';

  /// Sales dashboard (POS / revenue list).
  static const ownerSales = '/owner-sales';

  /// Canonical Add Sale screen path (nested URL under sales).
  static const ownerSalesAdd = '$ownerSales/add';

  /// Readable aliases for navigation (same paths as owner workspace URLs).
  static const sales = ownerSales;
  static const addSale = ownerSalesAdd;

  static const ownerSaleDetailsBase = '/owner-sales';
  static const ownerExpenses = '/owner-expenses';
  static const ownerExpensesAdd = '/owner-expenses/add';
  static const ownerPayroll = '/owner-payroll';
  static const ownerPayrollElements = '/owner-payroll/elements';
  static const ownerQuickPay = '/owner-payroll/quick-pay';
  static const ownerPayrollRunReview = '/owner-payroll/run-review';
  static const ownerEmployeePayrollSetupBase = '/owner-payroll/setup';
  static const payrollPayslipBase = '/payroll-payslip';

  /// Query: `employeeId`, `serviceId` (maps to Add Sale screen initial selection).
  static String addSalePrefill({
    String? employeeId,
    String? serviceId,
    String? customerId,
  }) {
    final params = <String, String>{};
    if (employeeId != null && employeeId.trim().isNotEmpty) {
      params['employeeId'] = employeeId.trim();
    }
    if (serviceId != null && serviceId.trim().isNotEmpty) {
      params['serviceId'] = serviceId.trim();
    }
    if (customerId != null && customerId.trim().isNotEmpty) {
      params['customerId'] = customerId.trim();
    }
    if (params.isEmpty) return ownerSalesAdd;
    return Uri(path: ownerSalesAdd, queryParameters: params).toString();
  }

  /// Prefer [addSalePrefill]. Kept so older call sites keep working.
  static String ownerAddSalePrefill({String? employeeId, String? serviceId}) =>
      addSalePrefill(employeeId: employeeId, serviceId: serviceId);

  static const ownerTeamMemberDetailsBase = '/owner-team';

  static String ownerEmployeePayrollSetup(String employeeId) =>
      '$ownerEmployeePayrollSetupBase/$employeeId';

  static String payrollPayslip(String runId, String employeeId) =>
      '$payrollPayslipBase/$runId/$employeeId';

  static String ownerTeamMemberDetails(String employeeId) =>
      '$ownerTeamMemberDetailsBase/$employeeId';

  static String ownerSaleDetails(String saleId) =>
      '$ownerSaleDetailsBase/$saleId';

  static String customerDetails(String customerId) => '$customers/$customerId';

  static String bookingDetails(String bookingId) => '/bookings/$bookingId';

  /// Review pending attendance requests (owner / admin).
  static const attendanceRequestsReview = '/attendance-requests-review';

  /// Approve GPS / correction requests (`attendanceRequests` collection).
  static const attendanceRequestsAdmin = '/owner/attendance-requests-admin';

  /// Staff / barber home (redirects to [employeeToday]).
  static const staffHome = '/staff/home';

  /// Legacy team home path; router redirects to [employeeToday].
  static const employeeDashboard = '/employee';
  static const employeeSales = '/employee/sales';
  static const employeeAttendance = '/employee/attendance';
  static const employeeAttendanceCalendar = '/employee/attendance/calendar';
  static const employeeAttendanceCorrectionNested =
      '/employee/attendance/correction';
  static const employeeAttendanceRequest = '/employee/attendance/request';
  static const employeeToday = '/employee/today';

  /// Legacy path; redirects to [employeeAttendanceCorrectionNested].
  static const employeeAttendanceCorrection = '/employee/attendance-correction';
  static const employeeAttendancePolicy = '/employee/attendance-policy';
  static const employeePayroll = '/employee/payroll';
  static const employeePayrollHistory = '/employee/payroll/history';
  static const ownerAttendanceSettings = '/owner/settings/attendance';

  /// Owner / admin: customer discovery + online booking rules (`publicSalons` + salon).
  static const ownerSettingsCustomerBooking = '$ownerSettings/customer-booking';

  /// Owner / admin: GPS attendance zone under salon settings.
  static const salonAttendanceZoneSettings = '/settings/attendance-zone';

  /// Temporary: verify Google Maps + keys (`GoogleMapsTestScreen`).
  static const debugMaps = '/debug/maps';

  /// Legacy staff dashboard path.
  static const legacyBarberDashboard = '/barber-dashboard';

  static const adminDashboard = '/admin-dashboard';

  static bool isOnboardingPath(String location) =>
      location == onboarding ||
      location == roleSelection ||
      location == legacyRoleSelection ||
      location == userSelection ||
      location == onboardingLanguage ||
      location == onboardingCountry ||
      location == customerOnboarding ||
      location == preAuthCustomerOnboarding;

  /// Routes allowed without Firebase session (onboarding + auth + settings).
  static bool isPreAuthShellPath(String location) =>
      isOnboardingPath(location) ||
      location == login ||
      location == ownerLogin ||
      location == legacyOwnerLogin ||
      location == customerAuth ||
      location == customerLogin ||
      location == customerProfileSetup ||
      location == legacyUserLogin ||
      location == staffLogin ||
      location == ownerSignup ||
      location == signup ||
      location == forgotPassword ||
      location == register ||
      location == customerSignup ||
      location == salonOwnerSignup ||
      location == settings;

  /// After language/country + pre-auth portal, which login screen to open.
  static String loginRouteForIntent(String? selectedAuthRole) {
    final r = selectedAuthRole?.trim();
    if (r == UserRoles.owner) {
      return ownerLogin;
    }
    if (r == PreAuthPortal.staff) {
      return staffLogin;
    }
    return customerAuth;
  }

  /// In-app notification center (all signed-in roles).
  static const notifications = '/notifications';

  /// Notification preference toggles.
  static const notificationPreferences = '/notification-preferences';

  /// Nested under [customerHome].
  static String customerSalon(String salonId) => '$customerHome/salon/$salonId';

  static String customerSalonBook(String salonId) =>
      '$customerHome/salon/$salonId/book';

  static String customerBookingConfirm(String salonId, String bookingId) =>
      '$customerHome/booking/$salonId/$bookingId';

  /// Nested under [customerHome].
  static String get customerMyBookings => '$customerHome/my-bookings';

  /// Employee attendance hub and nested day/calendar/correction routes.
  static bool isEmployeeAttendancePath(String location) =>
      location == employeeAttendance ||
      location.startsWith('$employeeAttendance/');

  /// Employee payslip hub, history, and `/employee/payroll/{payslipId}` details.
  static bool isEmployeePayrollPath(String location) =>
      location == employeePayroll ||
      location == employeePayrollHistory ||
      (location.startsWith('$employeePayroll/') &&
          !location.startsWith('$employeePayroll/history'));

  static bool isUnderCustomerHome(String location) =>
      location == customerHome ||
      location.startsWith('$customerHome/') ||
      location == legacyCustomerHome ||
      location.startsWith('$legacyCustomerHome/');

  /// Owner business workspace (not public [ownerLogin] / [ownerSignup]).
  static bool isOwnerWorkspacePath(String location) {
    if (location == createSalon) {
      return true;
    }
    if (location == ownerLogin ||
        location == legacyOwnerLogin ||
        location == ownerSignup) {
      return false;
    }
    if (location == ownerDashboard ||
        (location.startsWith('$ownerDashboard/') &&
            location != ownerLogin &&
            location != ownerSignup)) {
      return true;
    }
    const ownerFlatPrefixes = <String>[
      ownerHrSettings,
      ownerAttendanceSettings,
      ownerAddSale,
      ownerSales,
      ownerExpenses,
      ownerExpensesAdd,
      ownerPayroll,
      ownerEmployeePayrollSetupBase,
      payrollPayslipBase,
      ownerTeamMemberDetailsBase,
      attendanceRequestsReview,
      attendanceRequestsAdmin,
      customers,
      customerNew,
      bookingsNew,
      '/owner-', // owner-* legacy slugs
    ];
    for (final p in ownerFlatPrefixes) {
      if (location == p || location.startsWith('$p/')) {
        return true;
      }
    }
    return false;
  }
}

/// go_router [GoRoute.name] values for owner hub shortcuts (use with [GoRouter.pushNamed]).
///
/// Import from this library (`app_routes.dart`). Do not import `app_router.dart`
/// from screens registered on that router (e.g. the Bento hub), or a library
/// cycle can occur.
abstract final class AppRouteNames {
  static const changeTemporaryPassword = 'changeTemporaryPassword';
  static const attendanceZoneSettings = 'attendanceZoneSettings';
  static const debugMaps = 'debugMaps';
  static const customerSalonDiscovery = 'customerSalonDiscovery';
  static const customerSalonProfile = 'customerSalonProfile';
  static const customerServiceSelection = 'customerServiceSelection';
  static const customerTeamSelection = 'customerTeamSelection';
  static const customerDateTimeSelection = 'customerDateTimeSelection';
  static const customerDetails = 'customerDetails';
  static const customerBookingReview = 'customerBookingReview';
  static const customerBookingSuccess = 'customerBookingSuccess';
  static const customerBookingDetails = 'customerBookingDetails';
  static const customerBookingReschedule = 'customerBookingReschedule';
  static const customerBookingFeedback = 'customerBookingFeedback';
  static const customerMyBooking = 'customerMyBooking';

  static const services = 'services';
  static const revenue = 'revenue';
  static const addSale = 'addSale';
  static const team = 'team';
  static const addTeamMember = 'addTeamMember';
  static const bookings = 'bookings';
  static const expenses = 'expenses';
  static const addExpense = 'addExpense';

  /// Unified owner attendance settings (zone + rules + violations).
  static const ownerAttendanceSettings = 'ownerAttendanceSettings';
}

/// Paths for each [AppRouteNames] entry (matches existing workspace URLs).
abstract final class AppRoutePaths {
  static const services = AppRoutes.ownerServices;
  static const revenue = AppRoutes.ownerSales;
  static const addSale = AppRoutes.ownerSalesAdd;
  static const team = AppRoutes.ownerTeamStack;
  static const addTeamMember = AppRoutes.ownerAddTeamMember;
  static const bookings = AppRoutes.bookingsNew;
  static const expenses = AppRoutes.ownerExpenses;
}
