import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import 'app_network_image.dart';
import 'app_surface_card.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

/// Customer-facing barber tile: tall profile card with photo, bio, soft stats, pill CTA.
class CustomerBarberCard extends StatelessWidget {
  const CustomerBarberCard({
    super.key,
    required this.name,
    this.subtitle,
    this.photoUrl,
    this.showVerifiedBadge = true,
    this.completedAppointments = 0,
    this.distinctServicesCompleted = 0,
    this.onBookPressed,
  });

  final String name;
  final String? subtitle;
  final String? photoUrl;

  /// Shown when the barber is part of the salon’s active roster (salon-trusted).
  final bool showVerifiedBadge;

  final int completedAppointments;
  final int distinctServicesCompleted;
  final VoidCallback? onBookPressed;

  static const double _cardShadowBlur = 24;
  static const double _cardShadowYOffset = 10;

  String _initials(String value) {
    String letter(String s) {
      final t = s.trim();
      if (t.isEmpty) {
        return '';
      }
      return String.fromCharCode(t.runes.first).toUpperCase();
    }

    final parts = value
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) {
      return '?';
    }
    if (parts.length == 1) {
      final one = letter(parts.single);
      return one.isEmpty ? '?' : one;
    }
    final a = letter(parts.first);
    final b = letter(parts.last);
    final pair = '$a$b';
    return pair.isEmpty ? '?' : pair;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final bio = subtitle?.trim();
    final hasBio = bio != null && bio.isNotEmpty;

    return AppSurfaceCard(
      borderRadius: AppRadius.profileCard,
      showBorder: false,
      shadowBlurRadius: _cardShadowBlur,
      shadowYOffset: _cardShadowYOffset,
      shadowOpacity: 0.12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.profileCardImage),
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: _PhotoBlock(photoUrl: photoUrl, initials: _initials(name)),
            ),
          ),
          const SizedBox(height: AppSpacing.medium),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                    height: 1.2,
                  ),
                ),
              ),
              if (showVerifiedBadge) ...[
                const SizedBox(width: AppSpacing.small),
                const _VerifiedBadge(),
              ],
            ],
          ),
          if (hasBio) ...[
            const SizedBox(height: AppSpacing.small),
            Text(
              bio,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ],
          SizedBox(height: hasBio ? AppSpacing.medium : AppSpacing.small),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Wrap(
                  spacing: AppSpacing.medium,
                  runSpacing: AppSpacing.small,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _StatChip(
                      icon: AppIcons.people_outline_rounded,
                      value: completedAppointments,
                    ),
                    _StatChip(
                      icon: AppIcons.checklist_rounded,
                      value: distinctServicesCompleted,
                    ),
                  ],
                ),
              ),
              _PillCta(
                label: l10n.customerBarberCardCta,
                onPressed: onBookPressed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PhotoBlock extends StatelessWidget {
  const _PhotoBlock({required this.photoUrl, required this.initials});

  final String? photoUrl;
  final String initials;

  @override
  Widget build(BuildContext context) {
    final url = photoUrl?.trim();
    if (url != null && url.isNotEmpty) {
      return AppNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        errorWidget: _InitialsPlaceholder(initials: initials),
      );
    }
    return _InitialsPlaceholder(initials: initials);
  }
}

class _InitialsPlaceholder extends StatelessWidget {
  const _InitialsPlaceholder({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return ColoredBox(
      color: scheme.surfaceContainerHigh,
      child: Center(
        child: Text(
          initials,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: scheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Tooltip(
      message: l10n.customerBarberVerifiedTooltip,
      child: Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(
          color: AppColorsLight.verifiedBadge,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: const Icon(
          AppIcons.check_rounded,
          size: 16,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({required this.icon, required this.value});

  final IconData icon;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 6),
        Text(
          '$value',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _PillCta extends StatelessWidget {
  const _PillCta({required this.label, this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Material(
      color: scheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.medium,
            vertical: 10,
          ),
          child: Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: scheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
