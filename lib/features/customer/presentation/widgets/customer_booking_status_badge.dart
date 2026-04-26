import 'package:flutter/material.dart';

import '../../../../core/constants/booking_statuses.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';

class CustomerBookingStatusBadge extends StatelessWidget {
  const CustomerBookingStatusBadge({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = _statusColors(theme.colorScheme);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: colors.foreground.withValues(alpha: 0.16)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.small,
          vertical: 6,
        ),
        child: Text(
          _label(AppLocalizations.of(context)!),
          style: theme.textTheme.labelSmall?.copyWith(
            color: colors.foreground,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  String _label(AppLocalizations l10n) {
    return switch (status.trim()) {
      BookingStatuses.pending => l10n.customerBookingStatusPending,
      BookingStatuses.confirmed => l10n.customerBookingStatusConfirmed,
      'checkedIn' || 'checked_in' => l10n.customerBookingStatusCheckedIn,
      BookingStatuses.completed => l10n.customerBookingStatusCompleted,
      BookingStatuses.cancelled => l10n.customerBookingStatusCancelled,
      BookingStatuses.noShow || 'noShow' => l10n.customerBookingStatusNoShow,
      _ => status.trim().isEmpty ? l10n.customerBookingStatusPending : status,
    };
  }

  _BadgeColors _statusColors(ColorScheme scheme) {
    return switch (status.trim()) {
      BookingStatuses.pending => _BadgeColors(
        scheme.secondaryContainer,
        scheme.onSecondaryContainer,
      ),
      BookingStatuses.confirmed => _BadgeColors(
        scheme.primaryContainer,
        scheme.onPrimaryContainer,
      ),
      'checkedIn' || 'checked_in' => _BadgeColors(
        scheme.tertiaryContainer,
        scheme.onTertiaryContainer,
      ),
      BookingStatuses.completed => _BadgeColors(
        scheme.primary.withValues(alpha: 0.10),
        scheme.primary,
      ),
      BookingStatuses.cancelled => _BadgeColors(
        scheme.errorContainer,
        scheme.onErrorContainer,
      ),
      BookingStatuses.noShow || 'noShow' => _BadgeColors(
        scheme.outlineVariant.withValues(alpha: 0.45),
        scheme.onSurfaceVariant,
      ),
      _ => _BadgeColors(
        scheme.surfaceContainerHighest,
        scheme.onSurfaceVariant,
      ),
    };
  }
}

class _BadgeColors {
  const _BadgeColors(this.background, this.foreground);

  final Color background;
  final Color foreground;
}
