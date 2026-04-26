import 'package:flutter/material.dart';

import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';

class ProfilePhotoSection extends StatelessWidget {
  const ProfilePhotoSection({
    super.key,
    required this.title,
    required this.caption,
    required this.buttonLabel,
    required this.onAddPhoto,
    required this.avatarSize,
    required this.cardRadius,
    this.enabled = true,
  });

  final String title;
  final String caption;
  final String buttonLabel;
  final VoidCallback onAddPhoto;
  final double avatarSize;
  final double cardRadius;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final badgeSize = (avatarSize * 0.34).clamp(28.0, 36.0);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(cardRadius),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.35),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 22,
            offset: const Offset(0, 8),
            color: scheme.shadow.withValues(alpha: 0.06),
          ),
        ],
      ),
      padding: const EdgeInsetsDirectional.all(AppSpacing.medium),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: avatarSize + 4,
            height: avatarSize + 4,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: avatarSize / 2,
                  backgroundColor: scheme.primaryContainer.withValues(
                    alpha: 0.9,
                  ),
                  child: Icon(
                    Icons.person_rounded,
                    size: avatarSize * 0.45,
                    color: scheme.primary.withValues(alpha: 0.75),
                  ),
                ),
                PositionedDirectional(
                  end: -2,
                  bottom: -2,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: scheme.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                          color: scheme.shadow.withValues(alpha: 0.12),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      width: badgeSize,
                      height: badgeSize,
                      child: Icon(
                        Icons.photo_camera_rounded,
                        size: badgeSize * 0.5,
                        color: scheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.medium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  caption,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: AppSpacing.small),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: OutlinedButton(
                    onPressed: enabled ? onAddPhoto : null,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: scheme.primary,
                      side: BorderSide(
                        color: scheme.primary.withValues(alpha: 0.55),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.medium,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.large),
                      ),
                    ),
                    child: Text(buttonLabel),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
