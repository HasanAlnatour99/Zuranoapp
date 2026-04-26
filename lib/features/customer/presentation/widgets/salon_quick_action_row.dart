import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

class SalonQuickActionRow extends StatelessWidget {
  const SalonQuickActionRow({
    super.key,
    required this.onCall,
    required this.onWhatsApp,
    required this.onMap,
    required this.onShare,
    required this.callLabel,
    required this.whatsappLabel,
    required this.mapLabel,
    required this.shareLabel,
  });

  final VoidCallback onCall;
  final VoidCallback onWhatsApp;
  final VoidCallback onMap;
  final VoidCallback onShare;
  final String callLabel;
  final String whatsappLabel;
  final String mapLabel;
  final String shareLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.large),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ActionDisc(
            icon: Icons.call_outlined,
            label: callLabel,
            onTap: onCall,
          ),
          _ActionDisc(
            icon: Icons.chat_outlined,
            label: whatsappLabel,
            onTap: onWhatsApp,
          ),
          _ActionDisc(icon: Icons.map_outlined, label: mapLabel, onTap: onMap),
          _ActionDisc(
            icon: Icons.ios_share_rounded,
            label: shareLabel,
            onTap: onShare,
          ),
        ],
      ),
    );
  }
}

class _ActionDisc extends StatelessWidget {
  const _ActionDisc({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.large),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.small),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.surface,
                border: Border.all(
                  color: AppBrandColors.primary.withValues(alpha: 0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: AppBrandColors.primary),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColorsLight.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
