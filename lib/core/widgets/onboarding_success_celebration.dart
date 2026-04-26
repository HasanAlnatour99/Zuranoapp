import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../l10n/app_localizations.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

class OnboardingSuccessCelebration {
  const OnboardingSuccessCelebration._();

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String subtitle,
  }) async {
    if (!context.mounted) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      builder: (dialogContext) {
        unawaited(
          Future<void>.delayed(const Duration(milliseconds: 780), () {
            if (!dialogContext.mounted) return;
            final nav = Navigator.of(dialogContext, rootNavigator: true);
            if (nav.canPop()) {
              nav.pop();
            }
          }),
        );
        final scheme = Theme.of(dialogContext).colorScheme;
        return Center(
          child: Material(
            color: Colors.transparent,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.scale(
                    scale: 0.92 + (0.08 * value),
                    child: child,
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.all(AppSpacing.large),
                padding: const EdgeInsets.all(AppSpacing.large),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(AppRadius.large),
                  border: Border.all(color: scheme.outline),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      AppIcons.check_circle_rounded,
                      color: scheme.primary,
                      size: 56,
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: Theme.of(dialogContext).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.small),
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(dialogContext).textTheme.bodyMedium
                          ?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<void> showSalonCreated(BuildContext context) {
    HapticFeedback.mediumImpact();
    final l10n = AppLocalizations.of(context)!;
    return show(
      context,
      title: l10n.onboardingSalonCreatedTitle,
      subtitle: l10n.onboardingSalonCreatedSubtitle,
    );
  }
}
