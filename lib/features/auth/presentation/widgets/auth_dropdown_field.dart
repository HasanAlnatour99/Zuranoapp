import 'package:flutter/material.dart';

import '../../../../core/theme/auth_premium_tokens.dart';

class AuthDropdownField<T> extends StatelessWidget {
  const AuthDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.itemLabel,
    this.onChanged,
    this.hint,
    this.enabled = true,
  });

  final String label;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T?>? onChanged;
  final String? hint;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: AuthPremiumColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        // Controlled selection; `value` remains the correct API for DropdownButtonFormField.
        DropdownButtonFormField<T>(
          // ignore: deprecated_member_use
          value: value,
          isExpanded: true,
          hint: hint != null
              ? Text(
                  hint!,
                  style: const TextStyle(
                    color: AuthPremiumColors.textSecondary,
                  ),
                )
              : null,
          borderRadius: BorderRadius.circular(AuthPremiumLayout.fieldRadius),
          dropdownColor: AuthPremiumColors.surfaceElevated,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: AuthPremiumColors.textPrimary,
          ),
          iconEnabledColor: AuthPremiumColors.textSecondary,
          decoration: InputDecoration(
            filled: true,
            fillColor: AuthPremiumColors.surfaceElevated,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AuthPremiumLayout.fieldRadius,
              ),
              borderSide: const BorderSide(color: AuthPremiumColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AuthPremiumLayout.fieldRadius,
              ),
              borderSide: const BorderSide(color: AuthPremiumColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AuthPremiumLayout.fieldRadius,
              ),
              borderSide: const BorderSide(
                color: AuthPremiumColors.accent,
                width: 1.5,
              ),
            ),
          ),
          items: items
              .map(
                (e) => DropdownMenuItem<T>(value: e, child: Text(itemLabel(e))),
              )
              .toList(),
          onChanged: enabled ? onChanged : null,
        ),
      ],
    );
  }
}
