import 'package:flutter/material.dart';

import '../../../../core/widgets/social_button.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

enum AuthSocialProvider { google, apple, facebook }

class AuthSocialButton extends StatelessWidget {
  const AuthSocialButton({
    super.key,
    required this.provider,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.enabled = true,
  });

  final AuthSocialProvider provider;
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final icon = switch (provider) {
      AuthSocialProvider.google => const Icon(
        AppIcons.g_mobiledata_rounded,
        color: Color(0xFF4285F4),
        size: 24,
      ),
      AuthSocialProvider.apple => const Icon(
        AppIcons.apple,
        color: Color(0xFF000000),
        size: 22,
      ),
      AuthSocialProvider.facebook => const Icon(
        AppIcons.facebook,
        color: Color(0xFF1877F2),
        size: 22,
      ),
    };

    return SocialButton(
      icon: icon,
      text: label,
      onPressed: onPressed,
      isLoading: isLoading,
      enabled: enabled,
    );
  }
}
