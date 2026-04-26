import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../../core/widgets/social_button.dart';

/// Single full-width social row — delegates to [SocialButton].
class AuthSignupSocialButton extends StatelessWidget {
  const AuthSignupSocialButton({
    super.key,
    required this.label,
    required this.leading,
    required this.onTap,
    this.isLoading = false,
    this.enabled = true,
  });

  final String label;
  final Widget leading;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return SocialButton(
      icon: leading,
      text: label,
      onPressed: onTap,
      isLoading: isLoading,
      enabled: enabled,
    );
  }
}

/// Vertical stack of social providers with platform gating (matches login behavior).
class AuthSignupSocialColumn extends StatelessWidget {
  const AuthSignupSocialColumn({
    super.key,
    required this.googleLabel,
    required this.appleLabel,
    required this.facebookLabel,
    required this.onGoogle,
    required this.onApple,
    required this.onFacebook,
    required this.googleLoading,
    required this.appleLoading,
    required this.facebookLoading,
    required this.enabled,
    required this.googleLeading,
    required this.appleLeading,
    required this.facebookLeading,
  });

  final String googleLabel;
  final String appleLabel;
  final String facebookLabel;
  final VoidCallback? onGoogle;
  final VoidCallback? onApple;
  final VoidCallback? onFacebook;
  final bool googleLoading;
  final bool appleLoading;
  final bool facebookLoading;
  final bool enabled;
  final Widget googleLeading;
  final Widget appleLeading;
  final Widget facebookLeading;

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthSignupSocialButton(
          label: googleLabel,
          leading: googleLeading,
          enabled: enabled,
          isLoading: googleLoading,
          onTap: onGoogle,
        ),
        if (_showApple) ...[
          const SizedBox(height: 12),
          AuthSignupSocialButton(
            label: appleLabel,
            leading: appleLeading,
            enabled: enabled,
            isLoading: appleLoading,
            onTap: onApple,
          ),
        ],
        if (_showFacebook) ...[
          const SizedBox(height: 12),
          AuthSignupSocialButton(
            label: facebookLabel,
            leading: facebookLeading,
            enabled: enabled,
            isLoading: facebookLoading,
            onTap: onFacebook,
          ),
        ],
      ],
    );
  }
}
