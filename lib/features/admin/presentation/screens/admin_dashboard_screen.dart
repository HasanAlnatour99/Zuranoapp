import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_bar_leading_back.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_fade_in.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/app_notification_badge.dart';
import '../../../../core/widgets/app_surface_card.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../providers/notification_providers.dart';
import '../../../../providers/auth_session_actions.dart';
import '../../../../providers/session_provider.dart';
import '../../../owner/presentation/widgets/owner_violations_module.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = ref.watch(sessionUserProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return sessionAsync.when(
      loading: () => Scaffold(
        body: Center(
          child: AppLoadingIndicator(
            size: 40,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      error: (Object error, StackTrace stack) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.large),
            child: AppEmptyState(
              title: l10n.adminConsoleTitle,
              message: l10n.ownerLoadError,
              icon: AppIcons.cloud_off_outlined,
            ),
          ),
        ),
      ),
      data: (user) {
        if (user == null) {
          return const Scaffold(body: SizedBox.shrink());
        }

        final sid = user.salonId?.trim();
        final salonLine = (sid != null && sid.isNotEmpty)
            ? l10n.adminSalonIdLine(sid)
            : l10n.adminSalonNotLinked;

        return Scaffold(
          appBar: AppBar(
            leading: const AppBarLeadingBack(),
            automaticallyImplyLeading: false,
            title: Text(l10n.adminConsoleTitle),
            actions: [
              IconButton(
                tooltip: l10n.appSettingsTitle,
                onPressed: () => context.push(AppRoutes.settings),
                icon: const Icon(AppIcons.settings_outlined),
              ),
              IconButton(
                tooltip: l10n.notificationsInboxTooltip,
                onPressed: () => context.push(AppRoutes.notifications),
                icon: Builder(
                  builder: (context) {
                    final n = ref.watch(unreadNotificationCountProvider);
                    return AppNotificationBadge(
                      count: n,
                      child: const Icon(AppIcons.notifications_outlined),
                    );
                  },
                ),
              ),
              TextButton(
                onPressed: () => performAppSignOut(context),
                child: Text(
                  l10n.customerSignOut,
                  style: TextStyle(color: scheme.primary),
                ),
              ),
            ],
          ),
          body: AppFadeIn(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.large),
              children: [
                AppSurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        user.name.isNotEmpty ? user.name : l10n.roleAdmin,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.small),
                      Text(
                        salonLine,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.medium),
                      Text(
                        l10n.adminWorkspaceSubtitle,
                        style: theme.textTheme.bodyLarge?.copyWith(height: 1.5),
                      ),
                    ],
                  ),
                ),
                if (sid != null && sid.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.large),
                  OwnerViolationsModule(salonId: sid),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
