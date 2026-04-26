import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/user_roles.dart';
import '../../../../core/debug/agent_session_log.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../providers/firebase_providers.dart';
import '../../../../providers/onboarding_providers.dart';
import '../../../../providers/session_provider.dart';
import '../../logic/role_selection_controller.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_startup_portal_card.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

class RoleSelectionScreen extends ConsumerStatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  ConsumerState<RoleSelectionScreen> createState() =>
      _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends ConsumerState<RoleSelectionScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _fade = CurvedAnimation(parent: _entrance, curve: Curves.easeOutCubic);
    _entrance.forward();
  }

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  Future<void> _onBookOrAccess(BuildContext context) async {
    context.go(AppRoutes.userSelection);
  }

  Future<void> _onManageSalon(BuildContext context) async {
    agentSessionLog(
      hypothesisId: 'S1',
      location: 'role_selection_screen.dart:_onManageSalon',
      message: 'owner_portal_tap',
      data: const <String, Object?>{},
      runId: 'startup-router-debug',
    );
    await ref
        .read(onboardingPrefsProvider.notifier)
        .setSelectedAuthRole(UserRoles.owner);
    if (!context.mounted) return;

    final authUid = ref.read(firebaseAuthProvider).currentUser?.uid;
    if (authUid == null) {
      context.go(AppRoutes.ownerLogin);
      return;
    }

    final session = ref.read(sessionUserProvider).asData?.value;
    if (session != null && UserRoles.needsRoleSelection(session.role)) {
      final ok = await ref
          .read(roleSelectionControllerProvider.notifier)
          .selectRole(UserRoles.owner);
      if (!context.mounted) return;
      if (!ok) {
        final err = ref.read(roleSelectionControllerProvider).error;
        if (err != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(err)));
        }
        return;
      }
      context.go(AppRoutes.splash);
      return;
    }

    if (session != null && session.role == UserRoles.owner) {
      final hasSalon =
          session.salonId != null && session.salonId!.trim().isNotEmpty;
      if (!context.mounted) return;
      context.go(hasSalon ? AppRoutes.ownerOverview : AppRoutes.createSalon);
      return;
    }

    if (!context.mounted) return;
    context.go(AppRoutes.ownerLogin);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.surface,
            Color.lerp(scheme.surface, scheme.primaryContainer, 0.35)!,
            Color.lerp(scheme.surface, scheme.secondaryContainer, 0.12)!,
          ],
        ),
      ),
      child: FadeTransition(
        opacity: _fade,
        child: AuthScaffold(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.startupEntryTitle,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                l10n.startupEntrySubtitle,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: scheme.onSurfaceVariant,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: AppSpacing.xlarge),
              AuthStartupPortalCard(
                emphasized: true,
                title: l10n.startupBookOrAccessTitle,
                subtitle: l10n.startupBookOrAccessSubtitle,
                icon: AppIcons.auto_awesome_outlined,
                onTap: () => _onBookOrAccess(context),
              ),
              const SizedBox(height: AppSpacing.medium),
              AuthStartupPortalCard(
                title: l10n.startupManageSalonTitle,
                subtitle: l10n.startupManageSalonSubtitle,
                icon: AppIcons.storefront_outlined,
                onTap: () => _onManageSalon(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
