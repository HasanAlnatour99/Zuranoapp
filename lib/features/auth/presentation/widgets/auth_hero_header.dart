import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/onboarding_hero_carousel.dart';
import '../../../../providers/app_visual_catalog_provider.dart';

class AuthHeroHeader extends ConsumerWidget {
  const AuthHeroHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(appVisualPathsProvider);
    return async.when(
      data: (paths) => OnboardingHeroCarousel(assetPaths: paths),
      loading: () => const _HeroLoading(),
      error: (_, _) => const _HeroLoading(),
    );
  }
}

class _HeroLoading extends StatelessWidget {
  const _HeroLoading();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: 132,
      child: Center(
        child: SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: scheme.primary.withValues(alpha: 0.75),
          ),
        ),
      ),
    );
  }
}
