import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/user_roles.dart';
import '../../../../core/debug/agent_session_log.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../providers/onboarding_providers.dart';
import '../../../../providers/session_provider.dart';
import '../../logic/role_selection_controller.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/auth_startup_portal_card.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

class UserSelectionScreen extends ConsumerStatefulWidget {
  const UserSelectionScreen({super.key});

  @override
  ConsumerState<UserSelectionScreen> createState() =>
      _UserSelectionScreenState();
}

class _UserSelectionScreenState extends ConsumerState<UserSelectionScreen>
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

  Future<void> _onCustomer(BuildContext context) async {
    await ref
        .read(onboardingPrefsProvider.notifier)
        .setSelectedAuthRole(UserRoles.customer);
    if (!context.mounted) return;
    final session = ref.read(sessionUserProvider).asData?.value;
    if (session != null && UserRoles.needsRoleSelection(session.role)) {
      final ok = await ref
          .read(roleSelectionControllerProvider.notifier)
          .selectRole(UserRoles.customer);
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
    context.go(AppRoutes.customerOnboarding);
  }

  Future<void> _onStaff(BuildContext context) async {
    agentSessionLog(
      hypothesisId: 'S1',
      location: 'user_selection_screen.dart:_onStaff',
      message: 'staff_portal_tap',
      data: const <String, Object?>{},
      runId: 'startup-router-debug',
    );
    await ref.read(onboardingPrefsProvider.notifier).setPreAuthStaffLogin();
    if (!context.mounted) return;
    final session = ref.read(sessionUserProvider).asData?.value;
    if (session != null && UserRoles.needsRoleSelection(session.role)) {
      final ok = await ref
          .read(roleSelectionControllerProvider.notifier)
          .selectRole(UserRoles.employee);
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
    context.go(AppRoutes.staffLogin);
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
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: IconButton(
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go(AppRoutes.roleSelection);
                    }
                  },
                  icon: const Icon(Icons.arrow_back_rounded),
                  tooltip: l10n.authCommonBack,
                ),
              ),
              const SizedBox(height: AppSpacing.small),
              Text(
                l10n.userSelectionContinueTitle,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                l10n.userSelectionContinueSubtitle,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: scheme.onSurfaceVariant,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: AppSpacing.xlarge),
              AuthStartupPortalCard(
                emphasized: true,
                title: l10n.userSelectionCustomerTitle,
                subtitle: l10n.userSelectionCustomerSubtitle,
                icon: AppIcons.calendar_month_outlined,
                onTap: () => _onCustomer(context),
              ),
              const SizedBox(height: AppSpacing.medium),
              AuthStartupPortalCard(
                title: l10n.userSelectionStaffTitle,
                subtitle: l10n.userSelectionStaffSubtitle,
                icon: AppIcons.badge_outlined,
                onTap: () => _onStaff(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
