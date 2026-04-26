import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/payslip_line_model.dart';
import 'payslip_line_tile.dart';

class PayslipBreakdownSection extends StatelessWidget {
  const PayslipBreakdownSection({
    super.key,
    required this.title,
    required this.isEarning,
    required this.lines,
    required this.total,
    required this.currency,
    required this.totalLabel,
  });

  final String title;
  final bool isEarning;
  final List<PayslipLineModel> lines;
  final double total;
  final String currency;
  final String totalLabel;

  @override
  Widget build(BuildContext context) {
    final accent = isEarning
        ? const Color(0xFF059669)
        : const Color(0xFFDC2626);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isEarning
                    ? Icons.account_balance_wallet_outlined
                    : Icons.south_rounded,
                size: 20,
                color: accent,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                    letterSpacing: 0.6,
                    color: accent,
                  ),
                ),
              ),
              Text(
                currency,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: ZuranoPremiumUiColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (lines.isEmpty)
            Text(
              isEarning ? '—' : '—',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: ZuranoPremiumUiColors.textSecondary,
              ),
            )
          else
            ...lines.map((l) => PayslipLineTile(line: l, currency: currency)),
          const Divider(height: 28),
          Row(
            children: [
              Expanded(
                child: Text(
                  totalLabel,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              Text(
                total.toStringAsFixed(2),
                style: TextStyle(fontWeight: FontWeight.w900, color: accent),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
