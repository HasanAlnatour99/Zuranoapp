import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../providers/employee_today_providers.dart';
import '../employee_today_theme.dart';
import '../widgets/attendance_policy_body.dart';

/// Localized attendance rules derived from salon settings (no mixed-language AI body).
class EmployeeAttendancePolicyScreen extends ConsumerWidget {
  const EmployeeAttendancePolicyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settingsAsync = ref.watch(etAttendanceSettingsProvider);

    return Scaffold(
      backgroundColor: EmployeeTodayColors.backgroundSoft,
      appBar: AppBar(
        title: Text(l10n.employeePolicyTitle, textAlign: TextAlign.start),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: settingsAsync.when(
          data: (s) => EmployeeAttendancePolicyBody(settings: s),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('$e')),
        ),
      ),
    );
  }
}

/// Backward-compatible name for routes/tests.
typedef AttendancePolicyScreen = EmployeeAttendancePolicyScreen;
