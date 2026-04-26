import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/customer.dart';
import '../../domain/customer_model.dart';

class CustomerCard extends StatelessWidget {
  const CustomerCard({
    super.key,
    required this.customer,
    required this.l10n,
    required this.localeName,
    required this.onTap,
  });

  final Customer customer;
  final AppLocalizations l10n;
  final String localeName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isInactive = !customer.isActive;
    final segment = segmentForCustomer(customer);

    return Material(
      color: FinanceDashboardColors.surface,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: FinanceDashboardColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: FinanceDashboardColors.lightPurple,
                child: Text(
                  _initials(customer.fullName),
                  style: const TextStyle(
                    color: FinanceDashboardColors.primaryPurple,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        Text(
                          customer.fullName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: FinanceDashboardColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        _CategoryBadge(segment: segment, l10n: l10n),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      customer.phone,
                      style: const TextStyle(
                        color: FinanceDashboardColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 6,
                      children: [
                        _MiniInfo(
                          icon: Icons.calendar_month_outlined,
                          text: customer.lastVisitAt == null
                              ? l10n.customersLastVisitNever
                              : l10n.customersLastVisitShort(
                                  DateFormat.yMMMd(
                                    localeName,
                                  ).format(customer.lastVisitAt!.toLocal()),
                                ),
                        ),
                        _MiniInfo(
                          icon: Icons.payments_outlined,
                          text: customer.totalSpent > 0
                              ? l10n.customersSpentShort(
                                  customer.totalSpent.toStringAsFixed(0),
                                )
                              : l10n.customersVisitsShort(customer.visitCount),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _StatusPill(isInactive: isInactive, l10n: l10n),
                  const SizedBox(height: 20),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: FinanceDashboardColors.textSecondary.withValues(
                      alpha: 0.7,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || name.trim().isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first.isNotEmpty ? parts.first[0].toUpperCase() : '?';
    }
    final a = parts.first.isNotEmpty ? parts.first[0] : '';
    final b = parts.last.isNotEmpty ? parts.last[0] : '';
    return ('$a$b').toUpperCase();
  }
}

class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.segment, required this.l10n});

  final CustomerSegment segment;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final data = switch (segment) {
      CustomerSegment.vip => (
        label: l10n.customersTagVip,
        icon: Icons.workspace_premium_rounded,
        bg: const Color(0xFFF3E8FF),
        fg: FinanceDashboardColors.primaryPurple,
      ),
      CustomerSegment.regular => (
        label: l10n.customersCategoryRegularBadge,
        icon: Icons.star_border_rounded,
        bg: FinanceDashboardColors.greenProfitSoft,
        fg: FinanceDashboardColors.greenProfit,
      ),
      CustomerSegment.newCustomer => (
        label: l10n.customersCategoryNewBadge,
        icon: Icons.auto_awesome_rounded,
        bg: FinanceDashboardColors.bluePayrollSoft,
        fg: FinanceDashboardColors.bluePayroll,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: data.bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            data.label,
            style: TextStyle(
              color: data.fg,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 4),
          Icon(data.icon, size: 14, color: data.fg),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.isInactive, required this.l10n});

  final bool isInactive;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final color = isInactive
        ? FinanceDashboardColors.textSecondary
        : FinanceDashboardColors.greenProfit;
    final label = isInactive
        ? l10n.customersStatusInactive
        : l10n.customersStatusActive;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, size: 8, color: color),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _MiniInfo extends StatelessWidget {
  const _MiniInfo({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: FinanceDashboardColors.textSecondary),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(
            color: FinanceDashboardColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
