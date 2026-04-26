import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

/// Filled search field for the country picker (Zurano soft purple fill).
class CountrySearchField extends StatelessWidget {
  const CountrySearchField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  static const _fill = Color(0xFFF5F3FF);
  static const _border = Color(0xFFE5E1EC);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return TextField(
      controller: controller,
      onChanged: onChanged,
      autocorrect: false,
      enableSuggestions: false,
      textInputAction: TextInputAction.search,
      cursorColor: AppBrandColorsPremium.primary,
      decoration: InputDecoration(
        filled: true,
        fillColor: _fill,
        hintText: l10n.onboardingSearchCountryHint,
        hintStyle: TextStyle(
          color: AppBrandColorsPremium.primary.withValues(alpha: 0.45),
        ),
        prefixIcon: Icon(
          Icons.search_rounded,
          color: AppBrandColorsPremium.primary.withValues(alpha: 0.45),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(19),
          borderSide: BorderSide(color: _border.withValues(alpha: 0.65)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(19),
          borderSide: BorderSide(color: _border.withValues(alpha: 0.65)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(19),
          borderSide: BorderSide(
            color: AppBrandColorsPremium.primary.withValues(alpha: 0.35),
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
