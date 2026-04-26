import 'package:flutter/material.dart';

import 'app_button.dart';

/// Full-width primary CTA — uses [AppButton] with gradient styling.
class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.size = AppButtonSize.large,
    this.leadingIcon,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final AppButtonSize size;
  final IconData? leadingIcon;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: label,
      onPressed: onPressed,
      type: AppButtonType.primary,
      size: size,
      isLoading: isLoading,
      isDisabled: isDisabled,
      leadingIcon: leadingIcon,
    );
  }
}
