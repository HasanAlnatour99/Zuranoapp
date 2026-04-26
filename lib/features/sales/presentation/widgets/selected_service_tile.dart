import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class SelectedServiceTile extends StatelessWidget {
  const SelectedServiceTile({
    super.key,
    required this.title,
    required this.priceLabel,
    required this.onRemove,
  });

  final String title;
  final String priceLabel;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: FinanceDashboardColors.primaryPurple.withValues(alpha: 0.10),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    FinanceDashboardColors.primaryPurple,
                    FinanceDashboardColors.deepPurple,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.content_cut_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: FinanceDashboardColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    'Selected service',
                    style: TextStyle(
                      fontSize: 12,
                      color: FinanceDashboardColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              priceLabel,
              style: const TextStyle(
                fontSize: 14,
                color: FinanceDashboardColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
            IconButton(
              tooltip: MaterialLocalizations.of(context).deleteButtonTooltip,
              onPressed: onRemove,
              icon: Icon(
                Icons.delete_outline_rounded,
                color: FinanceDashboardColors.textSecondary.withValues(
                  alpha: 0.74,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
