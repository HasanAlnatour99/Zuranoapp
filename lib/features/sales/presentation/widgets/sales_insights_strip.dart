import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart' show FinanceDashboardColors;
import 'sales_insight_card.dart';

class SalesInsightsStrip extends StatelessWidget {
  const SalesInsightsStrip({
    super.key,
    required this.topServicesTitle,
    required this.topServicesSubtitle,
    required this.topServicesHelper,
    required this.topServicesAction,
    required this.barberTitle,
    required this.barberSubtitle,
    required this.barberHelper,
    required this.barberAction,
    required this.paymentTitle,
    required this.paymentSubtitle,
    required this.paymentHelper,
    required this.paymentAction,
  });

  final String topServicesTitle;
  final String topServicesSubtitle;
  final String topServicesHelper;
  final String topServicesAction;
  final String barberTitle;
  final String barberSubtitle;
  final String barberHelper;
  final String barberAction;
  final String paymentTitle;
  final String paymentSubtitle;
  final String paymentHelper;
  final String paymentAction;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 268,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
        children: [
          SalesInsightCard(
            icon: Icons.content_cut_rounded,
            title: topServicesTitle,
            subtitle: topServicesSubtitle,
            helperText: topServicesHelper,
            actionText: topServicesAction,
            onAction: () => context.push(AppRoutes.ownerServices),
            child: Icon(
              Icons.receipt_long_rounded,
              size: 48,
              color: FinanceDashboardColors.primaryPurple.withValues(
                alpha: 0.35,
              ),
            ),
          ),
          SalesInsightCard(
            icon: Icons.person_rounded,
            title: barberTitle,
            subtitle: barberSubtitle,
            helperText: barberHelper,
            actionText: barberAction,
            onAction: () => context.push(AppRoutes.ownerSalesAdd),
            child: Icon(
              Icons.bar_chart_rounded,
              size: 48,
              color: FinanceDashboardColors.primaryPurple.withValues(
                alpha: 0.35,
              ),
            ),
          ),
          SalesInsightCard(
            icon: Icons.payments_rounded,
            title: paymentTitle,
            subtitle: paymentSubtitle,
            helperText: paymentHelper,
            actionText: paymentAction,
            onAction: () => context.push(AppRoutes.ownerSalesAdd),
            child: Icon(
              Icons.donut_large_rounded,
              size: 48,
              color: FinanceDashboardColors.primaryPurple.withValues(
                alpha: 0.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
