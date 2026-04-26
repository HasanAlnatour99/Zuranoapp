import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/payslip_line_model.dart';

class PayslipLineTile extends StatelessWidget {
  const PayslipLineTile({
    super.key,
    required this.line,
    required this.currency,
  });

  final PayslipLineModel line;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              line.elementName,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ZuranoPremiumUiColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            '${line.amount.toStringAsFixed(2)} $currency',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: ZuranoPremiumUiColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
