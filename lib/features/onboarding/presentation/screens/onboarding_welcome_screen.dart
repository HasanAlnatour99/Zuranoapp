import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/theme/auth_premium_tokens.dart';
import '../../../../core/ui/app_illustrations.dart';
import '../../../../core/widgets/app_illustration.dart';
import '../../../../features/auth/presentation/widgets/auth_gradient_backdrop.dart';
import '../../../../features/auth/presentation/widgets/auth_header.dart';
import '../../../../features/auth/presentation/widgets/auth_primary_button.dart';
import '../../../../features/auth/presentation/widgets/auth_dropdown_field.dart';
import '../../../../features/auth/presentation/widgets/auth_scaffold.dart';
import '../../../../features/auth/presentation/widgets/auth_shell.dart';
import '../../../../features/onboarding/domain/value_objects/country_option.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../providers/app_settings_providers.dart';
import '../../../../providers/onboarding_providers.dart';

class OnboardingWelcomeScreen extends ConsumerStatefulWidget {
  const OnboardingWelcomeScreen({super.key});

  @override
  ConsumerState<OnboardingWelcomeScreen> createState() =>
      _OnboardingWelcomeScreenState();
}

class _OnboardingWelcomeScreenState
    extends ConsumerState<OnboardingWelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance;
  late final Animation<double> _fade;

  Locale? _locale;
  CountryOption? _country;

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _fade = CurvedAnimation(parent: _entrance, curve: Curves.easeOutCubic);
    _entrance.forward();
  }

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final appLocale = ref.watch(appLocalePreferenceProvider);
    final prefs = ref.watch(onboardingPrefsProvider);

    _locale ??= appLocale;
    _country ??=
        CountryOption.tryFindByIso(prefs.countryCode) ??
        CountryOption.tryFindByIso('QA');

    final locales = AppLocalizations.supportedLocales.toList();
    final countries = CountryOption.all;

    return AuthShell(
      child: FadeTransition(
        opacity: _fade,
        child: AuthScaffold(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              Center(
                child: Image.asset(
                  'assets/images/branding/zurano_full_logo_dark_surfaces_transparent.png',
                  height: 36,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => const SizedBox(height: 36),
                ),
              ),
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.center,
                children: [
                  const AuthGradientBackdrop(height: 168),
                  AppIllustration(
                    assetName: AppIllustrations.onboardingWelcome,
                    size: AppIllustrationSize.hero,
                    semanticLabel: l10n.semanticIllustrationWelcomeOnboarding,
                  ),
                ],
              ),
              const SizedBox(height: AuthPremiumLayout.sectionGap),
              AuthHeader(
                title: l10n.authV2WelcomeTitle,
                subtitle: l10n.authV2WelcomeSubtitle,
              ),
              const SizedBox(height: 24),
              AuthDropdownField<Locale>(
                label: l10n.authV2FieldLanguage,
                value: _locale,
                items: locales,
                itemLabel: (l) => l.languageCode == 'ar'
                    ? l10n.preAuthLanguageArabic
                    : l10n.preAuthLanguageEnglish,
                onChanged: (v) async {
                  if (v == null) return;
                  setState(() => _locale = v);
                  await ref
                      .read(appLocalePreferenceProvider.notifier)
                      .setLocale(v);
                },
              ),
              const SizedBox(height: 18),
              AuthDropdownField<CountryOption>(
                label: l10n.authV2FieldCountry,
                value: _country,
                items: countries,
                itemLabel: (c) =>
                    c.labelForLocale(_locale?.languageCode ?? 'en'),
                onChanged: (v) => setState(() => _country = v),
              ),
              const SizedBox(height: 28),
              AuthPrimaryButton(
                label: l10n.authV2WelcomeContinue,
                onPressed: _locale != null && _country != null
                    ? () async {
                        await ref
                            .read(onboardingPrefsProvider.notifier)
                            .completeWelcomeOnboarding(
                              locale: _locale!,
                              countryIso: _country!.isoCode,
                            );
                        if (!context.mounted) return;
                        context.go(AppRoutes.roleSelection);
                      }
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
