import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_skeleton.dart';

class ExpensesLoadingView extends StatelessWidget {
  const ExpensesLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSkeletonBlock(height: 48),
          SizedBox(height: AppSpacing.large),
          AppSkeletonBlock(height: 200),
          SizedBox(height: AppSpacing.large),
          AppSkeletonBlock(height: 48),
          SizedBox(height: AppSpacing.medium),
          AppSkeletonBlock(height: 52),
          SizedBox(height: AppSpacing.large),
          AppSkeletonBlock(height: 220),
          SizedBox(height: AppSpacing.large),
          AppSkeletonBlock(height: 200),
        ],
      ),
    );
  }
}
