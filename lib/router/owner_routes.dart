import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_routes.dart';
import '../l10n/app_localizations.dart';
import '../core/motion/app_page_transitions.dart';
import '../features/attendance_admin/presentation/screens/attendance_requests_admin_screen.dart';
import '../features/owner/presentation/screens/attendance_requests_review_screen.dart';
import '../features/owner/presentation/screens/barber_details_screen.dart';
import '../features/customers/presentation/screens/add_customer_screen.dart';
import '../features/customers/presentation/screens/create_booking_screen.dart';
import '../features/customers/presentation/screens/customer_details_screen.dart';
import '../features/customers/presentation/screens/customers_screen.dart';
import '../features/customers/presentation/screens/edit_customer_screen.dart';
import '../features/expenses/presentation/screens/add_expense_screen.dart';
import '../features/expenses/presentation/screens/expenses_screen.dart';
import '../features/bento/presentation/screens/bento_dashboard_screen.dart';
import '../features/owner/presentation/screens/add_team_member_gateway_screen.dart';
import '../features/owner/presentation/screens/owner_dashboard_screen.dart';
import '../features/owner/presentation/widgets/owner_overview_section.dart';
import '../features/owner/presentation/widgets/overview/owner_dashboard_hero_header.dart';
import '../features/owner/presentation/widgets/team_operations_module.dart';
import '../features/payroll/presentation/screens/employee_payroll_setup_screen.dart';
import '../features/payroll/presentation/screens/payroll_dashboard_screen.dart';
import '../features/payroll/presentation/screens/payroll_elements_screen.dart';
import '../features/payroll/presentation/screens/payroll_run_review_screen.dart';
import '../features/payroll/presentation/screens/payslip_screen.dart';
import '../features/payroll/presentation/screens/quick_pay_screen.dart';
import '../features/sales/domain/add_sale_entry_mode.dart';
import '../features/sales/presentation/screens/add_sale_screen.dart';
import '../features/sales/presentation/screens/sale_details_screen.dart';
import '../features/sales/presentation/screens/sales_screen.dart';
import '../features/services/presentation/screens/services_screen.dart';
import '../features/owner/settings/customer_booking/presentation/screens/owner_customer_booking_settings_screen.dart';
import '../features/owner/settings/attendance/presentation/screens/owner_attendance_settings_screen.dart';
import '../features/settings/presentation/screens/app_settings_screen.dart';
import '../features/smart_workspace/presentation/screens/smart_workspace_page.dart';
import '../core/theme/app_colors.dart';
import '../features/money/presentation/widgets/money_dashboard_module.dart';
import '../core/session/app_session_status.dart';
import '../core/widgets/app_skeleton.dart';
import '../providers/session_provider.dart';
import 'router_navigation_keys.dart';

Page<Object?> _ownerTeamOperationsPage(
  BuildContext context,
  GoRouterState state,
) {
  return appFadeThroughPage(
    key: state.pageKey,
    child: Consumer(
      builder: (context, ref, _) {
        final session = ref.watch(sessionUserProvider);
        final user = session.asData?.value;
        if (user == null) {
          return const DashboardSkeleton();
        }
        final salonId = user.salonId?.trim() ?? '';
        return OwnerDashboardHeroTabScaffold(
          user: user,
          enableBodyOverlap: false,
          compactHero: true,
          bodyScaffoldBackgroundColor: const Color(0xFFF6F2FB),
          body: TeamOperationsModule(salonId: salonId),
        );
      },
    ),
  );
}

Widget _ownerOverviewTabError(BuildContext context, Object error) {
  final scheme = Theme.of(context).colorScheme;
  return Scaffold(
    backgroundColor: scheme.surface,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'Could not load session.\n$error',
          textAlign: TextAlign.center,
          style: TextStyle(color: scheme.onSurface),
        ),
      ),
    ),
  );
}

Widget _ownerOverviewTabResolvingUser(BuildContext context) {
  return Scaffold(
    backgroundColor: Theme.of(context).colorScheme.surface,
    body: const DashboardSkeleton(),
  );
}

final List<RouteBase> ownerRoutes = [
  StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) {
      return OwnerDashboardScreen(navigationShell: navigationShell);
    },
    branches: [
      StatefulShellBranch(
        navigatorKey: ownerShellBranchMoneyNavigatorKey,
        routes: [
          GoRoute(
            path: AppRoutes.ownerMoney,
            pageBuilder: (context, state) => appFadeThroughPage(
              key: state.pageKey,
              child: Consumer(
                builder: (context, ref, _) {
                  final session = ref.watch(sessionUserProvider);
                  final user = session.asData?.value;
                  if (user == null) {
                    return const DashboardSkeleton();
                  }
                  return OwnerDashboardHeroTabScaffold(
                    user: user,
                    enableBodyOverlap: false,
                    bodyScaffoldBackgroundColor:
                        FinanceDashboardColors.background,
                    body: const MoneyDashboardModule(
                      ownerShellHeroEmbedded: true,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      StatefulShellBranch(
        navigatorKey: ownerShellBranchCustomersNavigatorKey,
        routes: [
          GoRoute(
            path: AppRoutes.ownerCustomers,
            pageBuilder: (context, state) => appFadeThroughPage(
              key: state.pageKey,
              child: Consumer(
                builder: (context, ref, _) {
                  final session = ref.watch(sessionUserProvider);
                  final user = session.asData?.value;
                  if (user == null) {
                    return const DashboardSkeleton();
                  }
                  return OwnerDashboardHeroTabScaffold(
                    user: user,
                    enableBodyOverlap: false,
                    body: const CustomersScreen(ownerShellHeroEmbedded: true),
                  );
                },
              ),
            ),
            routes: [
              GoRoute(
                path: ':customerId',
                parentNavigatorKey: appRootNavigatorKey,
                pageBuilder: (context, state) => appFadeThroughPage(
                  key: state.pageKey,
                  child: CustomerDetailsScreen(
                    customerId: state.pathParameters['customerId'] ?? '',
                  ),
                ),
                routes: [
                  GoRoute(
                    path: 'edit',
                    parentNavigatorKey: appRootNavigatorKey,
                    pageBuilder: (context, state) => appFadeThroughPage(
                      key: state.pageKey,
                      child: EditCustomerScreen(
                        customerId: state.pathParameters['customerId'] ?? '',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      StatefulShellBranch(
        navigatorKey: ownerShellBranchTeamNavigatorKey,
        routes: [
          GoRoute(
            path: AppRoutes.ownerTeam,
            pageBuilder: _ownerTeamOperationsPage,
          ),
        ],
      ),
      StatefulShellBranch(
        navigatorKey: ownerShellBranchOverviewNavigatorKey,
        routes: [
          GoRoute(
            path: AppRoutes.ownerOverview,
            pageBuilder: (context, state) => appFadeThroughPage(
              key: state.pageKey,
              child: Consumer(
                builder: (context, ref, _) {
                  // Must match [OwnerDashboardScreen]: the stream can briefly yield
                  // `null` while [appSessionBootstrapProvider] already holds a valid
                  // `AppUser`, which previously trapped this tab on "Syncing your profile…".
                  final sessionState = ref.watch(appSessionBootstrapProvider);
                  final sessionAsync = ref.watch(sessionUserProvider);
                  final resolvedUser =
                      sessionAsync.asData?.value ?? sessionState.user;

                  if (sessionState.status == AppSessionStatus.unauthenticated) {
                    return const SizedBox.shrink();
                  }

                  if (sessionState.status == AppSessionStatus.initializing &&
                      resolvedUser == null &&
                      sessionAsync.isLoading) {
                    return _ownerOverviewTabResolvingUser(context);
                  }

                  if (sessionAsync.hasError && resolvedUser == null) {
                    return _ownerOverviewTabError(context, sessionAsync.error!);
                  }

                  final user = resolvedUser;
                  if (user == null) {
                    return _ownerOverviewTabResolvingUser(context);
                  }
                  final salonId = user.salonId?.trim() ?? '';
                  if (sessionState.status == AppSessionStatus.ready &&
                      salonId.isEmpty) {
                    return _ownerOverviewTabResolvingUser(context);
                  }

                  return OwnerOverviewSection(user: user);
                },
              ),
            ),
          ),
        ],
      ),
    ],
  ),
  GoRoute(
    path: AppRoutes.ownerSettings,
    parentNavigatorKey: appRootNavigatorKey,
    pageBuilder: (context, state) => appFadeThroughPage(
      key: state.pageKey,
      child: const AppSettingsScreen(),
    ),
    routes: [
      GoRoute(
        path: 'hr-violations',
        redirect: (_, _) =>
            '${AppRoutes.ownerAttendanceSettings}?section=violations',
      ),
      GoRoute(
        path: 'attendance',
        name: AppRouteNames.ownerAttendanceSettings,
        pageBuilder: (context, state) => appFadeThroughPage(
          key: state.pageKey,
          child: const OwnerAttendanceSettingsScreen(),
        ),
      ),
      GoRoute(
        path: 'customer-booking',
        pageBuilder: (context, state) => appFadeThroughPage(
          key: state.pageKey,
          child: const OwnerCustomerBookingSettingsScreen(),
        ),
      ),
    ],
  ),
  GoRoute(
    path: AppRoutes.ownerTeamStack,
    name: AppRouteNames.team,
    parentNavigatorKey: appRootNavigatorKey,
    pageBuilder: _ownerTeamOperationsPage,
  ),
  GoRoute(
    path: AppRoutes.ownerAddTeamMember,
    name: AppRouteNames.addTeamMember,
    parentNavigatorKey: appRootNavigatorKey,
    pageBuilder: (context, state) => appFadeThroughPage(
      key: state.pageKey,
      child: const AddTeamMemberGatewayScreen(),
    ),
  ),
  GoRoute(
    path: AppRoutes.customers,
    pageBuilder: (context, state) =>
        appFadeThroughPage(key: state.pageKey, child: const CustomersScreen()),
  ),
  // Static path must be registered before `/customers/:customerId` so
  // `/customers/new` opens [AddCustomerScreen], not details with id "new".
  GoRoute(
    path: AppRoutes.customerNew,
    pageBuilder: (context, state) => appFadeThroughPage(
      key: state.pageKey,
      child: const AddCustomerScreen(),
    ),
  ),
  GoRoute(
    path: '${AppRoutes.customers}/:customerId',
    pageBuilder: (context, state) => appFadeThroughPage(
      key: state.pageKey,
      child: CustomerDetailsScreen(
        customerId: state.pathParameters['customerId'] ?? '',
      ),
    ),
  ),
  GoRoute(
    path: AppRoutes.bookingsNew,
    name: AppRouteNames.bookings,
    pageBuilder: (context, state) => appFadeThroughPage(
      key: state.pageKey,
      child: CreateBookingScreen(
        initialCustomerId: state.uri.queryParameters['customerId'],
        initialServiceId: state.uri.queryParameters['serviceId'],
        initialBarberId: state.uri.queryParameters['barberId'],
        initialDurationMinutes: int.tryParse(
          state.uri.queryParameters['durationMinutes'] ?? '',
        ),
      ),
    ),
  ),
  GoRoute(
    path: AppRoutes.ownerBentoDashboard,
    pageBuilder: (context, state) => appFadeThroughPage(
      key: state.pageKey,
      child: const BentoDashboardScreen(),
    ),
  ),
  GoRoute(
    path: AppRoutes.ownerServices,
    name: AppRouteNames.services,
    pageBuilder: (context, state) => appFadeThroughPage(
      key: state.pageKey,
      child: Consumer(
        builder: (context, ref, _) {
          final session = ref.watch(sessionUserProvider);
          return session.when(
            data: (user) {
              final salonId = user?.salonId?.trim() ?? '';
              if (salonId.isEmpty) {
                final l10n = AppLocalizations.of(context)!;
                return Scaffold(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  body: Center(child: Text(l10n.ownerServicesWaitingForSalon)),
                );
              }
              return ServicesScreen(salonId: salonId);
            },
            loading: () => Scaffold(
              backgroundColor: Theme.of(context).colorScheme.surface,
              body: const Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => _ownerOverviewTabError(context, e),
          );
        },
      ),
    ),
  ),
  GoRoute(
    path: AppRoutes.ownerDashboardAssistant,
    pageBuilder: (context, state) => appFadeThroughPage(
      key: state.pageKey,
      child: const SmartWorkspacePage(),
    ),
  ),
  GoRoute(
    path: AppRoutes.ownerPayroll,
    pageBuilder: (context, state) => appFadeThroughPage(
      key: state.pageKey,
      child: const PayrollDashboardScreen(),
    ),
  ),
  GoRoute(
    path: AppRoutes.ownerPayrollElements,
    pageBuilder: (context, state) => appFadeThroughPage(
      key: state.pageKey,
      child: const PayrollElementsScreen(),
    ),
  ),
  GoRoute(
    path: AppRoutes.ownerQuickPay,
    pageBuilder: (context, state) =>
        appFadeThroughPage(key: state.pageKey, child: const QuickPayScreen()),
  ),
  GoRoute(
    path: AppRoutes.ownerPayrollRunReview,
    pageBuilder: (context, state) => appFadeThroughPage(
      key: state.pageKey,
      child: const PayrollRunReviewScreen(),
    ),
  ),
  GoRoute(
    path: AppRoutes.ownerAddSale,
    redirect: (context, state) {
      final base = AppRoutes.ownerSalesAdd;
      if (!state.uri.hasQuery) return base;
      return '$base?${state.uri.query}';
    },
  ),
  GoRoute(
    path: AppRoutes.ownerSales,
    name: AppRouteNames.revenue,
    pageBuilder: (context, state) =>
        appFadeThroughPage(key: state.pageKey, child: const SalesScreen()),
  ),
  GoRoute(
    path: AppRoutes.ownerSalesAdd,
    name: AppRouteNames.addSale,
    pageBuilder: (context, state) => appFadeThroughPage(
      key: state.pageKey,
      child: AddSaleScreen(
        entryMode: addSaleEntryModeFromSourceQuery(
          state.uri.queryParameters['source'],
        ),
        initialBarberId: state.uri.queryParameters['employeeId'],
        initialServiceId: state.uri.queryParameters['serviceId'],
        initialCustomerId: state.uri.queryParameters['customerId'],
      ),
    ),
  ),
  GoRoute(
    path: '${AppRoutes.ownerSaleDetailsBase}/:saleId',
    pageBuilder: (context, state) => appSharedAxisPage(
      key: state.pageKey,
      child: SaleDetailsScreen(saleId: state.pathParameters['saleId'] ?? ''),
    ),
  ),
  GoRoute(
    path: AppRoutes.ownerExpenses,
    name: AppRouteNames.expenses,
    pageBuilder: (context, state) =>
        appFadeThroughPage(key: state.pageKey, child: const ExpensesScreen()),
  ),
  GoRoute(
    path: AppRoutes.ownerExpensesAdd,
    name: AppRouteNames.addExpense,
    pageBuilder: (context, state) =>
        appFadeThroughPage(key: state.pageKey, child: const AddExpenseScreen()),
  ),
  GoRoute(
    path: '${AppRoutes.ownerTeamMemberDetailsBase}/:employeeId',
    pageBuilder: (context, state) => appSharedAxisPage(
      key: state.pageKey,
      child: BarberDetailsScreen(
        employeeId: state.pathParameters['employeeId'] ?? '',
      ),
    ),
  ),
  GoRoute(
    path: '${AppRoutes.ownerEmployeePayrollSetupBase}/:employeeId',
    pageBuilder: (context, state) => appSharedAxisPage(
      key: state.pageKey,
      child: EmployeePayrollSetupScreen(
        employeeId: state.pathParameters['employeeId'] ?? '',
      ),
    ),
  ),
  GoRoute(
    path: '${AppRoutes.payrollPayslipBase}/:runId/:employeeId',
    pageBuilder: (context, state) => appSharedAxisPage(
      key: state.pageKey,
      child: PayslipScreen(
        runId: state.pathParameters['runId'] ?? '',
        employeeId: state.pathParameters['employeeId'] ?? '',
      ),
    ),
  ),
  GoRoute(
    path: AppRoutes.attendanceRequestsReview,
    pageBuilder: (context, state) => appFadeThroughPage(
      key: state.pageKey,
      child: const AttendanceRequestsReviewScreen(),
    ),
  ),
  GoRoute(
    path: AppRoutes.attendanceRequestsAdmin,
    pageBuilder: (context, state) => appFadeThroughPage(
      key: state.pageKey,
      child: const AttendanceRequestsAdminScreen(),
    ),
  ),
];
