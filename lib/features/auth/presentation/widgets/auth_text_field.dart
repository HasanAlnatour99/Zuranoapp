import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/auth_premium_tokens.dart';

/// Filled field for auth flows (matches premium dark inputs).
class AuthAppTextField extends StatelessWidget {
  const AuthAppTextField({
    super.key,
    this.controller,
    this.label,
    this.hintText,
    this.errorText,
    this.helperText,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.onChanged,
    this.focusNode,
    this.inputFormatters,
    this.autocorrect = true,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final String? errorText;
  final String? helperText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final bool autocorrect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: theme.textTheme.labelLarge?.copyWith(
              color: AuthPremiumColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextField(
          controller: controller,
          focusNode: focusNode,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          autofillHints: autofillHints,
          enabled: enabled,
          autocorrect: autocorrect,
          onChanged: onChanged,
          inputFormatters: inputFormatters,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: AuthPremiumColors.textPrimary,
          ),
          cursorColor: AuthPremiumColors.accent,
          decoration: InputDecoration(
            filled: true,
            fillColor: AuthPremiumColors.inputFill,
            hintText: hintText,
            hintStyle: const TextStyle(color: AuthPremiumColors.textSecondary),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            errorText: errorText,
            helperText: helperText,
            helperStyle: const TextStyle(
              color: AuthPremiumColors.textSecondary,
            ),
            errorStyle: theme.textTheme.bodySmall?.copyWith(
              color: AuthPremiumColors.error,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AuthPremiumLayout.fieldRadius,
              ),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AuthPremiumLayout.fieldRadius,
              ),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AuthPremiumLayout.fieldRadius,
              ),
              borderSide: BorderSide(
                color: AuthPremiumColors.accent.withValues(alpha: 0.55),
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AuthPremiumLayout.fieldRadius,
              ),
              borderSide: const BorderSide(color: AuthPremiumColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AuthPremiumLayout.fieldRadius,
              ),
              borderSide: const BorderSide(color: AuthPremiumColors.error),
            ),
          ),
        ),
      ],
    );
  }
}
