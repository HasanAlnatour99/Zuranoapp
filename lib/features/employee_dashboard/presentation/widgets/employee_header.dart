import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_notification_badge.dart';
import '../../../../features/settings/presentation/utils/zurano_sign_out_dialog.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../providers/notification_providers.dart';

class EmployeeHeader extends ConsumerWidget {
  const EmployeeHeader({super.key, required this.displayName, this.photoUrl});

  final String displayName;
  final String? photoUrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final unread = ref.watch(unreadNotificationCountProvider);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 12, 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: ZuranoPremiumUiColors.softPurple,
            backgroundImage: photoUrl != null && photoUrl!.trim().isNotEmpty
                ? NetworkImage(photoUrl!)
                : null,
            child: photoUrl == null || photoUrl!.trim().isEmpty
                ? Text(
                    displayName.isNotEmpty ? displayName[0].toUpperCase() : '?',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: ZuranoPremiumUiColors.primaryPurple,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: ZuranoPremiumUiColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.employeeTodayWorkspaceSubtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: ZuranoPremiumUiColors.textSecondary.withValues(
                      alpha: 0.95,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: l10n.authCommonSettings,
            onPressed: () => context.push(AppRoutes.settings),
            icon: const Icon(Icons.settings_outlined),
            color: ZuranoPremiumUiColors.textSecondary,
          ),
          AppNotificationBadge(
            count: unread,
            child: IconButton(
              tooltip: l10n.customerNotificationsTooltip,
              onPressed: () => context.push(AppRoutes.notifications),
              icon: const Icon(Icons.notifications_none_rounded),
              color: ZuranoPremiumUiColors.textSecondary,
            ),
          ),
          TextButton(
            onPressed: () => showZuranoSignOutConfirmDialog(context),
            child: Text(
              l10n.customerSignOut,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: ZuranoPremiumUiColors.primaryPurple,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
