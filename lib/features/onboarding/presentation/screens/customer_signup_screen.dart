import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/ui/app_illustrations.dart';
import '../../../../core/widgets/app_form_section_header.dart';
import '../../../../core/widgets/app_illustration.dart';
import '../../../../core/widgets/app_inline_message.dart';
import '../../../../core/widgets/app_onboarding_scaffold.dart';
import '../../../../core/widgets/app_phone_with_country_field.dart';
import '../../../../core/widgets/app_submit_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/luxury_auth_theme.dart';
import '../../../../core/widgets/password_strength_indicator.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/customer_signup_controller.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

class CustomerSignupScreen extends ConsumerStatefulWidget {
  const CustomerSignupScreen({super.key});

  @override
  ConsumerState<CustomerSignupScreen> createState() =>
      _CustomerSignupScreenState();
}

class _CustomerSignupScreenState extends ConsumerState<CustomerSignupScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  late final TextEditingController _phoneNationalController;
  late final TextEditingController _cityController;
  late final TextEditingController _streetController;
  late final FocusNode _passwordFocusNode;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _passwordFieldFocused = false;

  @override
  void initState() {
    super.initState();
    _passwordFocusNode = FocusNode()
      ..addListener(() {
        setState(() {
          _passwordFieldFocused = _passwordFocusNode.hasFocus;
        });
      });
    _nameController = TextEditingController()
      ..addListener(
        () => ref
            .read(customerSignupControllerProvider.notifier)
            .updateFullName(_nameController.text),
      );
    _emailController = TextEditingController()
      ..addListener(
        () => ref
            .read(customerSignupControllerProvider.notifier)
            .updateEmail(_emailController.text),
      );
    _passwordController = TextEditingController()
      ..addListener(() {
        ref
            .read(customerSignupControllerProvider.notifier)
            .updatePassword(_passwordController.text);
        if (_passwordFieldFocused) setState(() {});
      });
    _confirmPasswordController = TextEditingController()
      ..addListener(
        () => ref
            .read(customerSignupControllerProvider.notifier)
            .updateConfirmPassword(_confirmPasswordController.text),
      );
    _phoneNationalController = TextEditingController()
      ..addListener(
        () => ref
            .read(customerSignupControllerProvider.notifier)
            .updatePhoneNational(_phoneNationalController.text),
      );
    _cityController = TextEditingController()
      ..addListener(
        () => ref
            .read(customerSignupControllerProvider.notifier)
            .updateCity(_cityController.text),
      );
    _streetController = TextEditingController()
      ..addListener(
        () => ref
            .read(customerSignupControllerProvider.notifier)
            .updateStreet(_streetController.text),
      );
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneNationalController.dispose();
    _cityController.dispose();
    _streetController.dispose();
    super.dispose();
  }

  void _goBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.login);
    }
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final ok = await ref
        .read(customerSignupControllerProvider.notifier)
        .submit();
    if (!mounted || !ok) return;
    context.go(AppRoutes.customerHome);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(customerSignupControllerProvider);
    final scheme = Theme.of(context).colorScheme;
    final busy = state.isSubmitting;

    return LuxuryAuthTheme(
      child: AppOnboardingScaffold(
        leading: Align(
          alignment: AlignmentDirectional.centerStart,
          child: IconButton(
            tooltip: l10n.authCommonBack,
            onPressed: busy ? null : _goBack,
            icon: const Icon(AppIcons.arrow_back),
          ),
        ),
        topVisual: AppIllustration(
          assetName: AppIllustrations.onboardingCustomerSignup,
          size: AppIllustrationSize.hero,
          semanticLabel: l10n.semanticIllustrationCustomerSignup,
        ),
        eyebrow: l10n.customerSignupEyebrow,
        title: l10n.customerSignupTitle,
        description: l10n.customerSignupDescription,
        footer: Center(
          child: TextButton(
            onPressed: busy
                ? null
                : () {
                    if (context.canPop()) {
                      context.pushReplacement(AppRoutes.login);
                    } else {
                      context.go(AppRoutes.login);
                    }
                  },
            child: Text(
              l10n.registerFooterSignIn,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: scheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppFormSectionHeader(
              title: l10n.registerSectionYourDetails,
              subtitle: l10n.registerSectionProfileHint,
            ),
            const SizedBox(height: AppSpacing.large),
            AppTextField(
              label: l10n.fieldLabelFullName,
              hintText: l10n.registerHintFullName,
              controller: _nameController,
              textInputAction: TextInputAction.next,
              errorText: state.fullNameError(l10n),
              enabled: !busy,
            ),
            const SizedBox(height: AppSpacing.medium),
            AppTextField(
              label: l10n.fieldLabelEmail,
              hintText: l10n.registerHintEmail,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              errorText: state.emailError(l10n),
              enabled: !busy,
            ),
            const SizedBox(height: AppSpacing.medium),
            AppTextField(
              label: l10n.fieldLabelPassword,
              hintText: l10n.registerHintPassword,
              focusNode: _passwordFocusNode,
              controller: _passwordController,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.next,
              errorText: state.passwordError(l10n),
              enabled: !busy,
              suffixIcon: IconButton(
                tooltip: _obscurePassword
                    ? l10n.accessibilityShowPassword
                    : l10n.accessibilityHidePassword,
                onPressed: busy
                    ? null
                    : () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                icon: Icon(
                  _obscurePassword
                      ? AppIcons.visibility_off
                      : AppIcons.visibility,
                  color: scheme.primary,
                ),
              ),
            ),
            if (_passwordFieldFocused) ...[
              const SizedBox(height: AppSpacing.medium),
              PasswordStrengthIndicator(password: _passwordController.text),
            ],
            const SizedBox(height: AppSpacing.medium),
            AppTextField(
              label: l10n.fieldLabelConfirmPassword,
              hintText: l10n.registerHintConfirmPassword,
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              textInputAction: TextInputAction.next,
              errorText: state.confirmPasswordError(l10n),
              enabled: !busy,
              suffixIcon: IconButton(
                tooltip: _obscureConfirmPassword
                    ? l10n.accessibilityShowPassword
                    : l10n.accessibilityHidePassword,
                onPressed: busy
                    ? null
                    : () => setState(
                        () =>
                            _obscureConfirmPassword = !_obscureConfirmPassword,
                      ),
                icon: Icon(
                  _obscureConfirmPassword
                      ? AppIcons.visibility_off
                      : AppIcons.visibility,
                  color: scheme.primary,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.large),
            AppPhoneWithCountryField(
              label: l10n.fieldLabelPhone,
              countryLabel: l10n.fieldLabelCountry,
              countrySelected: state.country,
              onCountryChanged: busy
                  ? (_) {}
                  : (c) => ref
                        .read(customerSignupControllerProvider.notifier)
                        .updateCountry(c),
              nationalController: _phoneNationalController,
              countryErrorText: state.countryError(l10n),
              nationalErrorText: state.phoneError(l10n),
              enabled: !busy,
            ),
            const SizedBox(height: AppSpacing.large),
            AppFormSectionHeader(
              title: l10n.fieldLabelAddress,
              subtitle: l10n.customerSignupAddressHint,
            ),
            const SizedBox(height: AppSpacing.medium),
            AppTextField(
              label: l10n.fieldLabelCity,
              controller: _cityController,
              textInputAction: TextInputAction.next,
              errorText: state.cityError(l10n),
              enabled: !busy,
            ),
            const SizedBox(height: AppSpacing.medium),
            AppTextField(
              label: l10n.fieldLabelStreet,
              controller: _streetController,
              textInputAction: TextInputAction.done,
              errorText: state.streetError(l10n),
              enabled: !busy,
            ),
            if (state.submissionError != null) ...[
              const SizedBox(height: AppSpacing.medium),
              AppInlineMessage.error(message: state.submissionError!),
            ],
            const SizedBox(height: AppSpacing.large),
            AppSubmitButton(
              label: l10n.customerSignupSubmit,
              isLoading: busy,
              onPressed: state.isFormValid && !busy ? _submit : null,
            ),
          ],
        ),
      ),
    );
  }
}
