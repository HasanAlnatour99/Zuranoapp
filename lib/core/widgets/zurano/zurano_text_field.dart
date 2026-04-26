import 'package:flutter/material.dart';

import '../../theme/zurano_tokens.dart';

class ZuranoTextField extends StatelessWidget {
  const ZuranoTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.requiredField = false,
    this.keyboardType,
    this.maxLines = 1,
    this.maxLength,
    this.suffix,
    this.validator,
    this.onChanged,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final bool requiredField;
  final TextInputType? keyboardType;
  final int maxLines;
  final int? maxLength;
  final Widget? suffix;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final showLabel = label.trim().isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel) ...[
          RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(
                color: ZuranoTokens.textDark,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              children: [
                if (requiredField)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(color: Color(0xFFE11D48)),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          maxLength: maxLength,
          validator: validator,
          onChanged: onChanged,
          enabled: enabled,
          style: const TextStyle(
            color: ZuranoTokens.textDark,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: ZuranoTokens.textGray.withValues(alpha: 0.9),
              fontWeight: FontWeight.w400,
            ),
            suffixIcon: suffix == null
                ? null
                : Padding(
                    padding: const EdgeInsetsDirectional.only(end: 12),
                    child: Center(
                      widthFactor: 1,
                      heightFactor: 1,
                      child: suffix,
                    ),
                  ),
            suffixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
            counterStyle: const TextStyle(
              color: ZuranoTokens.textGray,
              fontSize: 12,
            ),
            filled: true,
            fillColor: ZuranoTokens.inputFill,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 18,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ZuranoTokens.radiusInput),
              borderSide: const BorderSide(color: ZuranoTokens.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ZuranoTokens.radiusInput),
              borderSide: const BorderSide(color: ZuranoTokens.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ZuranoTokens.radiusInput),
              borderSide: const BorderSide(
                color: ZuranoTokens.primary,
                width: 1.4,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(ZuranoTokens.radiusInput),
              borderSide: BorderSide(
                color: ZuranoTokens.border.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
