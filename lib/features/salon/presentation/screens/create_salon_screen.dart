import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/user_roles.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../features/auth/presentation/widgets/auth_primary_button.dart';
import '../../../../features/onboarding/domain/value_objects/country_option.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../providers/auth_session_actions.dart';
import '../../../../providers/location_providers.dart';
import '../../../../providers/onboarding_providers.dart';
import '../../../../providers/session_provider.dart';
import '../../logic/create_salon_onboarding_controller.dart';

class CreateSalonScreen extends ConsumerStatefulWidget {
  const CreateSalonScreen({super.key});

  @override
  ConsumerState<CreateSalonScreen> createState() => _CreateSalonScreenState();
}

class _CreateSalonScreenState extends ConsumerState<CreateSalonScreen> {
  late final TextEditingController _salonNameController;
  late final TextEditingController _cityController;
  bool _manualCityEntry = false;

  @override
  void initState() {
    super.initState();
    _salonNameController = TextEditingController()
      ..addListener(
        () => ref
            .read(createSalonOnboardingControllerProvider.notifier)
            .updateSalonName(_salonNameController.text),
      );
    _cityController = TextEditingController()
      ..addListener(
        () => ref
            .read(createSalonOnboardingControllerProvider.notifier)
            .updateCity(_cityController.text),
      );
  }

  @override
  void dispose() {
    _salonNameController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _pickCity({
    required List<String> cityNames,
    required bool enabled,
  }) async {
    if (!enabled) {
      return;
    }
    final selected = await showSearch<String>(
      context: context,
      delegate: _CitySearchDelegate(cityNames: cityNames),
    );
    if (!mounted || selected == null) {
      return;
    }
    if (selected.trim().isEmpty) {
      return;
    }
    _cityController.text = selected;
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    final result = await ref
        .read(createSalonOnboardingControllerProvider.notifier)
        .submit();
    if (!mounted ||
        !result.didSucceed ||
        result.salonId == null ||
        result.salonId!.isEmpty) {
      return;
    }
    // Navigate immediately. A post-route dialog + go_router can pop the shell and
    // cause a black screen; optional celebration can be added on the owner shell.
    context.go(AppRoutes.ownerDashboard);
  }

  Widget _buildCitySection({
    required AppLocalizations l10n,
    required bool busy,
    required CreateSalonOnboardingFormState state,
    required bool hasCountry,
  }) {
    if (!hasCountry) {
      return Text(
        l10n.createSalonCountryRequired,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.error,
        ),
      );
    }

    final citiesAsync = ref.watch(salonSetupCitiesProvider);

    return citiesAsync.when(
      loading: () => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const LinearProgressIndicator(minHeight: 3),
          const SizedBox(height: AppSpacing.medium),
          Text(
            l10n.createSalonCitiesLoading,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      error: (Object error, StackTrace _) {
        if (kDebugMode) {
          debugPrint('[CreateSalonScreen] salonSetupCities: $error');
        }
        return _manualCityField(l10n: l10n, busy: busy, state: state);
      },
      data: (cities) {
        if (cities.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.createSalonNoCitiesForCountry,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.small),
              _manualCityField(l10n: l10n, busy: busy, state: state),
            ],
          );
        }

        if (_manualCityEntry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton(
                  onPressed: busy
                      ? null
                      : () => setState(() => _manualCityEntry = false),
                  child: Text(l10n.createSalonPickFromList),
                ),
              ),
              _manualCityField(l10n: l10n, busy: busy, state: state),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(AppRadius.large),
              onTap: () => _pickCity(cityNames: cities, enabled: !busy),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: l10n.fieldLabelCity,
                  errorText: state.cityErrorFor(l10n),
                  suffixIcon: const Icon(Icons.search_rounded),
                ),
                child: Text(
                  _cityController.text.isEmpty
                      ? l10n.createSalonSelectCityHint
                      : _cityController.text,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: _cityController.text.isEmpty
                        ? Theme.of(context).colorScheme.onSurfaceVariant
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton(
                onPressed: busy
                    ? null
                    : () => setState(() => _manualCityEntry = true),
                child: Text(l10n.createSalonEnterCityManually),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _manualCityField({
    required AppLocalizations l10n,
    required bool busy,
    required CreateSalonOnboardingFormState state,
  }) {
    return TextFormField(
      controller: _cityController,
      enabled: !busy,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: l10n.fieldLabelCity,
        hintText: l10n.fieldLabelCity,
        errorText: state.cityErrorFor(l10n),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(createSalonOnboardingControllerProvider);
    final session = ref.watch(sessionUserProvider).asData?.value;
    final onboarding = ref.watch(onboardingPrefsProvider);
    final hasCountry =
        onboarding.countryCompleted &&
        (onboarding.countryCode?.trim().isNotEmpty ?? false);
    final country =
        CountryOption.tryFindByIso(onboarding.countryCode ?? '') ??
        CountryOption.tryFindByIso('QA')!;
    final busy = state.isSubmitting;
    final canSubmit =
        hasCountry && state.isFormValid && !busy && session != null;

    if (session != null && session.role != UserRoles.owner) {
      return const Scaffold(body: SizedBox.shrink());
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.authV2CreateSalonTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.large),
          children: [
            Text(
              l10n.authV2CreateSalonSubtitle,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.large),
            TextFormField(
              controller: _salonNameController,
              enabled: !busy,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: l10n.fieldLabelSalonName,
                hintText: l10n.createSalonHintSalonName,
                errorText: state.salonNameErrorFor(l10n),
              ),
            ),
            const SizedBox(height: AppSpacing.medium),
            Text(
              l10n.fieldLabelCountry,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 4),
            Text(
              country.labelForLocale(
                Localizations.localeOf(context).languageCode,
              ),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.medium),
            _buildCitySection(
              l10n: l10n,
              busy: busy,
              state: state,
              hasCountry: hasCountry,
            ),
            if (state.submissionError != null) ...[
              const SizedBox(height: AppSpacing.medium),
              Text(
                state.submissionError!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.xlarge),
            Opacity(
              opacity: canSubmit || busy ? 1 : 0.55,
              child: AuthPrimaryButton(
                label: l10n.authV2CreateSalonCta,
                isLoading: busy,
                onPressed: canSubmit ? _submit : null,
              ),
            ),
            const SizedBox(height: AppSpacing.medium),
            Center(
              child: TextButton(
                onPressed: busy ? null : () => performAppSignOut(context),
                child: Text(l10n.createSalonFooterDifferentAccount),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CitySearchDelegate extends SearchDelegate<String> {
  _CitySearchDelegate({required this.cityNames});

  final List<String> cityNames;

  List<String> _filtered() {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      return cityNames;
    }
    return cityNames
        .where((city) => city.toLowerCase().contains(q))
        .toList(growable: false);
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          onPressed: () => query = '',
          icon: const Icon(Icons.close_rounded),
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: const Icon(Icons.arrow_back_rounded),
    );
  }

  @override
  Widget buildResults(BuildContext context) => _buildList(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildList(context);

  Widget _buildList(BuildContext context) {
    final items = _filtered();
    return ListView.separated(
      itemCount: items.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final city = items[index];
        return ListTile(title: Text(city), onTap: () => close(context, city));
      },
    );
  }
}
