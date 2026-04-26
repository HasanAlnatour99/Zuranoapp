import 'package:flutter/material.dart';

import '../../theme/zurano_tokens.dart';
import 'zurano_gradient_button.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

class ZuranoEmptyState extends StatelessWidget {
  const ZuranoEmptyState({
    super.key,
    required this.title,
    required this.description,
    required this.primaryLabel,
    required this.onPrimary,
    this.icon = Icons.chair_alt_outlined,
    this.showPrimaryButton = true,
  });

  final String title;
  final String description;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final IconData icon;
  final bool showPrimaryButton;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ZuranoTokens.lightPurple,
              boxShadow: [
                BoxShadow(
                  color: ZuranoTokens.primary.withValues(alpha: 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 52,
              color: ZuranoTokens.primary.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 22),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: ZuranoTokens.textDark,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              color: ZuranoTokens.textGray,
              height: 1.45,
            ),
          ),
          if (showPrimaryButton) ...[
            const SizedBox(height: 22),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: ZuranoGradientButton(
                label: primaryLabel,
                icon: AppIcons.add_rounded,
                onPressed: onPrimary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
