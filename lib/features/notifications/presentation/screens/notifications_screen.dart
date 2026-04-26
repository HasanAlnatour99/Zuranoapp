import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_bar_leading_back.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_fade_in.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../providers/notification_providers.dart';
import '../../../../providers/repository_providers.dart';
import '../../../../providers/session_provider.dart';
import '../../logic/notification_router.dart';
import '../widgets/notification_tile.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final async = ref.watch(userNotificationsStreamProvider);
    final session = ref.watch(sessionUserProvider).asData?.value;
    final router = GoRouter.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: const AppBarLeadingBack(),
        automaticallyImplyLeading: false,
        title: Text(l10n.notificationsCenterTitle),
        actions: [
          IconButton(
            tooltip: l10n.notificationsPreferencesTooltip,
            onPressed: () => context.push(AppRoutes.notificationPreferences),
            icon: const Icon(AppIcons.settings_outlined),
          ),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: AppLoadingIndicator(size: 40)),
        error: (_, _) => AppFadeIn(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.large),
              child: AppEmptyState(
                title: l10n.notificationsCenterTitle,
                message: l10n.genericError,
                icon: AppIcons.cloud_off_outlined,
              ),
            ),
          ),
        ),
        data: (items) {
          if (items.isEmpty) {
            return AppFadeIn(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.large),
                  child: AppEmptyState(
                    title: l10n.notificationsCenterTitle,
                    message: l10n.notificationsEmpty,
                    icon: AppIcons.notifications_none_outlined,
                  ),
                ),
              ),
            );
          }
          return AppFadeIn(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.large,
                vertical: AppSpacing.small,
              ),
              itemCount: items.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final item = items[i];
                return NotificationTile(
                  item: item,
                  onTap: () async {
                    final uid = FirebaseAuth.instance.currentUser?.uid;
                    if (uid != null && item.isUnread) {
                      await ref
                          .read(notificationRepositoryProvider)
                          .markNotificationRead(
                            uid: uid,
                            notificationId: item.id,
                          );
                    }
                    if (!context.mounted) {
                      return;
                    }
                    navigateForNotificationPayload(
                      router: router,
                      data: item.data,
                      session: session,
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
