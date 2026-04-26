import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_routes.dart' show AppRoutes;
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../providers/repository_providers.dart';
import '../../../employee_today/presentation/widgets/employee_today_bottom_nav.dart';
import '../../application/employee_dashboard_providers.dart';
import '../../data/models/attendance_day_model.dart';

class EmployeeAttendanceScreen extends ConsumerWidget {
  const EmployeeAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final path = GoRouterState.of(context).uri.path;
    final scope = ref.watch(employeeWorkspaceScopeProvider);
    if (scope == null) {
      return Scaffold(
        body: Center(child: Text(l10n.employeePayrollNoWorkspace)),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFCFAFF),
      appBar: AppBar(
        title: Text(l10n.employeeHistoryTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => context.push(AppRoutes.employeeAttendanceRequest),
            child: Text(l10n.employeeHistoryRequestCta),
          ),
        ],
      ),
      body: FutureBuilder<List<AttendanceDayModel>>(
        future: ref
            .read(employeeAttendanceRepositoryProvider)
            .listRecentDays(
              salonId: scope.salonId,
              employeeId: scope.employeeId,
            ),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final rows = snap.data!;
          if (rows.isEmpty) {
            return Center(
              child: Text(
                l10n.employeeHistoryEmpty,
                style: TextStyle(color: ZuranoPremiumUiColors.textSecondary),
              ),
            );
          }
          final df = DateFormat.MMMd();
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: rows.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final r = rows[i];
              return Card(
                child: ListTile(
                  title: Text(df.format(r.workDate.toLocal())),
                  subtitle: Text(
                    '${r.status} · ${r.currentState} · worked ${r.totalWorkedMinutes} min',
                  ),
                  trailing: r.punchInAt != null
                      ? Text(DateFormat.jm().format(r.punchInAt!.toLocal()))
                      : null,
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: EmployeeTodayBottomNav(currentPath: path),
    );
  }
}
