import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import 'zurano_icon_box.dart';

/// White card wrapping vertical [children] (typically [SettingsOptionTile]s).
class AppSettingsActionsCard extends StatelessWidget {
  const AppSettingsActionsCard({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      if (i > 0) {
        rows.add(const Divider(height: 1, color: ZuranoPremiumUiColors.border));
      }
      rows.add(children[i]);
    }
    return Container(
      decoration: BoxDecoration(
        color: ZuranoPremiumUiColors.cardBackground,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: ZuranoPremiumUiColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F111827),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(children: rows),
    );
  }
}

class SettingsOptionTile extends StatelessWidget {
  const SettingsOptionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.danger = false,
    this.showChevron = true,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool danger;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fg = danger
        ? ZuranoPremiumUiColors.danger
        : ZuranoPremiumUiColors.textPrimary;
    final subFg = danger
        ? ZuranoPremiumUiColors.danger.withValues(alpha: 0.88)
        : ZuranoPremiumUiColors.textSecondary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 44),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (danger)
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: ZuranoPremiumUiColors.dangerSoft,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: fg, size: 22),
                  )
                else
                  ZuranoIconBox(icon: icon, size: 42, iconSize: 22),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: fg,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: subFg,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                if (showChevron)
                  Icon(
                    Icons.chevron_right_rounded,
                    color: ZuranoPremiumUiColors.textSecondary,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
