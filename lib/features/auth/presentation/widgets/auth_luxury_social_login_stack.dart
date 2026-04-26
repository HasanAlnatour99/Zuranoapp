import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/social_button.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

/// Full-width OAuth rows (white surface, light border, brand-colored icons).
class AuthLuxurySocialLoginStack extends StatelessWidget {
  const AuthLuxurySocialLoginStack({
    super.key,
    required this.onGoogle,
    required this.onApple,
    required this.onFacebook,
    required this.googleLoading,
    required this.appleLoading,
    required this.facebookLoading,
    required this.enabled,
  });

  final VoidCallback? onGoogle;
  final VoidCallback? onApple;
  final VoidCallback? onFacebook;
  final bool googleLoading;
  final bool appleLoading;
  final bool facebookLoading;
  final bool enabled;

  static bool get _showApple {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS;
  }

  static bool get _showFacebook {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SocialButton(
          icon: const Icon(
            AppIcons.g_mobiledata_rounded,
            color: Color(0xFF4285F4),
            size: 24,
          ),
          text: l10n.authV2ContinueGoogle,
          onPressed: onGoogle,
          isLoading: googleLoading,
          enabled: enabled,
        ),
        if (_showApple) ...[
          const SizedBox(height: 12),
          SocialButton(
            icon: const Icon(
              AppIcons.apple,
              color: Color(0xFF000000),
              size: 22,
            ),
            text: l10n.authV2ContinueApple,
            onPressed: onApple,
            isLoading: appleLoading,
            enabled: enabled,
          ),
        ],
        if (_showFacebook) ...[
          const SizedBox(height: 12),
          SocialButton(
            icon: const Icon(
              AppIcons.facebook,
              color: Color(0xFF1877F2),
              size: 22,
            ),
            text: l10n.authV2ContinueFacebook,
            onPressed: onFacebook,
            isLoading: facebookLoading,
            enabled: enabled,
          ),
        ],
      ],
    );
  }
}
