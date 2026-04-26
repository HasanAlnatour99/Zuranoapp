import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/user_roles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_submit_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/widgets/luxury_auth_theme.dart';
import '../../../../core/widgets/app_onboarding_scaffold.dart';
import '../../../../core/widgets/app_inline_message.dart';
import '../../../../providers/auth_session_actions.dart';
import '../../../../providers/firebase_providers.dart';
import '../../../../providers/repository_providers.dart';
import '../../../../providers/session_provider.dart';
import '../../../../router/router_session_refresh.dart';
import '../../../../core/utils/firebase_error_message.dart';
import '../../../../core/ui/app_icons.dart';
import '../../../../core/boot/app_boot_log.dart';
import '../../../../core/debug/agent_session_log.dart';
import '../widgets/auth_selection_card.dart';

class FirstTimeRoleSelectionScreen extends ConsumerStatefulWidget {
  const FirstTimeRoleSelectionScreen({super.key});

  @override
  ConsumerState<FirstTimeRoleSelectionScreen> createState() =>
      _FirstTimeRoleSelectionScreenState();
}

class _FirstTimeRoleSelectionScreenState
    extends ConsumerState<FirstTimeRoleSelectionScreen> {
  String? _selectedRole;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _onContinue() async {
    if (_selectedRole == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      AppBootLog.session('role_selection_save_begin', {
        'selectedRole': _selectedRole,
        'source': 'first_time_role_selection_screen',
      });
      agentSessionLog(
        hypothesisId: 'S1',
        location: 'first_time_role_selection_screen.dart:_onContinue',
        message: 'role_save_start',
        data: <String, Object?>{
          'targetRole': _selectedRole,
          'uid': ref.read(firebaseAuthProvider).currentUser?.uid,
        },
        runId: 'startup-router-debug',
      );
      await ref
          .read(completeProfileAfterSocialLoginUseCaseProvider)
          .call(role: _selectedRole!);
      agentSessionLog(
        hypothesisId: 'S1',
        location: 'first_time_role_selection_screen.dart:_onContinue',
        message: 'role_save_end',
        data: <String, Object?>{'targetRole': _selectedRole, 'ok': true},
        runId: 'startup-router-debug',
      );

      ref.invalidate(appEntrySessionProvider);
      refreshRouterAfterAuthChange(ref);
    } catch (e) {
      agentSessionLog(
        hypothesisId: 'S1',
        location: 'first_time_role_selection_screen.dart:_onContinue',
        message: 'role_save_end',
        data: <String, Object?>{
          'targetRole': _selectedRole,
          'ok': false,
          'error': e.toString(),
        },
        runId: 'startup-router-debug',
      );
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = FirebaseErrorMessage.fromException(e);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    final viewInsets = MediaQuery.viewInsetsOf(context);

    return LuxuryAuthTheme(
      child: AppOnboardingScaffold(
        centeredViewportLayout: true,
        scrollPadding: EdgeInsets.fromLTRB(
          AppSpacing.medium,
          AppSpacing.medium,
          AppSpacing.medium,
          AppSpacing.medium + viewInsets.bottom,
        ),
        bodyContainerPadding: const EdgeInsets.all(AppSpacing.medium),
        eyebrow: l10n.firstTimeRoleEyebrow,
        title: l10n.firstTimeRoleTitle,
        description: l10n.firstTimeRoleDescription,
        onboardingStep: 1,
        onboardingTotalSteps: 1,
        footer: Center(
          child: TextButton(
            onPressed: _isLoading ? null : () => performAppSignOut(context),
            child: Text(
              l10n.firstTimeRoleDifferentAccount,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: scheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthSelectionCard(
              title: l10n.firstTimeRoleUserTitle,
              subtitle: l10n.firstTimeRoleUserSubtitle,
              selected: _selectedRole == UserRoles.customer,
              onTap: () => setState(() => _selectedRole = UserRoles.customer),
              leading: const Icon(AppIcons.person_outline_rounded, size: 28),
            ),
            const SizedBox(height: AppSpacing.medium),
            AuthSelectionCard(
              title: l10n.firstTimeRoleOwnerTitle,
              subtitle: l10n.firstTimeRoleOwnerSubtitle,
              selected: _selectedRole == UserRoles.owner,
              onTap: () {
                agentSessionLog(
                  hypothesisId: 'S1',
                  location: 'first_time_role_selection_screen.dart:onOwnerTap',
                  message: 'owner_selection_tap',
                  data: const <String, Object?>{},
                  runId: 'startup-router-debug',
                );
                setState(() => _selectedRole = UserRoles.owner);
              },
              leading: const Icon(AppIcons.storefront_outlined, size: 28),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: AppSpacing.large),
              AppInlineMessage.error(message: l10n.firstTimeRoleError),
            ],
            const SizedBox(height: AppSpacing.xlarge),
            AppSubmitButton(
              label: l10n.firstTimeRoleContinue,
              isLoading: _isLoading,
              onPressed: _selectedRole != null ? _onContinue : null,
            ),
          ],
        ),
      ),
    );
  }
}
