import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import 'app_surface_card.dart';

/// Split marketing strip: dark copy block + illustrative asset panel.
class CustomerPromoBannerCard extends StatelessWidget {
  const CustomerPromoBannerCard({
    super.key,
    required this.eyebrow,
    required this.title,
    required this.ctaLabel,
    this.onCtaPressed,
    this.assetPath = 'assets/images/app/hero_tools.svg',
  });

  final String eyebrow;
  final String title;
  final String ctaLabel;
  final VoidCallback? onCtaPressed;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final inverse = scheme.inverseSurface;
    final onInverse = scheme.onInverseSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.large),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xlarge),
        child: AppSurfaceCard(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          borderRadius: AppRadius.xlarge,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 11,
                  child: Container(
                    color: inverse,
                    padding: const EdgeInsets.all(AppSpacing.large),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          eyebrow.toUpperCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: scheme.primary,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.small),
                        Text(
                          title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: onInverse,
                            fontWeight: FontWeight.w800,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.medium),
                        FilledButton(
                          onPressed: onCtaPressed,
                          style: FilledButton.styleFrom(
                            backgroundColor: scheme.primary,
                            foregroundColor: scheme.onPrimary,
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.large,
                              vertical: AppSpacing.small,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppRadius.medium,
                              ),
                            ),
                          ),
                          child: Text(
                            ctaLabel,
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 9,
                  child: ColoredBox(
                    color: scheme.primaryContainer,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.medium),
                        child: SvgPicture.asset(
                          assetPath,
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
