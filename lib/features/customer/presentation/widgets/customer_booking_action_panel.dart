import 'package:flutter/material.dart';

import '../../../../core/constants/booking_status_machine.dart';
import '../../../../core/constants/booking_statuses.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/customer_booking_details_model.dart';
import 'customer_gradient_scaffold.dart';

class CustomerBookingActionPanel extends StatelessWidget {
  const CustomerBookingActionPanel({
    super.key,
    required this.details,
    required this.onRescheduleComingSoon,
    required this.onBookAgain,
    this.onCancelBooking,
    this.onLeaveFeedback,
  });

  final CustomerBookingDetailsModel details;
  final VoidCallback onRescheduleComingSoon;
  final VoidCallback onBookAgain;
  final VoidCallback? onCancelBooking;
  final VoidCallback? onLeaveFeedback;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final status = details.status.trim();
    final normalized = BookingStatusMachine.normalize(status);

    final isPendingOrConfirmed =
        normalized == BookingStatuses.pending ||
        normalized == BookingStatuses.confirmed;
    final isCheckedIn = status == 'checkedIn' || status == 'checked_in';
    final showsUpcomingActions = isPendingOrConfirmed || isCheckedIn;

    final isCompleted = status == BookingStatuses.completed;
    final isCancelledLike =
        status == BookingStatuses.cancelled ||
        status == BookingStatuses.noShow ||
        status == 'noShow' ||
        status == BookingStatuses.rescheduled;

    if (!showsUpcomingActions && !isCompleted && !isCancelledLike) {
      return const SizedBox.shrink();
    }

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(AppRadius.xlarge),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.customerBookingDetailsActionsTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColorsLight.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.medium),
            if (showsUpcomingActions) ...[
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onRescheduleComingSoon,
                  child: Text(l10n.customerBookingDetailsReschedule),
                ),
              ),
              if (isPendingOrConfirmed && onCancelBooking != null) ...[
                const SizedBox(height: AppSpacing.small),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: CustomerPrimaryButtonStyle.filled(context),
                    onPressed: onCancelBooking,
                    child: Text(l10n.customerBookingDetailsCancelBooking),
                  ),
                ),
              ],
            ] else if (isCompleted) ...[
              if (details.feedbackSubmitted) ...[
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withValues(
                      alpha: 0.35,
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.large),
                    border: Border.all(
                      color: theme.colorScheme.outlineVariant.withValues(
                        alpha: 0.5,
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.medium),
                    child: Row(
                      children: [
                        Icon(
                          Icons.mark_chat_read_outlined,
                          color: AppBrandColors.primary,
                          size: 22,
                        ),
                        const SizedBox(width: AppSpacing.small),
                        Expanded(
                          child: Text(
                            l10n.customerFeedbackSubmittedBadge,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AppColorsLight.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else if (onLeaveFeedback != null) ...[
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: CustomerPrimaryButtonStyle.filled(context),
                    onPressed: onLeaveFeedback,
                    child: Text(l10n.customerBookingDetailsLeaveFeedback),
                  ),
                ),
              ],
            ] else if (isCancelledLike) ...[
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: CustomerPrimaryButtonStyle.filled(context),
                  onPressed: onBookAgain,
                  child: Text(l10n.customerBookingDetailsBookAgain),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
