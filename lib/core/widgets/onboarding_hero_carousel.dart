import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

/// Soft auto-advancing carousel of SVG hero art. Paths usually come from [AppVisualCatalog].
class OnboardingHeroCarousel extends StatefulWidget {
  const OnboardingHeroCarousel({
    required this.assetPaths,
    super.key,
    this.height = 132,
    this.autoAdvance = true,
  });

  final List<String> assetPaths;
  final double height;
  final bool autoAdvance;

  @override
  State<OnboardingHeroCarousel> createState() => _OnboardingHeroCarouselState();
}

class _OnboardingHeroCarouselState extends State<OnboardingHeroCarousel> {
  late final PageController _pageController;
  Timer? _timer;
  int _page = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);
    _armTimer();
  }

  void _armTimer() {
    _timer?.cancel();
    if (!widget.autoAdvance || widget.assetPaths.length < 2) {
      return;
    }
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || !_pageController.hasClients) {
        return;
      }
      final next = (_page + 1) % widget.assetPaths.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 480),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void didUpdateWidget(covariant OnboardingHeroCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assetPaths.length != widget.assetPaths.length ||
        oldWidget.autoAdvance != widget.autoAdvance) {
      _armTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final paths = widget.assetPaths;

    if (paths.isEmpty) {
      return SizedBox(
        height: widget.height,
        child: Center(
          child: Icon(
            AppIcons.content_cut_rounded,
            size: 48,
            color: scheme.primary.withValues(alpha: 0.65),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _pageController,
            itemCount: paths.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (context, i) {
              final path = paths[i];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.small,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.large),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerLow.withValues(alpha: 0.92),
                      border: Border.all(
                        color: scheme.outline.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.medium),
                      child: SvgPicture.asset(
                        path,
                        fit: BoxFit.contain,
                        colorFilter: ColorFilter.mode(
                          scheme.primary.withValues(alpha: 0.92),
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (paths.length > 1) ...[
          const SizedBox(height: AppSpacing.small),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(paths.length, (i) {
              final active = i == _page;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                height: 5,
                width: active ? 18 : 5,
                decoration: BoxDecoration(
                  color: active
                      ? scheme.primary
                      : scheme.outline.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(999),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}
