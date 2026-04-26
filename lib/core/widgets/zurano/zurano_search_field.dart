import 'package:flutter/material.dart';

import '../../theme/zurano_tokens.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

class ZuranoSearchField extends StatelessWidget {
  const ZuranoSearchField({
    super.key,
    required this.controller,
    this.hintText,
    this.onChanged,
    this.suffix,
  });

  final TextEditingController controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        textInputAction: TextInputAction.search,
        style: const TextStyle(
          fontSize: 16,
          color: ZuranoTokens.textDark,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: ZuranoTokens.textGray.withValues(alpha: 0.85),
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: const Icon(
            AppIcons.search_rounded,
            color: ZuranoTokens.textGray,
            size: 22,
          ),
          suffixIcon: suffix,
          filled: true,
          fillColor: ZuranoTokens.searchFill,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 6,
            vertical: 0,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ZuranoTokens.radiusSearch),
            borderSide: const BorderSide(color: ZuranoTokens.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ZuranoTokens.radiusSearch),
            borderSide: const BorderSide(color: ZuranoTokens.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ZuranoTokens.radiusSearch),
            borderSide: const BorderSide(
              color: ZuranoTokens.primary,
              width: 1.3,
            ),
          ),
        ),
      ),
    );
  }
}
