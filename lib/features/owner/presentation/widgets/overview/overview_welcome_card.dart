import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../core/text/personalized_greeting.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../logic/owner_overview_state.dart';
import 'overview_design_tokens.dart';

/// Single greeting + salon + one business line.
class OverviewWelcomeCard extends StatelessWidget {
  const OverviewWelcomeCard({
    super.key,
    required this.displayName,
    required this.salonName,
    required this.state,
  });

  final String displayName;
  final String salonName;
  final OwnerOverviewState state;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final formattedName = displayName.trim().toUpperCaseFirst();
    final headline = formattedName.isEmpty
        ? getGreeting(l10n)
        : '${getGreeting(l10n)}, $formattedName';
    final salon = salonName.trim();

    final message = _oneLineBusinessMessage(l10n, state);
    final sz = MediaQuery.sizeOf(context);
    final screenH = sz.height;

    /// Thin purple accent (1% of screen height).
    final accentLineH = screenH * 0.01;

    /// Corner radius: 0.3× screen height, capped so R ≤ half shortest side (valid RRect).
    final cornerR = math.min(screenH * 0.3, sz.shortestSide * 0.5);

    return ClipRRect(
      borderRadius: BorderRadius.circular(cornerR),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: scheme.outline.withValues(alpha: 0.12)),
          boxShadow: [
            BoxShadow(
              color: OwnerOverviewTokens.purple.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: accentLineH,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      OwnerOverviewTokens.purple.withValues(alpha: 0.2),
                      OwnerOverviewTokens.purple.withValues(alpha: 0.06),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(18, 14, 18, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    headline,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: OwnerOverviewTokens.textPrimary,
                      height: 1.2,
                    ),
                  ),
                  if (salon.isNotEmpty) ...[
                    const Gap(6),
                    Text(
                      salon,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 13,
                        color: scheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const Gap(10),
                  Text(
                    message,
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      height: 1.35,
                      color: OwnerOverviewTokens.textPrimary.withValues(
                        alpha: 0.82,
                      ),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _oneLineBusinessMessage(AppLocalizations l10n, OwnerOverviewState s) {
    if (s.pendingBookingsCount > 0) {
      return l10n.ownerOverviewAttentionPendingBookings(s.pendingBookingsCount);
    }
    if (s.pendingApprovalsCount > 0) {
      return l10n.ownerOverviewAttentionPendingApprovals(
        s.pendingApprovalsCount,
      );
    }
    if (!s.hasTodayRevenue && s.todayRevenue <= 0) {
      return l10n.ownerOverviewEmptyRevenueToday;
    }
    return l10n.ownerOverviewDashboardTagline;
  }
}
