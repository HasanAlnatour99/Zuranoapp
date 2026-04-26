import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';

import '../ui/app_illustrations.dart';
import '../motion/app_motion.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import 'app_illustration.dart';
import 'app_primary_button.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

/// Blank slate with one primary action (coachmark-friendly copy).
class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    required this.title,
    required this.message,
    this.icon = AppIcons.inbox_outlined,
    this.illustrationAsset = AppIllustrations.emptyGeneric,
    this.lottieAsset,
    this.lottieHeight = 160,
    this.centerContent = false,

    /// Smaller title/body for dense dashboards (avoids headline-sized empty copy).
    this.compactTypography = false,
    this.primaryActionLabel,
    this.onPrimaryAction,
    super.key,
  });

  final String title;
  final String message;
  final IconData icon;
  final String? illustrationAsset;
  final String? lottieAsset;
  final double lottieHeight;
  final bool centerContent;
  final bool compactTypography;
  final String? primaryActionLabel;
  final VoidCallback? onPrimaryAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final useLottie = (lottieAsset ?? '').trim().isNotEmpty;
    final useSvg = (illustrationAsset ?? '').trim().isNotEmpty;
    final compact = compactTypography;

    final illustration = useLottie
        ? Lottie.asset(
            lottieAsset!,
            height: lottieHeight,
            repeat: true,
            fit: BoxFit.contain,
          )
        : useSvg
        ? AppIllustration(
            assetName: illustrationAsset!,
            size: AppIllustrationSize.large,
            semanticLabel: title,
          )
        : Icon(icon, size: compact ? 32 : 40, color: scheme.primary);

    return Semantics(
      container: true,
      label: '$title. $message',
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(compact ? AppSpacing.medium : AppSpacing.large),
        decoration: BoxDecoration(
          color: scheme.surfaceContainer,
          borderRadius: BorderRadius.circular(AppRadius.large),
          border: Border.all(color: scheme.outline),
        ),
        child: Column(
          crossAxisAlignment: centerContent
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            illustration
                .animate()
                .fadeIn(
                  duration: AppMotion.effectiveDuration(
                    context,
                    AppMotion.short,
                  ),
                )
                .slideY(
                  begin: 0.08,
                  end: 0,
                  duration: AppMotion.effectiveDuration(
                    context,
                    AppMotion.short,
                  ),
                  curve: AppMotion.entranceCurve,
                ),
            const SizedBox(height: AppSpacing.medium),
            Text(
              title,
              style: compact
                  ? theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    )
                  : theme.textTheme.titleLarge,
              textAlign: centerContent ? TextAlign.center : TextAlign.start,
            ),
            const SizedBox(height: AppSpacing.small),
            Text(
              message,
              textAlign: centerContent ? TextAlign.center : TextAlign.start,
              style:
                  (compact
                          ? theme.textTheme.bodySmall
                          : theme.textTheme.bodyMedium)
                      ?.copyWith(color: scheme.onSurfaceVariant, height: 1.45),
            ),
            if (primaryActionLabel != null && onPrimaryAction != null) ...[
              SizedBox(height: compact ? AppSpacing.medium : AppSpacing.large),
              AppPrimaryButton(
                label: primaryActionLabel!,
                onPressed: onPrimaryAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
