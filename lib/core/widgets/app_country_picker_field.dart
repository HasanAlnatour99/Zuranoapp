import 'package:flutter/material.dart';

import '../../features/onboarding/domain/value_objects/country_option.dart';
import '../../l10n/app_localizations.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import 'app_modal_sheet.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

/// Opens a searchable sheet; returns ISO code, English/Arabic name, and dial code.
class AppCountryPickerField extends StatelessWidget {
  const AppCountryPickerField({
    required this.label,
    required this.selected,
    required this.onChanged,
    this.errorText,
    this.enabled = true,
    this.hintText,
    super.key,
  });

  final String label;
  final CountryOption? selected;
  final ValueChanged<CountryOption?> onChanged;
  final String? errorText;
  final bool enabled;
  final String? hintText;

  Future<void> _openSheet(BuildContext context) async {
    if (!enabled) return;
    final locale = Localizations.localeOf(context);
    final picked = await showAppModalBottomSheet<CountryOption>(
      context: context,
      builder: (ctx) {
        return _CountrySearchSheet(
          languageCode: locale.languageCode,
          initial: selected,
          searchHint: AppLocalizations.of(context)!.onboardingSearchCountryHint,
        );
      },
    );
    if (picked != null) {
      onChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final locale = Localizations.localeOf(context);
    final hasError = errorText != null && errorText!.isNotEmpty;

    final display = selected == null
        ? (hintText ?? '')
        : '${selected!.labelForLocale(locale.languageCode)} (${selected!.isoCode}) · ${selected!.dialCode}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.small),
        Material(
          color: scheme.surfaceContainerHighest.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(AppRadius.medium),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.medium),
            onTap: enabled ? () => _openSheet(context) : null,
            child: InputDecorator(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                  borderSide: BorderSide(
                    color: hasError
                        ? scheme.error
                        : scheme.outline.withValues(alpha: 0.5),
                  ),
                ),
                errorText: errorText,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.medium,
                  vertical: AppSpacing.medium,
                ),
              ).applyDefaults(theme.inputDecorationTheme),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      display.isEmpty ? ' ' : display,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: selected == null
                            ? scheme.onSurfaceVariant
                            : scheme.onSurface,
                      ),
                    ),
                  ),
                  Icon(
                    AppIcons.keyboard_arrow_down_rounded,
                    color: enabled
                        ? scheme.primary
                        : scheme.onSurface.withValues(alpha: 0.38),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CountrySearchSheet extends StatefulWidget {
  const _CountrySearchSheet({
    required this.languageCode,
    required this.initial,
    required this.searchHint,
  });

  final String languageCode;
  final CountryOption? initial;
  final String searchHint;

  @override
  State<_CountrySearchSheet> createState() => _CountrySearchSheetState();
}

class _CountrySearchSheetState extends State<_CountrySearchSheet> {
  late final TextEditingController _query;
  late List<CountryOption> _filtered;

  @override
  void initState() {
    super.initState();
    _query = TextEditingController()..addListener(_applyFilter);
    _filtered = CountryOption.all;
  }

  void _applyFilter() {
    final q = _query.text.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _filtered = CountryOption.all;
        return;
      }
      _filtered = CountryOption.all
          .where((c) {
            final name = c.labelForLocale(widget.languageCode).toLowerCase();
            return name.contains(q) ||
                c.isoCode.toLowerCase().contains(q) ||
                c.dialCode.contains(q);
          })
          .toList(growable: false);
    });
  }

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final height = MediaQuery.sizeOf(context).height * 0.72;

    return SafeArea(
      child: SizedBox(
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.large,
                AppSpacing.small,
                AppSpacing.large,
                AppSpacing.small,
              ),
              child: TextField(
                controller: _query,
                decoration: InputDecoration(
                  hintText: widget.searchHint,
                  prefixIcon: const Icon(AppIcons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _filtered.length,
                itemBuilder: (context, i) {
                  final c = _filtered[i];
                  final title = c.labelForLocale(widget.languageCode);
                  final selected = widget.initial?.isoCode == c.isoCode;
                  return ListTile(
                    selected: selected,
                    title: Text(title),
                    subtitle: Text('${c.isoCode} · ${c.dialCode}'),
                    onTap: () => Navigator.pop(context, c),
                    trailing: selected
                        ? Icon(AppIcons.check_circle, color: scheme.primary)
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
