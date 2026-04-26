import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/user_roles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../providers/salon_streams_provider.dart';
import '../../../../providers/session_provider.dart';
import '../../../../shared/widgets/zurano_add_sale_fab.dart';
import '../../../sales/presentation/providers/employee_sales_providers.dart';
import '../../../sales/presentation/providers/salon_sales_settings_provider.dart';
import '../../../sales/presentation/widgets/employee_commission_card.dart';
import '../../../sales/presentation/widgets/employee_recent_sales_list.dart';
import '../../../sales/presentation/widgets/employee_sales_header.dart';
import '../../../sales/presentation/widgets/employee_sales_hero_card.dart';
import '../../../sales/presentation/widgets/employee_sales_kpi_grid.dart';
import '../../../sales/presentation/widgets/employee_sales_period_selector.dart';
import '../../application/employee_dashboard_providers.dart';
import '../../../employee_today/presentation/widgets/employee_today_bottom_nav.dart';

class EmployeeSalesScreen extends ConsumerWidget {
  const EmployeeSalesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final path = GoRouterState.of(context).uri.path;
    final scope = ref.watch(employeeWorkspaceScopeProvider);
    final session = ref.watch(sessionUserProvider).asData?.value;
    final settings = ref.watch(salonSalesSettingsStreamProvider).asData?.value;
    final employeeAsync = ref.watch(workspaceEmployeeProvider);
    final salesAsync = ref.watch(employeeSalesStreamProvider);
    final summary = ref.watch(employeeSalesSummaryProvider);
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);

    if (scope == null || session == null) {
      return Scaffold(
        body: Center(child: Text(l10n.employeePayrollNoWorkspace)),
      );
    }

    final salon = ref.watch(sessionSalonStreamProvider).asData?.value;
    final currencyCode = salon?.currencyCode ?? 'USD';

    final rate = employeeAsync.maybeWhen(
      data: (e) => e?.effectiveCommissionRate ?? e?.commissionRate ?? 0,
      orElse: () => 0.0,
    );

    final showFab =
        (settings?.allowEmployeeAddSale ?? true) &&
        session.role.trim() != UserRoles.readonly;

    void onAddSale() {
      context.pushNamed(
        AppRouteNames.addSale,
        queryParameters: const {'source': 'employee'},
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF4ECFF), Color(0xFFF8F9FE), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0, 0.35, 1],
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(employeeSalesStreamProvider);
              ref.invalidate(workspaceEmployeeProvider);
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: EmployeeSalesHeader(
                    displayName: scope.displayName,
                    photoUrl: session.photoUrl,
                  ),
                ),
                const SliverToBoxAdapter(child: EmployeeSalesPeriodSelector()),
                SliverToBoxAdapter(
                  child: EmployeeSalesHeroCard(
                    summary: summary,
                    currencyCode: currencyCode,
                    locale: locale,
                  ),
                ),
                SliverToBoxAdapter(
                  child: EmployeeSalesKpiGrid(
                    summary: summary,
                    currencyCode: currencyCode,
                    locale: locale,
                  ),
                ),
                SliverToBoxAdapter(
                  child: EmployeeSalesKpiGridRow2(
                    summary: summary,
                    currencyCode: currencyCode,
                    locale: locale,
                  ),
                ),
                SliverToBoxAdapter(
                  child: EmployeeCommissionCard(
                    commissionPercent: rate,
                    summary: summary,
                    currencyCode: currencyCode,
                    locale: locale,
                  ),
                ),
                SliverToBoxAdapter(
                  child: salesAsync.when(
                    loading: () => const Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (e, _) => Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text('$e'),
                    ),
                    data: (list) => EmployeeRecentSalesList(
                      sales: list,
                      currencyCode: currencyCode,
                      locale: locale,
                      onViewReceiptsTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.employeeSalesViewReceiptsHint),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 120)),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: showFab
          ? Padding(
              padding: const EdgeInsets.only(bottom: 82),
              child: ZuranoAddSaleFab(
                heroTag: 'employee_add_sale_fab_sales',
                onPressed: onAddSale,
              ),
            )
          : null,
      bottomNavigationBar: EmployeeTodayBottomNav(currentPath: path),
    );
  }
}
