import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

/// Greeting block: optional monogram, eyebrow, headline, trailing actions.
class CustomerDiscoveryHeader extends StatelessWidget {
  const CustomerDiscoveryHeader({
    super.key,
    required this.timeGreeting,
    required this.headline,
    this.brandInitial,
    this.trailing,
  });

  final String timeGreeting;
  final String headline;

  /// First display character for monogram (any script); omit for default icon.
  final String? brandInitial;

  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final initial = _monogram(brandInitial);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(
          bottom: BorderSide(color: scheme.outline.withValues(alpha: 0.1)),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.large,
          AppSpacing.large,
          AppSpacing.large,
          AppSpacing.medium,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AvatarMark(scheme: scheme, letter: initial),
            const SizedBox(width: AppSpacing.medium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    timeGreeting,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.small),
                  Text(
                    headline,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: scheme.onSurface,
                      height: 1.12,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: AppSpacing.small),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }

  static String? _monogram(String? raw) {
    final t = raw?.trim();
    if (t == null || t.isEmpty) {
      return null;
    }
    return t.characters.first.toUpperCase();
  }
}

class _AvatarMark extends StatelessWidget {
  const _AvatarMark({required this.scheme, required this.letter});

  final ColorScheme scheme;
  final String? letter;

  @override
  Widget build(BuildContext context) {
    const size = 52.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [
            scheme.primary.withValues(alpha: 0.35),
            scheme.secondary.withValues(alpha: 0.45),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.18),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(2.5),
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: scheme.surface.withValues(alpha: 0.98),
        ),
        child: Center(
          child: letter != null
              ? Text(
                  letter!,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: scheme.primary,
                    height: 1,
                  ),
                )
              : Icon(
                  AppIcons.content_cut_rounded,
                  color: scheme.primary,
                  size: 26,
                ),
        ),
      ),
    );
  }
}
