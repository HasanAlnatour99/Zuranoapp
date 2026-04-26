import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/user_roles.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/firebase_error_message.dart';
import '../../../../core/widgets/app_inline_message.dart';
import '../../../../core/widgets/app_onboarding_scaffold.dart';
import '../../../../core/widgets/app_submit_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/luxury_auth_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../providers/auth_session_actions.dart';
import '../../../../providers/firebase_providers.dart';
import '../../../../providers/onboarding_providers.dart';
import '../../../../providers/repository_providers.dart';
import '../../../../core/session/app_entry_session.dart';
import '../../../../providers/session_provider.dart';
import '../../../../router/router_session_refresh.dart';
import '../../../onboarding/domain/value_objects/user_address.dart';
import '../../../onboarding/domain/value_objects/user_phone.dart';
import '../../../users/data/models/app_user.dart';

/// Neutral Firestore profile recovery: creates **only** `users/{uid}` when
/// missing (customer or owner). Does not create salons. Staff linkage issues
/// are explained with sign-out — roles `admin` / `barber` cannot self-create
/// per Firestore rules.
class AccountProfileBootstrapScreen extends ConsumerStatefulWidget {
  const AccountProfileBootstrapScreen({super.key});

  @override
  ConsumerState<AccountProfileBootstrapScreen> createState() =>
      _AccountProfileBootstrapScreenState();
}

class _AccountProfileBootstrapScreenState
    extends ConsumerState<AccountProfileBootstrapScreen> {
  String? _errorMessage;
  bool _busy = false;
  String? _pendingRole;
  final _fullNameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _cityController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _mobileController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  bool _staffLinkageMode(WidgetRef ref) {
    final entry = ref.watch(appEntrySessionProvider).asData?.value;
    if (entry is AppEntrySessionStaffLinkageIncomplete) {
      return true;
    }
    final q = GoRouterState.of(context).uri.queryParameters['issue'];
    return q == 'staff-linkage';
  }

  bool _missingUserDocMode() {
    final q = GoRouterState.of(context).uri.queryParameters['issue'];
    return q == 'missing-user-doc';
  }

  Future<void> _createMinimalProfile(
    String role, {
    String? fullName,
    String? mobile,
    String? city,
  }) async {
    FocusScope.of(context).unfocus();
    final authUser = ref.read(firebaseAuthProvider).currentUser;
    final l10n = AppLocalizations.of(context)!;
    if (authUser == null) {
      setState(
        () => _errorMessage = l10n.accountProfileBootstrapErrorNoAuthUser,
      );
      return;
    }
    if (role != UserRoles.customer && role != UserRoles.owner) {
      setState(() => _errorMessage = l10n.accountProfileBootstrapErrorGeneric);
      return;
    }

    setState(() {
      _busy = true;
      _errorMessage = null;
    });

    try {
      await ref
          .read(onboardingPrefsProvider.notifier)
          .setSelectedAuthRole(role);
      final fallbackName = authUser.displayName?.trim().isNotEmpty == true
          ? authUser.displayName!.trim()
          : (authUser.email ?? 'User');
      final selectedName = (fullName ?? '').trim().isEmpty
          ? fallbackName
          : fullName!.trim();
      final mobileDigits = (mobile ?? '').replaceAll(RegExp(r'\D'), '');
      final cityValue = (city ?? '').trim();
      if (kDebugMode) {
        final path = 'users/${authUser.uid}';
        debugPrint(
          '[AccountProfileBootstrap] before createMinimalRecoveryUser: '
          'auth.currentUser?.uid=${authUser.uid} path=$path merge=false '
          '(full replace; rules=create) role=$role',
        );
      }
      await ref
          .read(userRepositoryProvider)
          .createMinimalRecoveryUser(
            AppUser(
              uid: authUser.uid,
              email: authUser.email ?? '',
              name: selectedName,
              role: role,
              isActive: true,
              salonId: null,
              employeeId: null,
              onboardingCompleted: true,
              authProvider: 'google',
              photoUrl: authUser.photoURL,
              profileCompletedAt: DateTime.now(),
              phone: mobileDigits.isEmpty
                  ? null
                  : UserPhone.fromDialAndNational(
                      countryIsoCode: 'XX',
                      dialCode: '+',
                      nationalDigits: mobileDigits,
                    ),
              address: cityValue.isEmpty
                  ? null
                  : UserAddress.customerProfile(
                      countryCode: 'XX',
                      countryName: 'Unknown',
                      city: cityValue,
                      street: cityValue,
                    ),
            ),
          );
      ref.invalidate(appEntrySessionProvider);
      refreshRouterAfterAuthChange(ref);
      if (!mounted) {
        return;
      }
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        debugPrint(
          '[AccountProfileBootstrap] createMinimalRecoveryUser failed: '
          'code=${e.code} message=${e.message} attemptedPath=users/${authUser.uid} '
          'role=$role',
        );
      }
      if (!mounted) {
        return;
      }
      setState(() {
        _busy = false;
        _errorMessage = FirebaseErrorMessage.fromException(e);
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _busy = false;
        _errorMessage = FirebaseErrorMessage.fromException(e);
      });
    }
  }

  Future<void> _onSubmit() async {
    final l10n = AppLocalizations.of(context)!;
    final fromPrefs = ref
        .read(onboardingPrefsProvider)
        .selectedAuthRole
        ?.trim();
    if (fromPrefs == UserRoles.owner) {
      await _createMinimalProfile(UserRoles.owner);
      return;
    }
    if (fromPrefs == UserRoles.customer) {
      await _submitCustomerProfile();
      return;
    }
    final chosen = _pendingRole;
    if (chosen == UserRoles.owner) {
      await _createMinimalProfile(UserRoles.owner);
      return;
    }
    if (chosen == UserRoles.customer) {
      await _submitCustomerProfile();
      return;
    }
    setState(() => _errorMessage = l10n.accountProfileBootstrapErrorGeneric);
  }

  Future<void> _submitCustomerProfile() async {
    final l10n = AppLocalizations.of(context)!;
    final fullName = _fullNameController.text.trim();
    final mobile = _mobileController.text.trim();
    final city = _cityController.text.trim();
    if (fullName.isEmpty || mobile.isEmpty || city.isEmpty) {
      setState(() => _errorMessage = l10n.accountProfileBootstrapErrorGeneric);
      return;
    }
    final mobileDigits = mobile.replaceAll(RegExp(r'\D'), '');
    if (mobileDigits.length < 6) {
      setState(() => _errorMessage = l10n.validationPhoneShort);
      return;
    }
    await _createMinimalProfile(
      UserRoles.customer,
      fullName: fullName,
      mobile: mobile,
      city: city,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final staff = _staffLinkageMode(ref);
    final missingUserDoc = _missingUserDocMode();
    final prefsRole = ref.watch(onboardingPrefsProvider).selectedAuthRole;
    final hasIntent =
        prefsRole == UserRoles.owner || prefsRole == UserRoles.customer;
    final roleIntent = hasIntent ? prefsRole : _pendingRole;
    final isCustomerFlow = !staff && roleIntent == UserRoles.customer;

    return LuxuryAuthTheme(
      child: AppOnboardingScaffold(
        eyebrow: l10n.accountProfileBootstrapEyebrow,
        title: staff
            ? l10n.accountProfileBootstrapTitleStaff
            : isCustomerFlow
            ? 'Complete your profile'
            : l10n.accountProfileBootstrapTitleMissing,
        description: staff
            ? l10n.accountProfileBootstrapDescriptionStaff
            : isCustomerFlow
            ? 'Add a few details to continue'
            : l10n.accountProfileBootstrapDescriptionMissing,
        onboardingStep: 1,
        onboardingTotalSteps: 1,
        onboardingStepLabel: l10n.accountProfileBootstrapEyebrow,
        footer: Center(
          child: TextButton(
            onPressed: _busy ? null : () => performAppSignOut(context),
            child: Text(
              l10n.accountProfileBootstrapFooterDifferentAccount,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: scheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        child: staff
            ? const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: AppSpacing.medium),
                    Text(
                      'Preparing your staff profile recovery...',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (missingUserDoc) ...[
                    AppInlineMessage.error(
                      message: l10n.accountProfileRecoveryInlineError,
                    ),
                    const SizedBox(height: AppSpacing.medium),
                  ],
                  if (!hasIntent) ...[
                    Text(
                      l10n.accountProfileBootstrapChoosePath,
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    OutlinedButton(
                      onPressed: _busy
                          ? null
                          : () => setState(() {
                              _pendingRole = UserRoles.customer;
                            }),
                      child: Text(l10n.accountProfileBootstrapContinueCustomer),
                    ),
                    const SizedBox(height: AppSpacing.small),
                    OutlinedButton(
                      onPressed: _busy
                          ? null
                          : () => setState(() {
                              _pendingRole = UserRoles.owner;
                            }),
                      child: Text(l10n.accountProfileBootstrapContinueOwner),
                    ),
                  ],
                  if (isCustomerFlow) ...[
                    AppTextField(
                      label: l10n.profileFieldFullName,
                      controller: _fullNameController,
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    AppTextField(
                      label: l10n.profileFieldMobile,
                      controller: _mobileController,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: AppSpacing.medium),
                    AppTextField(
                      label: l10n.profileFieldCity,
                      controller: _cityController,
                    ),
                  ],
                  if (_errorMessage != null) ...[
                    const SizedBox(height: AppSpacing.medium),
                    AppInlineMessage.error(message: _errorMessage!),
                  ],
                  const SizedBox(height: AppSpacing.large),
                  AppSubmitButton(
                    label: isCustomerFlow
                        ? l10n.onboardingContinue
                        : l10n.accountProfileBootstrapCreateProfile,
                    isLoading: _busy,
                    onPressed: _busy || staff ? null : _onSubmit,
                  ),
                ],
              ),
      ),
    );
  }
}
