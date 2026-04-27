import 'package:flutter/material.dart';

import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

/// Discovery home search field — theme-driven, RTL-safe, production spacing.
class CustomerDiscoverySearchField extends StatelessWidget {
  const CustomerDiscoverySearchField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(
          AppIcons.search_rounded,
          color: scheme.onSurfaceVariant,
        ),
        filled: true,
        fillColor: scheme.surface.withValues(alpha: 0.96),
        contentPadding: const EdgeInsets.symmetric(
          vertical: AppSpacing.medium,
          horizontal: AppSpacing.small,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.xlarge),
          borderSide: BorderSide(color: scheme.outline.withValues(alpha: 0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.xlarge),
          borderSide: BorderSide(color: scheme.outline.withValues(alpha: 0.16)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.xlarge),
          borderSide: BorderSide(color: scheme.primary, width: 1.5),
        ),
      ),
    );
  }
}
