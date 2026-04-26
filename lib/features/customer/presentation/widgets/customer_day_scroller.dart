import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_surface_card.dart';

class CustomerDayScroller extends StatelessWidget {
  const CustomerDayScroller({
    super.key,
    required this.selectedDay,
    required this.onDaySelected,
    this.daysCount = 14,
  });

  final DateTime selectedDay;
  final ValueChanged<DateTime> onDaySelected;
  final int daysCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final locale = Localizations.localeOf(context).toString();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: daysCount,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.small),
        itemBuilder: (context, index) {
          final day = today.add(Duration(days: index));
          final isSelected =
              day.year == selectedDay.year &&
              day.month == selectedDay.month &&
              day.day == selectedDay.day;

          final dayName = DateFormat.E(locale).format(day);
          final dayNumber = DateFormat.d(locale).format(day);
          final monthName = DateFormat.MMM(locale).format(day);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: SizedBox(
              width: 70,
              child: AppSurfaceCard(
                borderRadius: AppRadius.large,
                padding: EdgeInsets.zero,
                onTap: () => onDaySelected(day),
                color: isSelected ? scheme.primary : scheme.surfaceContainer,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      dayName,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isSelected
                            ? scheme.onPrimary.withValues(alpha: 0.8)
                            : scheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dayNumber,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: isSelected ? scheme.onPrimary : scheme.onSurface,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      monthName,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: isSelected
                            ? scheme.onPrimary.withValues(alpha: 0.8)
                            : scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
