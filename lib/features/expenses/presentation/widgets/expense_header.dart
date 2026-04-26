import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

class ExpenseHeader extends StatelessWidget {
  const ExpenseHeader({super.key, this.onBack, this.onReportTap});

  final VoidCallback? onBack;
  final VoidCallback? onReportTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final canPop = Navigator.of(context).canPop();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (canPop || onBack != null)
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                icon: const Icon(AppIcons.arrow_back),
                onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              )
            else
              const SizedBox(width: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  l10n.expensesScreenTitle,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColorsLight.textPrimary,
                  ),
                ),
              ),
            ),
            if (onReportTap != null)
              Material(
                color: AppBrandColors.secondary,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: onReportTap,
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      AppIcons.receipt_long_outlined,
                      size: 22,
                      color: AppBrandColors.primary,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.small),
        Padding(
          padding: EdgeInsetsDirectional.only(
            start: canPop || onBack != null ? 0 : 0,
          ),
          child: Text(
            l10n.expensesScreenSubtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColorsLight.textSecondary,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}
