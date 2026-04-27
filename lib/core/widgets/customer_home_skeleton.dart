import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import 'app_skeleton.dart';

/// Shimmer layout aligned with discovery salon rows.
class CustomerHomeSkeleton extends StatelessWidget {
  const CustomerHomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.large,
        AppSpacing.small,
        AppSpacing.large,
        AppSpacing.large,
      ),
      itemCount: 6,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.medium),
      itemBuilder: (_, index) {
        return Row(
          key: ValueKey('customer_home_sk_$index'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppSkeletonBlock(width: 52, height: 52),
            const SizedBox(width: AppSpacing.medium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppSkeletonBlock(height: 18, width: 200),
                  const SizedBox(height: AppSpacing.small),
                  const SizedBox(
                    width: double.infinity,
                    child: AppSkeletonBlock(height: 14),
                  ),
                  const SizedBox(height: AppSpacing.small),
                  const AppSkeletonBlock(height: 14, width: 140),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
