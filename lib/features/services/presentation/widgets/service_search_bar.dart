import 'package:flutter/material.dart';

import '../../../../core/theme/zurano_tokens.dart';
import '../../../../core/ui/app_icons.dart';
import '../../../../core/widgets/zurano/zurano_search_field.dart';

/// Compact search field for the owner services catalog.
class ServiceSearchBar extends StatelessWidget {
  const ServiceSearchBar({
    super.key,
    required this.controller,
    required this.hintText,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        return ZuranoSearchField(
          controller: controller,
          hintText: hintText,
          onChanged: onChanged,
          suffix: value.text.isEmpty
              ? null
              : IconButton(
                  tooltip: MaterialLocalizations.of(
                    context,
                  ).deleteButtonTooltip,
                  onPressed: () {
                    controller.clear();
                    onChanged?.call('');
                  },
                  icon: const Icon(
                    AppIcons.close_rounded,
                    color: ZuranoTokens.textGray,
                    size: 22,
                  ),
                ),
        );
      },
    );
  }
}
