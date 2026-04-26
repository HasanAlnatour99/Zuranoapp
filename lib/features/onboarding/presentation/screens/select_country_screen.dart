import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../../application/select_country_controller.dart';
import '../../../auth/presentation/widgets/auth_shell.dart';
import '../widgets/country_card.dart';
import '../widgets/country_search_field.dart';

class SelectCountryScreen extends ConsumerStatefulWidget {
  const SelectCountryScreen({super.key});

  @override
  ConsumerState<SelectCountryScreen> createState() =>
      _SelectCountryScreenState();
}

class _SelectCountryScreenState extends ConsumerState<SelectCountryScreen> {
  static const _headerAsset = 'assets/images/onboarding_0.png';
  static const _ink = Color(0xFF111111);
  static const _headerBorder = Color(0xFFE9DFFF);

  final TextEditingController _searchController = TextEditingController();
  int _buildCount = 0;

  @override
  void dispose() {
    if (kDebugMode) {
      debugPrint('[SelectCountryScreen] dispose buildCount=$_buildCount');
    }
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildHeaderImage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Container(
        height: 170,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: _headerBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Image.asset(_headerAsset, fit: BoxFit.contain),
      ),
    );
  }

  Widget _buildSubtitle(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        l10n.preAuthCountrySubtitle,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: const Color(0xFF64748B),
          height: 1.45,
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    final vm = ref.read(selectCountryControllerProvider.notifier);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: CountrySearchField(
        controller: _searchController,
        onChanged: vm.setSearchQuery,
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context, AppLocalizations l10n) {
    final state = ref.watch(selectCountryControllerProvider);
    final selected = state.selectedCountry;
    final isEnabled = selected != null;

    return SizedBox(
      height: 60,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: isEnabled
              ? const LinearGradient(
                  colors: [Color(0xFF6D28D9), Color(0xFFA855F7)],
                )
              : LinearGradient(
                  colors: [Colors.grey.shade300, Colors.grey.shade300],
                ),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: const Color(0xFF7B2FF7).withValues(alpha: 0.25),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ]
              : const [],
        ),
        child: ElevatedButton(
          onPressed: isEnabled
              ? () async {
                  await ref
                      .read(selectCountryControllerProvider.notifier)
                      .confirmSelectedCountry();
                  if (context.mounted) {
                    context.go(AppRoutes.roleSelection);
                  }
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            disabledForegroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            l10n.preAuthContinue,
            style: TextStyle(
              color: isEnabled ? Colors.white : Colors.grey.shade600,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _buildCount++;
    if (kDebugMode) {
      debugPrint(
        '[SelectCountryScreen] build #$_buildCount '
        'route=${GoRouterState.of(context).matchedLocation}',
      );
    }
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(selectCountryControllerProvider);
    final vm = ref.read(selectCountryControllerProvider.notifier);
    final languageCode = Localizations.localeOf(context).languageCode;

    return AuthShell(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            color: _ink,
            onPressed: () => context.go(AppRoutes.onboardingLanguage),
          ),
          title: Text(
            l10n.preAuthCountryTitle,
            style: const TextStyle(
              color: _ink,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          centerTitle: false,
        ),
        body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeaderImage(),
              const SizedBox(height: 24),
              _buildSubtitle(context, l10n),
              const SizedBox(height: 12),
              _buildSearchField(),
              const SizedBox(height: 20),
              Expanded(
                child: _CountryList(
                  state: state,
                  languageCode: languageCode,
                  onSelect: vm.selectCountry,
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            child: _buildContinueButton(context, l10n),
          ),
        ),
      ),
    );
  }
}

class _CountryList extends StatelessWidget {
  const _CountryList({
    required this.state,
    required this.languageCode,
    required this.onSelect,
  });

  final SelectCountryState state;
  final String languageCode;
  final ValueChanged<String> onSelect;

  static const _listPadding = EdgeInsets.fromLTRB(24, 0, 24, 24);

  @override
  Widget build(BuildContext context) {
    final items = state.filtered;
    return ListView.separated(
      padding: _listPadding,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final c = items[i];
        return CountryCard(
          country: c,
          displayName: c.displayName(languageCode),
          isSelected: c.isoCode == state.selectedIsoCode,
          onTap: () => onSelect(c.isoCode),
        );
      },
    );
  }
}
