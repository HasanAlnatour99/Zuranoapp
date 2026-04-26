import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

IconData expenseCategoryIcon(String category, AppLocalizations l10n) {
  final c = category.toLowerCase();
  if (c.contains('rent') || c.contains('lease')) {
    return AppIcons.storefront_outlined;
  }
  if (c.contains('market') || c.contains('ads') || c.contains('promo')) {
    return AppIcons.campaign_outlined;
  }
  if (c.contains('util') || c.contains('electric') || c.contains('water')) {
    return AppIcons.bolt_outlined;
  }
  if (c.contains('supply') ||
      c.contains('product') ||
      c.contains('inventory')) {
    return AppIcons.inventory_2_outlined;
  }
  if (c.contains('payroll') || c.contains('salary') || c.contains('wage')) {
    return AppIcons.groups_outlined;
  }
  if (c == l10n.moneyDashboardUncategorized.toLowerCase() ||
      c.contains('uncategor')) {
    return AppIcons.help_outline_rounded;
  }
  return AppIcons.label_outline_rounded;
}
