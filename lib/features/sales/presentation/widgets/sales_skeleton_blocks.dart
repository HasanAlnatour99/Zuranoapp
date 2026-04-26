import 'package:flutter/material.dart';

import '../../../../core/widgets/app_skeleton.dart';
import '../../../../core/theme/app_spacing.dart';

class SalesSummarySkeleton extends StatelessWidget {
  const SalesSummarySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: AppSkeletonBlock(height: 200),
    );
  }
}

class SalesChartSkeleton extends StatelessWidget {
  const SalesChartSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: AppSkeletonBlock(height: 280),
    );
  }
}

class RecentSalesSkeleton extends StatelessWidget {
  const RecentSalesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 4, 20, 12),
      child: Column(
        children: [
          AppSkeletonBlock(height: 22),
          SizedBox(height: AppSpacing.medium),
          AppSkeletonBlock(height: 56),
          SizedBox(height: AppSpacing.small),
          AppSkeletonBlock(height: 56),
        ],
      ),
    );
  }
}
