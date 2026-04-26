import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/user_roles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../providers/session_provider.dart';
import '../../data/attendance_policy_callable_service.dart';
import '../../providers/employee_today_providers.dart';
import '../employee_today_theme.dart';
import '../widgets/employee_today_widgets.dart';

class AttendancePolicyScreen extends ConsumerWidget {
  const AttendancePolicyScreen({super.key});

  List<String> _fallbackRules(AppLocalizations l10n) {
    return [
      l10n.employeePolicyRulePunchSession,
      l10n.employeePolicyRuleBreakPair,
      l10n.employeePolicyRuleGpsZone,
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final policyAsync = ref.watch(etAttendancePolicyReadableProvider);
    final settingsAsync = ref.watch(etAttendanceSettingsProvider);
    final user = ref.watch(sessionUserProvider).asData?.value;
    final canRegenerate =
        user != null &&
        (user.role == UserRoles.owner || user.role == UserRoles.admin);

    return Scaffold(
      backgroundColor: EmployeeTodayColors.backgroundSoft,
      appBar: AppBar(
        title: Text(l10n.employeePolicyTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            l10n.employeePolicySubtitle,
            style: const TextStyle(color: EmployeeTodayColors.mutedText),
          ),
          const SizedBox(height: 16),
          policyAsync.when(
            data: (p) {
              if (p == null || p.summary.isEmpty) {
                return settingsAsync.when(
                  data: (s) {
                    final rules = _fallbackRules(l10n);
                    return EtPremiumCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.employeePolicySummaryTitle,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.employeePolicyGpsSummary(
                              s.maxPunchesPerDay,
                              s.maxBreaksPerDay,
                            ),
                            style: const TextStyle(
                              color: EmployeeTodayColors.mutedText,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...rules.map(
                            (t) => Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('• '),
                                  Expanded(child: Text(t)),
                                ],
                              ),
                            ),
                          ),
                          if (canRegenerate) ...[
                            const SizedBox(height: 16),
                            FilledButton(
                              onPressed: () async {
                                final sid = user.salonId;
                                if (sid == null || sid.isEmpty) {
                                  return;
                                }
                                try {
                                  await AttendancePolicyCallableService()
                                      .generateAttendancePolicyReadable(sid);
                                  ref.invalidate(
                                    etAttendancePolicyReadableProvider,
                                  );
                                  if (context.mounted) {
                                    final loc = AppLocalizations.of(context)!;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          loc.employeePolicyUpdatedSnackbar,
                                        ),
                                      ),
                                    );
                                  }
                                } on Object catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('$e')),
                                    );
                                  }
                                }
                              },
                              child: Text(l10n.employeePolicyRegenerateCta),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text('$e'),
                );
              }
              return EtPremiumCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.title.isEmpty ? l10n.employeePolicyDefaultTitle : p.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      p.summary,
                      style: const TextStyle(
                        color: EmployeeTodayColors.mutedText,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.employeePolicyPunchRules,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    ...p.employeeRules.map(
                      (t) => ListTile(
                        dense: true,
                        leading: const Icon(
                          Icons.check_circle_outline,
                          size: 20,
                        ),
                        title: Text(t),
                      ),
                    ),
                    Text(
                      l10n.employeePolicyLateEarly,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    ...p.violationRules.map(
                      (t) => ListTile(
                        dense: true,
                        leading: const Icon(Icons.schedule, size: 20),
                        title: Text(t),
                      ),
                    ),
                    Text(
                      l10n.employeePolicyCorrectionSection,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    ...p.correctionRules.map(
                      (t) => ListTile(
                        dense: true,
                        leading: const Icon(Icons.edit_document, size: 20),
                        title: Text(t),
                      ),
                    ),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('$e'),
          ),
        ],
      ),
    );
  }
}
