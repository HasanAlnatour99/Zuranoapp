import 'package:flutter/material.dart';

import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import 'app_fade_in.dart';
import 'onboarding_step_indicator.dart';

class AppOnboardingScaffold extends StatelessWidget {
  const AppOnboardingScaffold({
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.child,
    this.footer,
    this.leading,
    this.topVisual,
    this.onboardingStep,
    this.onboardingTotalSteps,
    this.onboardingStepLabel,
    this.centeredViewportLayout = false,
    this.scrollPadding,
    this.bodyContainerPadding,
    super.key,
  });

  final String eyebrow;
  final String title;
  final String description;
  final Widget child;
  final Widget? footer;
  final Widget? leading;

  /// Optional hero (e.g. illustration carousel) shown above the eyebrow.
  final Widget? topVisual;
  final int? onboardingStep;
  final int? onboardingTotalSteps;
  final String? onboardingStepLabel;

  /// When true, content is grouped and vertically centered in the viewport when
  /// it fits (short forms), while remaining scrollable when taller than the view.
  final bool centeredViewportLayout;

  /// Overrides default scroll padding when set.
  final EdgeInsetsGeometry? scrollPadding;

  /// Padding inside the main surface container around [child].
  final EdgeInsetsGeometry? bodyContainerPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final viewInsets = MediaQuery.viewInsetsOf(context);
    final locale = Localizations.localeOf(context);
    final eyebrowText = locale.languageCode == 'ar'
        ? eyebrow
        : eyebrow.toUpperCase();

    final defaultScrollPadding = EdgeInsets.fromLTRB(
      AppSpacing.large,
      AppSpacing.large,
      AppSpacing.large,
      AppSpacing.large + viewInsets.bottom,
    );
    final effectiveScrollPadding = scrollPadding ?? defaultScrollPadding;
    final effectiveBodyPadding =
        bodyContainerPadding ?? const EdgeInsets.all(AppSpacing.large);

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: effectiveScrollPadding,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: centeredViewportLayout
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 520),
                              child: _OnboardingBodyColumn(
                                leading: leading,
                                topVisual: topVisual,
                                eyebrowText: eyebrowText,
                                scheme: scheme,
                                theme: theme,
                                locale: locale,
                                title: title,
                                description: description,
                                onboardingStep: onboardingStep,
                                onboardingTotalSteps: onboardingTotalSteps,
                                onboardingStepLabel: onboardingStepLabel,
                                bodyContainerPadding: effectiveBodyPadding,
                                footer: footer,
                                child: child,
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 520),
                            child: _OnboardingBodyColumn(
                              leading: leading,
                              topVisual: topVisual,
                              eyebrowText: eyebrowText,
                              scheme: scheme,
                              theme: theme,
                              locale: locale,
                              title: title,
                              description: description,
                              onboardingStep: onboardingStep,
                              onboardingTotalSteps: onboardingTotalSteps,
                              onboardingStepLabel: onboardingStepLabel,
                              bodyContainerPadding: effectiveBodyPadding,
                              footer: footer,
                              child: child,
                            ),
                          ),
                        ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _OnboardingBodyColumn extends StatelessWidget {
  const _OnboardingBodyColumn({
    required this.eyebrowText,
    required this.scheme,
    required this.theme,
    required this.locale,
    required this.title,
    required this.description,
    required this.onboardingStep,
    required this.onboardingTotalSteps,
    required this.onboardingStepLabel,
    required this.bodyContainerPadding,
    this.footer,
    this.leading,
    this.topVisual,
    required this.child,
  });

  final Widget? leading;
  final Widget? topVisual;
  final String eyebrowText;
  final ColorScheme scheme;
  final ThemeData theme;
  final Locale locale;
  final String title;
  final String description;
  final int? onboardingStep;
  final int? onboardingTotalSteps;
  final String? onboardingStepLabel;
  final EdgeInsetsGeometry bodyContainerPadding;
  final Widget? footer;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (leading != null) ...[
          leading!,
          const SizedBox(height: AppSpacing.medium),
        ],
        if (topVisual != null) ...[
          topVisual!,
          const SizedBox(height: AppSpacing.large),
        ],
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.medium,
            vertical: AppSpacing.small,
          ),
          decoration: BoxDecoration(
            color: scheme.surfaceContainer,
            borderRadius: BorderRadius.circular(AppRadius.medium),
            border: Border.all(color: scheme.outline),
          ),
          child: Text(
            eyebrowText,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.primary,
              fontWeight: FontWeight.w700,
              letterSpacing: locale.languageCode == 'ar' ? 0 : 1.2,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.large),
        Text(title, style: theme.textTheme.headlineSmall),
        const SizedBox(height: AppSpacing.small),
        Text(
          description,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: scheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
        const SizedBox(height: AppSpacing.large),
        Container(
          width: double.infinity,
          padding: bodyContainerPadding,
          decoration: BoxDecoration(
            color: scheme.surfaceContainer,
            borderRadius: BorderRadius.circular(AppRadius.large),
            border: Border.all(color: scheme.outline),
          ),
          child: AppFadeIn(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (onboardingStep != null && onboardingTotalSteps != null) ...[
                  OnboardingStepIndicator(
                    currentStep: onboardingStep!,
                    totalSteps: onboardingTotalSteps!,
                    stepLabel: onboardingStepLabel,
                  ),
                  const SizedBox(height: AppSpacing.large),
                ],
                child,
              ],
            ),
          ),
        ),
        if (footer != null) ...[
          const SizedBox(height: AppSpacing.large),
          footer!,
        ],
      ],
    );
  }
}
