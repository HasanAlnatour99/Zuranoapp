import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../employee_today_theme.dart';
import 'employee_today_widgets.dart';

class AttendanceRequestCard extends StatelessWidget {
  const AttendanceRequestCard({
    super.key,
    required this.pendingCount,
    required this.onSubmitCorrection,
    this.loading = false,
  });

  final int pendingCount;
  final VoidCallback onSubmitCorrection;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return EtPremiumCard(
      padding: const EdgeInsetsDirectional.fromSTEB(18, 18, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.edit_note_outlined, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.employeeTodayAttendanceRequestTitle,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: EmployeeTodayColors.deepText,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.employeeTodayAttendanceRequestSubtitle,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: EmployeeTodayColors.mutedText,
                        fontSize: 13,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            l10n.employeeTodayPendingCount(pendingCount),
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: EmployeeTodayColors.mutedText,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: loading ? null : onSubmitCorrection,
              style: OutlinedButton.styleFrom(
                foregroundColor: EmployeeTodayColors.primaryPurple,
                side: const BorderSide(
                  color: EmployeeTodayColors.primaryPurple,
                  width: 1.4,
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: loading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      l10n.employeeTodaySubmitCorrection,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
