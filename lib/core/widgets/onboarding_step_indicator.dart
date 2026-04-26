import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// Wizard-style progress (steps left / completeness cue).
class OnboardingStepIndicator extends StatelessWidget {
  const OnboardingStepIndicator({
    required this.currentStep,
    required this.totalSteps,
    this.stepLabel,
    super.key,
  }) : assert(currentStep >= 1),
       assert(totalSteps >= currentStep);

  final int currentStep;
  final int totalSteps;
  final String? stepLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Semantics(
      label:
          'Step $currentStep of $totalSteps${stepLabel != null ? ', ${stepLabel!}' : ''}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(totalSteps, (index) {
              final step = index + 1;
              final isDone = step < currentStep;
              final isCurrent = step == currentStep;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index < totalSteps - 1 ? AppSpacing.small : 0,
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDone || isCurrent
                          ? scheme.primary
                          : scheme.outline,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: AppSpacing.small),
          Text(
            stepLabel ?? 'Step $currentStep of $totalSteps',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
