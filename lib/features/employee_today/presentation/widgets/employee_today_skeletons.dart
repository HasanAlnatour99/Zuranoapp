import 'package:flutter/material.dart';

import '../../../../core/widgets/app_skeleton.dart';
import 'employee_today_widgets.dart';

/// Shimmer header row (avatar + two text lines + icon placeholders).
class EtTodayHeaderSkeleton extends StatelessWidget {
  const EtTodayHeaderSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppSkeletonBlock(height: 52, width: 52),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSkeletonBlock(height: 18, width: 160),
              SizedBox(height: 10),
              AppSkeletonBlock(height: 14, width: 120),
            ],
          ),
        ),
        const SizedBox(width: 8),
        const AppSkeletonBlock(height: 40, width: 40),
        const SizedBox(width: 4),
        const AppSkeletonBlock(height: 40, width: 40),
      ],
    );
  }
}

/// Placeholder for the main attendance hero + inner action tray.
class EtTodayAttendanceCardSkeleton extends StatelessWidget {
  const EtTodayAttendanceCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return EtPremiumCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppSkeletonBlock(height: 22, width: 200),
          const SizedBox(height: 10),
          const SizedBox(
            width: double.infinity,
            child: AppSkeletonBlock(height: 14),
          ),
          const SizedBox(height: 16),
          const AppSkeletonBlock(height: 36, width: 140),
          const SizedBox(height: 20),
          const SizedBox(
            width: double.infinity,
            child: AppSkeletonBlock(height: 58),
          ),
        ],
      ),
    );
  }
}

/// Three KPI placeholders (layout matches wide stats row).
class EtTodayStatsSkeleton extends StatelessWidget {
  const EtTodayStatsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: EtPremiumCard(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                AppSkeletonBlock(height: 20, width: 20),
                SizedBox(height: 8),
                AppSkeletonBlock(height: 16, width: 56),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: EtPremiumCard(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                AppSkeletonBlock(height: 20, width: 20),
                SizedBox(height: 8),
                AppSkeletonBlock(height: 16, width: 72),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: EtPremiumCard(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                AppSkeletonBlock(height: 20, width: 20),
                SizedBox(height: 8),
                AppSkeletonBlock(height: 16, width: 48),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Narrow layout: stacked KPI skeletons.
class EtTodayStatsSkeletonNarrow extends StatelessWidget {
  const EtTodayStatsSkeletonNarrow({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        EtPremiumCard(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              AppSkeletonBlock(height: 20, width: 20),
              SizedBox(height: 8),
              AppSkeletonBlock(height: 16, width: 56),
            ],
          ),
        ),
        const SizedBox(height: 10),
        EtPremiumCard(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              AppSkeletonBlock(height: 20, width: 20),
              SizedBox(height: 8),
              AppSkeletonBlock(height: 16, width: 72),
            ],
          ),
        ),
        const SizedBox(height: 10),
        EtPremiumCard(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              AppSkeletonBlock(height: 20, width: 20),
              SizedBox(height: 8),
              AppSkeletonBlock(height: 16, width: 48),
            ],
          ),
        ),
      ],
    );
  }
}

class EtTodayTimelineSkeleton extends StatelessWidget {
  const EtTodayTimelineSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return EtPremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              AppSkeletonBlock(height: 18, width: 140),
              Spacer(),
              AppSkeletonBlock(height: 14, width: 48),
            ],
          ),
          const SizedBox(height: 16),
          const SizedBox(
            width: double.infinity,
            child: AppSkeletonBlock(height: 14),
          ),
          const SizedBox(height: 12),
          const AppSkeletonBlock(height: 14, width: 220),
          const SizedBox(height: 12),
          const AppSkeletonBlock(height: 14, width: 180),
        ],
      ),
    );
  }
}
