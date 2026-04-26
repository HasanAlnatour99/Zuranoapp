import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../providers/onboarding_providers.dart';
import '../../../../router/router_session_refresh.dart';
import '../../logic/login_controller.dart';
import '../widgets/auth_app_divider.dart';
import '../widgets/auth_luxury_social_login_stack.dart';
import '../widgets/auth_primary_button.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

class OwnerLoginScreen extends ConsumerStatefulWidget {
  const OwnerLoginScreen({super.key});

  @override
  ConsumerState<OwnerLoginScreen> createState() => _OwnerLoginScreenState();
}

class _OwnerLoginScreenState extends ConsumerState<OwnerLoginScreen>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final AnimationController _entrance;
  late final Animation<double> _fade;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 360),
    );
    _fade = CurvedAnimation(parent: _entrance, curve: Curves.easeOutCubic);
    _entrance.forward();
    _emailController = TextEditingController()
      ..addListener(
        () => ref
            .read(loginControllerProvider.notifier)
            .updateEmail(_emailController.text),
      );
    _passwordController = TextEditingController()
      ..addListener(
        () => ref
            .read(loginControllerProvider.notifier)
            .updatePassword(_passwordController.text),
      );
  }

  @override
  void dispose() {
    _entrance.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final ok = await ref.read(loginControllerProvider.notifier).submit();
    if (!mounted || !ok) return;
    refreshRouterAfterAuthChange(ref);
  }

  Future<void> _afterOAuth(Future<bool> Function() action) async {
    FocusScope.of(context).unfocus();
    final ok = await action();
    if (!mounted || !ok) return;
    refreshRouterAfterAuthChange(ref);
  }

  Future<void> _onBackToRoleSelection() async {
    await ref.read(onboardingPrefsProvider.notifier).clearPreAuthPortal();
    if (!mounted) return;
    context.go(AppRoutes.roleSelection);
  }

  Future<void> _showForgotPassword(AppLocalizations l10n) async {
    final email = _emailController.text.trim();
    final submittedEmail = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        final controller = TextEditingController(text: email);
        return AlertDialog(
          title: Text(l10n.authV2ForgotPassword),
          content: TextField(
            controller: controller,
            autofocus: true,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(labelText: l10n.fieldLabelEmail),
            onSubmitted: (_) {
              Navigator.of(dialogContext).pop(controller.text.trim());
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(null),
              child: Text(l10n.authCommonBack),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(dialogContext).pop(controller.text.trim()),
              child: Text(l10n.authV2SendResetLink),
            ),
          ],
        );
      },
    );

    if (submittedEmail == null) return;

    final sent = await ref
        .read(loginControllerProvider.notifier)
        .sendPasswordReset(submittedEmail);
    if (!mounted) return;
    if (sent) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.authV2ForgotPasswordSent)));
    } else {
      final err = ref.read(loginControllerProvider).submissionError;
      if (err != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(err)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final state = ref.watch(loginControllerProvider);
    final socialBusy = state.isAnyAuthLoading;
    final oauth = state.oauthProviderInFlight;

    return FadeTransition(
      opacity: _fade,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: scheme.onSurface),
            tooltip: l10n.authCommonBack,
            onPressed: socialBusy || state.isSubmitting
                ? null
                : _onBackToRoleSelection,
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        body: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.large,
              vertical: AppSpacing.medium,
            ),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: AutofillGroup(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Image.asset(
                      'assets/branding/zurano_logo.png',
                      width: 260,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.medium,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Text(
                    l10n.authV2OwnerLoginHeadline,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: scheme.onSurface,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.authV2OwnerLoginSubtitle,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.large),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.email],
                    decoration: InputDecoration(
                      labelText: l10n.fieldLabelEmail,
                      hintText: l10n.loginHintEmail,
                      errorText: state.emailErrorFor(l10n),
                    ),
                    enabled: !socialBusy,
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    autofillHints: const [AutofillHints.password],
                    decoration: InputDecoration(
                      labelText: l10n.fieldLabelPassword,
                      hintText: l10n.loginHintPassword,
                      errorText: state.passwordErrorFor(l10n),
                      suffixIcon: IconButton(
                        tooltip: _obscurePassword
                            ? l10n.accessibilityShowPassword
                            : l10n.accessibilityHidePassword,
                        onPressed: socialBusy
                            ? null
                            : () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                        icon: Icon(
                          _obscurePassword
                              ? AppIcons.visibility_off_outlined
                              : AppIcons.visibility_outlined,
                        ),
                      ),
                    ),
                    enabled: !socialBusy,
                  ),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: TextButton(
                      onPressed: socialBusy
                          ? null
                          : () => _showForgotPassword(l10n),
                      child: Text(l10n.authV2ForgotPassword),
                    ),
                  ),
                  if (state.submissionError != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      state.submissionError!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.error,
                      ),
                    ),
                  ],
                  AuthPrimaryButton(
                    label: l10n.loginSignInButton,
                    isLoading: state.isSubmitting,
                    minHeight: 56,
                    borderRadius: 18,
                    onPressed: state.isFormValid && !socialBusy
                        ? _submit
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.large),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.center,
                    spacing: 4,
                    children: [
                      Text(
                        l10n.authV2LoginSignupPrompt,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                      TextButton(
                        onPressed: socialBusy
                            ? null
                            : () => context.push(AppRoutes.ownerSignup),
                        child: Text(l10n.authV2SignUpLink),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.medium),
                  AuthOrDivider(text: l10n.authV2OrDivider),
                  const SizedBox(height: AppSpacing.medium),
                  AuthLuxurySocialLoginStack(
                    enabled: !socialBusy,
                    googleLoading: oauth == 'google',
                    appleLoading: oauth == 'apple',
                    facebookLoading: oauth == 'facebook',
                    onGoogle: () => _afterOAuth(
                      () => ref
                          .read(loginControllerProvider.notifier)
                          .signInWithGoogle(),
                    ),
                    onApple: () => _afterOAuth(
                      () => ref
                          .read(loginControllerProvider.notifier)
                          .signInWithApple(),
                    ),
                    onFacebook: () => _afterOAuth(
                      () => ref
                          .read(loginControllerProvider.notifier)
                          .signInWithFacebook(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
