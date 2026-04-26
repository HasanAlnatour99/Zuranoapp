import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

class SocialAuthSection extends StatelessWidget {
  const SocialAuthSection({
    required this.onGoogle,
    required this.onApple,
    required this.onFacebook,
    required this.googleLoading,
    required this.appleLoading,
    required this.facebookLoading,
    required this.enabled,
    super.key,
  });

  final VoidCallback? onGoogle;
  final VoidCallback? onApple;
  final VoidCallback? onFacebook;
  final bool googleLoading;
  final bool appleLoading;
  final bool facebookLoading;
  final bool enabled;

  static bool get showApple {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS;
  }

  static bool get showFacebook {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Divider(color: scheme.outline.withValues(alpha: 0.5)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.medium,
              ),
              child: Text(
                l10n.socialAuthOr,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                  letterSpacing: 2,
                ),
              ),
            ),
            Expanded(
              child: Divider(color: scheme.outline.withValues(alpha: 0.5)),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.medium),
        Text(
          l10n.socialAuthContinueTitle,
          style: theme.textTheme.titleSmall?.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.small),
        Wrap(
          spacing: AppSpacing.small,
          runSpacing: AppSpacing.small,
          alignment: WrapAlignment.start,
          children: [
            _OAuthChip(
              label: l10n.socialAuthGoogle,
              icon: AppIcons.g_mobiledata_rounded,
              iconColor: const Color(0xFF4285F4),
              isLoading: googleLoading,
              onPressed: enabled && !googleLoading ? onGoogle : null,
            ),
            if (showApple)
              _OAuthChip(
                label: l10n.socialAuthApple,
                icon: AppIcons.apple,
                iconColor: scheme.onSurface,
                isLoading: appleLoading,
                onPressed: enabled && !appleLoading ? onApple : null,
              ),
            if (showFacebook)
              _OAuthChip(
                label: l10n.socialAuthFacebook,
                icon: AppIcons.facebook,
                iconColor: const Color(0xFF1877F2),
                isLoading: facebookLoading,
                onPressed: enabled && !facebookLoading ? onFacebook : null,
              ),
          ],
        ),
      ],
    );
  }
}

class _OAuthChip extends StatelessWidget {
  const _OAuthChip({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.isLoading,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final Color iconColor;
  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.medium),
            border: Border.all(color: scheme.primary.withValues(alpha: 0.55)),
            color: scheme.surfaceContainerLow.withValues(alpha: 0.65),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.medium,
              vertical: AppSpacing.small,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isLoading)
                  SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: scheme.primary,
                    ),
                  )
                else
                  Icon(icon, color: iconColor, size: 26),
                const SizedBox(width: AppSpacing.small),
                Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
