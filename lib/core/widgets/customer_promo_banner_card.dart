import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import 'app_surface_card.dart';

/// Discovery hero: light production card, responsive stack vs split layout.
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

  static const double _narrowBreakpoint = 360;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.large),
      child: AppSurfaceCard(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        borderRadius: AppRadius.xlarge,
        color: scheme.surface,
        showBorder: true,
        outlineOpacity: 0.14,
        shadowOpacity: 0.08,
        shadowBlurRadius: 28,
        shadowYOffset: 12,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.xlarge),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final narrow = constraints.maxWidth < _narrowBreakpoint;
              if (narrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _CopyBlock(
                      eyebrow: eyebrow,
                      title: title,
                      ctaLabel: ctaLabel,
                      onCtaPressed: onCtaPressed,
                      padArt: false,
                    ),
                    _ArtPanel(
                      assetPath: assetPath,
                      scheme: scheme,
                      expandVertically: false,
                      fixedHeight: 132,
                    ),
                  ],
                );
              }
              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 12,
                      child: _CopyBlock(
                        eyebrow: eyebrow,
                        title: title,
                        ctaLabel: ctaLabel,
                        onCtaPressed: onCtaPressed,
                        padArt: true,
                      ),
                    ),
                    Expanded(
                      flex: 10,
                      child: _ArtPanel(
                        assetPath: assetPath,
                        scheme: scheme,
                        expandVertically: true,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _CopyBlock extends StatelessWidget {
  const _CopyBlock({
    required this.eyebrow,
    required this.title,
    required this.ctaLabel,
    required this.onCtaPressed,
    required this.padArt,
  });

  final String eyebrow;
  final String title;
  final String ctaLabel;
  final VoidCallback? onCtaPressed;
  final bool padArt;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [
            Color.alphaBlend(
              scheme.primary.withValues(alpha: 0.07),
              scheme.surface,
            ),
            scheme.surface,
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.large,
          AppSpacing.large,
          AppSpacing.large,
          padArt ? AppSpacing.large : AppSpacing.medium,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              eyebrow.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: scheme.primary,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.7,
              ),
            ),
            const SizedBox(height: AppSpacing.small),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                color: scheme.onSurface,
                fontWeight: FontWeight.w800,
                height: 1.2,
              ),
            ),
            const SizedBox(height: AppSpacing.medium),
            FilledButton(
              onPressed: onCtaPressed,
              style: FilledButton.styleFrom(
                elevation: 0,
                backgroundColor: scheme.primary,
                foregroundColor: scheme.onPrimary,
                disabledBackgroundColor: scheme.onSurface.withValues(
                  alpha: 0.12,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.large,
                  vertical: AppSpacing.small,
                ),
                minimumSize: const Size(0, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.medium),
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
    );
  }
}

class _ArtPanel extends StatelessWidget {
  const _ArtPanel({
    required this.assetPath,
    required this.scheme,
    required this.expandVertically,
    this.fixedHeight,
  });

  final String assetPath;
  final ColorScheme scheme;
  final bool expandVertically;
  final double? fixedHeight;

  @override
  Widget build(BuildContext context) {
    final gradient = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.topEnd,
          end: AlignmentDirectional.bottomStart,
          colors: [
            scheme.primaryContainer,
            Color.alphaBlend(
              scheme.secondary.withValues(alpha: 0.22),
              scheme.primaryContainer,
            ),
          ],
        ),
      ),
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
    );

    if (expandVertically) {
      return SizedBox.expand(child: gradient);
    }
    return SizedBox(height: fixedHeight ?? 120, child: gradient);
  }
}
