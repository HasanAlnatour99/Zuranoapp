import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_surface_card.dart';
import '../../../../core/widgets/app_text_field.dart';

class AiChatInput extends StatelessWidget {
  const AiChatInput({
    required this.controller,
    required this.label,
    required this.hintText,
    required this.sendLabel,
    required this.onSend,
    required this.isLoading,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final String hintText;
  final String sendLabel;
  final VoidCallback onSend;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      showShadow: false,
      padding: const EdgeInsets.all(AppSpacing.medium),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextField(
            label: label,
            controller: controller,
            hintText: hintText,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.send,
            maxLines: 3,
          ),
          const SizedBox(height: AppSpacing.medium),
          AppPrimaryButton(
            label: sendLabel,
            isLoading: isLoading,
            onPressed: onSend,
          ),
        ],
      ),
    );
  }
}
