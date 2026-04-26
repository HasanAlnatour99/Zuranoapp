import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../data/notification_model.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({super.key, required this.item, required this.onTap});

  final AppNotificationItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.medium,
        vertical: AppSpacing.small,
      ),
      onTap: onTap,
      leading: Icon(
        item.isUnread
            ? AppIcons.mark_email_unread_outlined
            : AppIcons.mark_email_read_outlined,
        color: item.isUnread ? scheme.primary : scheme.onSurfaceVariant,
      ),
      title: Text(
        item.title,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: item.isUnread ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
      subtitle: Text(
        item.body,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodySmall?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
