import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

class BookingSuccessSummaryCard extends StatelessWidget {
  const BookingSuccessSummaryCard({
    super.key,
    required this.bookingCodeLabel,
    required this.statusLabel,
    required this.dateLabel,
    required this.timeLabel,
    required this.salonLabel,
    required this.bookingCode,
    required this.status,
    required this.date,
    required this.time,
    required this.salonName,
    required this.copyMessage,
  });

  final String bookingCodeLabel;
  final String statusLabel;
  final String dateLabel;
  final String timeLabel;
  final String salonLabel;
  final String bookingCode;
  final String status;
  final String date;
  final String time;
  final String salonName;
  final String copyMessage;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(AppRadius.xlarge),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.large),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bookingCodeLabel,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColorsLight.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      SelectableText(
                        bookingCode,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppBrandColors.primary,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton.filledTonal(
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: bookingCode));
                    if (context.mounted) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(copyMessage)));
                    }
                  },
                  icon: const Icon(Icons.copy_rounded),
                ),
              ],
            ),
            const Divider(height: AppSpacing.xlarge),
            _SummaryRow(label: statusLabel, value: status),
            _SummaryRow(label: dateLabel, value: date),
            _SummaryRow(label: timeLabel, value: time),
            if (salonName.trim().isNotEmpty)
              _SummaryRow(label: salonLabel, value: salonName),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.small),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColorsLight.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColorsLight.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
