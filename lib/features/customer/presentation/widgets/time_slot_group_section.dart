import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../data/models/customer_booking_slot.dart';
import 'customer_time_slot_chip.dart';

class TimeSlotGroupSection extends StatelessWidget {
  const TimeSlotGroupSection({
    super.key,
    required this.title,
    required this.slots,
    required this.selectedStartAt,
    required this.onSlotTap,
  });

  final String title;
  final List<CustomerBookingSlot> slots;
  final DateTime? selectedStartAt;
  final ValueChanged<CustomerBookingSlot> onSlotTap;

  @override
  Widget build(BuildContext context) {
    if (slots.isEmpty) {
      return const SizedBox.shrink();
    }
    final locale = Localizations.localeOf(context).toString();
    final formatter = DateFormat.jm(locale);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColorsLight.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.small),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: slots.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: AppSpacing.small,
              crossAxisSpacing: AppSpacing.small,
              childAspectRatio: 2.45,
            ),
            itemBuilder: (context, index) {
              final slot = slots[index];
              final selected =
                  selectedStartAt != null &&
                  selectedStartAt!.isAtSameMomentAs(slot.startAt);
              return CustomerTimeSlotChip(
                label: formatter.format(slot.startAt),
                selected: selected,
                enabled: slot.isAvailable,
                onTap: () => onSlotTap(slot),
              );
            },
          ),
        ],
      ),
    );
  }
}
