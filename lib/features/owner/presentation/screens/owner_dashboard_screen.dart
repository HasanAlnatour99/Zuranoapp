import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/user_roles.dart';
import '../../../../core/session/app_session_status.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/adaptive_app_shell.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_fade_in.dart';
import '../../../../core/widgets/app_notification_badge.dart';
import '../../../../core/widgets/app_skeleton.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../providers/app_settings_providers.dart';
import '../../../../providers/notification_providers.dart';
import '../../../../providers/auth_session_actions.dart';
import '../../../../providers/session_provider.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

Future<void> _toggleDashboardLocale(WidgetRef ref) async {
  final loc = ref.read(appLocalePreferenceProvider);
  final next = loc.languageCode == 'ar'
      ? const Locale('en')
      : const Locale('ar');
  await ref.read(appLocalePreferenceProvider.notifier).setLocale(next);
}

class _OwnerAiAssistantAppBarButton extends StatefulWidget {
  const _OwnerAiAssistantAppBarButton({required this.tooltip});

  final String tooltip;

  @override
  State<_OwnerAiAssistantAppBarButton> createState() =>
      _OwnerAiAssistantAppBarButtonState();
}

class _OwnerAiAssistantAppBarButtonState
    extends State<_OwnerAiAssistantAppBarButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scaleController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
  );

  late final Animation<double> _scale = TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween<double>(
        begin: 1,
        end: 0.95,
      ).chain(CurveTween(curve: Curves.easeOut)),
      weight: 42,
    ),
    TweenSequenceItem(
      tween: Tween<double>(
        begin: 0.95,
        end: 1,
      ).chain(CurveTween(curve: Curves.easeOut)),
      weight: 58,
    ),
  ]).animate(_scaleController);

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  Future<void> _onTap(BuildContext context) async {
    await _scaleController.forward(from: 0);
    if (!context.mounted) return;
    await context.push(AppRoutes.ownerDashboardAssistant);
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: ListenableBuilder(
        listenable: _scaleController,
        builder: (context, _) {
          return Transform.scale(
            scale: _scale.value,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF7B61FF), Color(0xFF9F7BFF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF7B61FF).withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  splashColor: Colors.white.withValues(alpha: 0.2),
                  highlightColor: Colors.white.withValues(alpha: 0.08),
                  onTap: () => _onTap(context),
                  child: const Center(
                    child: Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class OwnerDashboardScreen extends ConsumerStatefulWidget {
  const OwnerDashboardScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<OwnerDashboardScreen> createState() =>
      _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends ConsumerState<OwnerDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final sessionState = ref.watch(appSessionBootstrapProvider);
    final sessionAsync = ref.watch(sessionUserProvider);
    if (sessionState.status == AppSessionStatus.unauthenticated) {
      return const Scaffold(body: SizedBox.shrink());
    }
    final l10n = AppLocalizations.of(context)!;
    final resolvedUser = sessionAsync.asData?.value ?? sessionState.user;

    if (kDebugMode) {
      debugPrint(
        '[OwnerDashboard] status=${sessionState.status.name} '
        'bootstrapUser=${sessionState.user?.uid ?? "(null)"} '
        'streamUser=${sessionAsync.asData?.value?.uid ?? "(null)"}',
      );
    }

    if (sessionState.status == AppSessionStatus.initializing &&
        resolvedUser == null &&
        sessionAsync.isLoading) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: const DashboardSkeleton(),
      );
    }

    if (sessionState.status == AppSessionStatus.error && resolvedUser == null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.large),
            child: AppFadeIn(
              child: AppEmptyState(
                title: l10n.ownerWorkspaceWide,
                message: l10n.ownerLoadError,
                icon: AppIcons.cloud_off_outlined,
              ),
            ),
          ),
        ),
      );
    }

    final user = resolvedUser;
    if (user == null) {
      if (kDebugMode) {
        debugPrint(
          '[OwnerDashboard] blocking provider: user unresolved '
          '(sessionUserProvider + appSessionBootstrapProvider)',
        );
      }
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: const DashboardSkeleton(),
      );
    }

    if (user.role == UserRoles.owner &&
        (user.salonId == null || user.salonId!.trim().isEmpty)) {
      return _SalonSetupScaffold(l10n: l10n);
    }

    if (kDebugMode) {
      debugPrint(
        '[OwnerDashboard] dashboard loading false '
        'uid=${user.uid} role=${user.role} salonId=${user.salonId ?? "(null)"}',
      );
    }

    final scheme = Theme.of(context).colorScheme;

    /// Overview, Team, Customers, Finance embed the purple hero in the tab body.
    /// Include More (settings) so the shell AppBar does not stack above
    /// [AppSettingsScreen]'s in-body [ZuranoTopBar].
    final usesOwnerHeroInBody = widget.navigationShell.currentIndex <= 4;

    final destinations = <AdaptiveShellDestination>[
      AdaptiveShellDestination(
        icon: const Icon(AppIcons.dashboard_outlined),
        selectedIcon: const Icon(AppIcons.dashboard),
        label: l10n.ownerTabOverview,
      ),
      AdaptiveShellDestination(
        icon: const Icon(AppIcons.groups_outlined),
        selectedIcon: const Icon(AppIcons.groups),
        label: l10n.ownerTabTeam,
      ),
      AdaptiveShellDestination(
        icon: const Icon(AppIcons.groups_2_outlined),
        selectedIcon: const Icon(AppIcons.groups),
        label: l10n.ownerTabCustomers,
      ),
      AdaptiveShellDestination(
        icon: const Icon(AppIcons.account_balance_wallet_outlined),
        selectedIcon: const Icon(AppIcons.account_balance_wallet),
        label: l10n.ownerTabFinance,
      ),
      AdaptiveShellDestination(
        icon: const Icon(AppIcons.tune),
        selectedIcon: const Icon(AppIcons.tune_rounded),
        label: l10n.ownerShellMore,
      ),
    ];

    final appBarActions = <Widget>[
      _NotificationsButton(l10n: l10n),
      _OwnerAiAssistantAppBarButton(tooltip: l10n.ownerAiAssistantTooltip),
      IconButton(
        tooltip: l10n.appSettingsTitle,
        onPressed: () => context.push(AppRoutes.settings),
        icon: const Icon(AppIcons.settings_outlined),
      ),
      IconButton(
        tooltip: l10n.ownerTooltipLanguageShort,
        onPressed: () => _toggleDashboardLocale(ref),
        icon: const Icon(AppIcons.language_outlined),
      ),
      IconButton(
        tooltip: l10n.ownerTooltipSignOut,
        onPressed: () => performAppSignOut(context),
        icon: const Icon(AppIcons.logout_rounded),
      ),
    ];

    final railActions = <AdaptiveShellRailAction>[
      AdaptiveShellRailAction(
        icon: const Icon(AppIcons.auto_awesome_outlined),
        tooltip: l10n.ownerAiAssistantTooltip,
        onTap: () => context.push(AppRoutes.ownerDashboardAssistant),
      ),
      AdaptiveShellRailAction(
        icon: _NotificationsBadgeIcon(),
        tooltip: l10n.notificationsInboxTooltip,
        onTap: () => context.push(AppRoutes.notifications),
      ),
      AdaptiveShellRailAction(
        icon: const Icon(AppIcons.settings_outlined),
        tooltip: l10n.appSettingsTitle,
        onTap: () => context.push(AppRoutes.settings),
      ),
      AdaptiveShellRailAction(
        icon: const Icon(AppIcons.language_outlined),
        tooltip: l10n.ownerTooltipLanguage,
        onTap: () => _toggleDashboardLocale(ref),
      ),
      AdaptiveShellRailAction(
        icon: const Icon(AppIcons.logout_rounded),
        tooltip: l10n.ownerTooltipSignOut,
        onTap: () => performAppSignOut(context),
        color: scheme.onSurfaceVariant,
      ),
    ];

    return AdaptiveAppShell(
      destinations: destinations,
      selectedIndex: widget.navigationShell.currentIndex,
      onDestinationSelected: (i) {
        widget.navigationShell.goBranch(
          i,
          initialLocation: i == widget.navigationShell.currentIndex,
        );
      },
      appBarTitle: usesOwnerHeroInBody ? null : Text(l10n.ownerDashboardTitle),
      appBarActions: usesOwnerHeroInBody ? const <Widget>[] : appBarActions,
      railLeading: Icon(
        AppIcons.content_cut_rounded,
        color: scheme.primary,
        size: 28,
      ),
      railActions: railActions,
      body: widget.navigationShell,
    );
  }
}

class _NotificationsButton extends ConsumerWidget {
  const _NotificationsButton({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final n = ref.watch(unreadNotificationCountProvider);
    return IconButton(
      tooltip: l10n.notificationsInboxTooltip,
      onPressed: () => context.push(AppRoutes.notifications),
      icon: AppNotificationBadge(
        count: n,
        child: const Icon(AppIcons.notifications_outlined),
      ),
    );
  }
}

class _NotificationsBadgeIcon extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final n = ref.watch(unreadNotificationCountProvider);
    return AppNotificationBadge(
      count: n,
      child: const Icon(AppIcons.notifications_outlined),
    );
  }
}

class _SalonSetupScaffold extends StatelessWidget {
  const _SalonSetupScaffold({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.large),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.ownerSalonSetupTitle,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.medium),
              Text(l10n.ownerSalonSetupMessage, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.large),
              FilledButton(
                onPressed: () => context.go(AppRoutes.createSalon),
                child: Text(l10n.ownerSalonSetupCta),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
