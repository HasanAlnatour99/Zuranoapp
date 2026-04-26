import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../providers/salon_streams_provider.dart';
import '../../../employee_dashboard/application/employee_dashboard_providers.dart';
import '../../providers/payroll_providers.dart';
import '../services/payslip_pdf_exporter.dart';
import '../widgets/current_payslip_card.dart';
import '../widgets/employee_salary_notes_card.dart';
import '../widgets/payroll_error_state.dart';

class PayslipDetailsScreen extends ConsumerWidget {
  const PayslipDetailsScreen({super.key, required this.payslipId});

  final String payslipId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final scope = ref.watch(employeeWorkspaceScopeProvider);
    final salon = ref.watch(sessionSalonStreamProvider).asData?.value;
    final async = ref.watch(employeePayslipDetailProvider(payslipId));
    final notesAsync = ref.watch(employeeSalaryNotesProvider(payslipId));

    if (scope == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.employeePayrollDetailsTitle)),
        body: Center(child: Text(l10n.employeePayrollNoWorkspace)),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: Text(l10n.employeePayrollDetailsTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: async.when(
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
        error: (e, _) => PayrollErrorState(message: e.toString()),
        data: (payslip) {
          if (payslip == null) {
            return Center(child: Text(l10n.employeePayrollEmptyTitle));
          }
          return ListView(
            padding: const EdgeInsets.only(bottom: 32),
            children: [
              CurrentPayslipCard(payslip: payslip, locale: locale),
              notesAsync.when(
                data: (s) => s == null
                    ? const SizedBox.shrink()
                    : EmployeeSalaryNotesCard(summary: s),
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: FilledButton.icon(
                  onPressed: () async {
                    await sharePayslipPdf(
                      payslip: payslip,
                      salonDisplayName: defaultSalonNameForPdf(salon),
                      subject: l10n.employeePayrollPdfShareSubject,
                    );
                  },
                  icon: const Icon(Icons.download_outlined),
                  label: Text(l10n.employeePayrollDownloadPdf),
                  style: FilledButton.styleFrom(
                    backgroundColor: ZuranoPremiumUiColors.primaryPurple,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
