import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';

/// Lightweight shimmer placeholder layout (perceived performance).
class AppSkeletonBlock extends StatelessWidget {
  const AppSkeletonBlock({required this.height, this.width, super.key});

  final double height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final baseColor = Color.alphaBlend(
      scheme.outline.withValues(alpha: 0.08),
      scheme.surfaceContainerLow,
    );
    final highlightColor = Color.alphaBlend(
      scheme.onSurface.withValues(alpha: 0.03),
      scheme.surfaceContainer,
    );

    return RepaintBoundary(
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        period: const Duration(milliseconds: 1350),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: BorderRadius.circular(AppRadius.medium),
            border: Border.all(color: scheme.outline.withValues(alpha: 0.12)),
          ),
        ),
      ),
    );
  }
}

class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.large),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSkeletonBlock(height: 28, width: 200),
          const SizedBox(height: AppSpacing.large),
          const AppSkeletonBlock(height: 120),
          const SizedBox(height: AppSpacing.medium),
          const AppSkeletonBlock(height: 120),
        ],
      ),
    );
  }
}
