import 'package:flutter/material.dart';

import '../../../../core/formatting/app_money_format.dart';
import '../../../../core/theme/app_colors.dart'
    show AppBrandColors, AppColorsLight;
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/expense_summary.dart';

class CategoryBreakdownCard extends StatelessWidget {
  const CategoryBreakdownCard({
    super.key,
    required this.rows,
    required this.totalAmount,
    required this.currencyCode,
    this.onViewAll,
  });

  final List<ExpenseCategoryBreakdownUiRow> rows;
  final double totalAmount;
  final String currencyCode;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final theme = Theme.of(context);
    final totalStr = formatAppMoney(totalAmount, currencyCode, locale);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.expensesScreenBreakdownTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColorsLight.textPrimary,
                    ),
                  ),
                ),
                if (onViewAll != null && rows.isNotEmpty)
                  TextButton(
                    onPressed: onViewAll,
                    child: Text(
                      '${l10n.expensesScreenViewAll} ›',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppBrandColors.primary,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.medium),
            if (rows.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  children: [
                    Text(
                      l10n.expensesScreenNoCategoriesTitle,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColorsLight.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.expensesScreenNoCategoriesMessage,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColorsLight.textSecondary,
                      ),
                    ),
                  ],
                ),
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomPaint(
                          size: const Size(100, 100),
                          painter: _DonutPlaceholderPainter(
                            segments: rows
                                .take(4)
                                .map((r) => r.progress)
                                .toList(),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              totalStr,
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: AppColorsLight.textPrimary,
                              ),
                            ),
                            Text(
                              l10n.expensesScreenTotalExpensesLabel,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: AppColorsLight.textSecondary,
                                fontSize: 9,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.medium),
                  Expanded(
                    child: Column(
                      children: [
                        for (var i = 0; i < rows.length && i < 6; i++) ...[
                          if (i > 0) const SizedBox(height: 12),
                          _CategoryRow(
                            row: rows[i],
                            currencyCode: currencyCode,
                            uncategorizedLabel:
                                l10n.moneyDashboardUncategorized,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({
    required this.row,
    required this.currencyCode,
    required this.uncategorizedLabel,
  });

  final ExpenseCategoryBreakdownUiRow row;
  final String currencyCode;
  final String uncategorizedLabel;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final theme = Theme.of(context);
    final label = row.categoryLabel.trim().isEmpty
        ? uncategorizedLabel
        : row.categoryLabel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: row.barColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColorsLight.textPrimary,
                ),
              ),
            ),
            Text(
              formatAppMoney(row.amount, currencyCode, locale),
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColorsLight.textPrimary,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              '${row.percentOfTotal.round()}%',
              style: theme.textTheme.labelMedium?.copyWith(
                color: AppColorsLight.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: row.progress.clamp(0.0, 1.0),
            minHeight: 6,
            backgroundColor: const Color(0xFFF3F4F6),
            valueColor: AlwaysStoppedAnimation<Color>(row.barColor),
          ),
        ),
      ],
    );
  }
}

/// Lightweight ring hint (not a full chart dependency).
class _DonutPlaceholderPainter extends CustomPainter {
  _DonutPlaceholderPainter({required this.segments});

  final List<double> segments;

  static const _colors = [
    Color(0xFF7C3AED),
    Color(0xFF8B5CF6),
    Color(0xFFA78BFA),
    Color(0xFFC4B5FD),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outer = size.width / 2;
    final inner = outer * 0.55;
    var start = -3.14159 / 2;
    final total = segments.fold<double>(0, (a, b) => a + b);
    if (total <= 0) return;
    for (var i = 0; i < segments.length; i++) {
      final sweep = (segments[i] / total) * 3.14159 * 2 * 0.98;
      final paint = Paint()
        ..color = _colors[i % _colors.length]
        ..style = PaintingStyle.stroke
        ..strokeWidth = outer - inner
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: (outer + inner) / 2),
        start,
        sweep,
        false,
        paint,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPlaceholderPainter oldDelegate) =>
      oldDelegate.segments != segments;
}
