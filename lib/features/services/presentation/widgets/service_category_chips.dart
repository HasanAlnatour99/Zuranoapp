import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/zurano_tokens.dart';
import '../../../../core/widgets/zurano/zurano_category_chip.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/models/service.dart';
import '../../data/service_category_catalog.dart';
import '../../data/service_category_helpers.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

/// Horizontally scrollable category filters with a strong selected state.
class ServiceCategoryChips extends StatelessWidget {
  const ServiceCategoryChips({
    super.key,
    required this.services,
    required this.selection,
    required this.onSelected,
  });

  final List<SalonService> services;

  /// `null` means “All”.
  final OwnerServiceCategorySelection? selection;
  final ValueChanged<OwnerServiceCategorySelection?> onSelected;

  static const double _chipMaxWidth = 152;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final primaryCustom = getVisibleCustomCategory(services);
    final overflowCustoms = getOverflowCustomCategories(
      services,
      primaryCustom?.normalized,
    );
    final showMore = primaryCustom != null || overflowCustoms.isNotEmpty;

    final fifthIsCustom = primaryCustom != null;

    final moreHighlighted = _moreExplainsSelection(
      selection,
      primaryCustom,
      overflowCustoms,
    );

    final children = <Widget>[
      _FilterChipButton(
        label: l10n.ownerServicesChipAll,
        selected: selection == null,
        maxWidth: _chipMaxWidth,
        onTap: () => onSelected(null),
      ),
      ...ServiceCategoryKeys.topBarHeadKeys.map(
        (key) => _FilterChipButton(
          label: serviceCategoryLabelForKey(key, l10n),
          selected:
              selection is OwnerStandardCategorySelection &&
              (selection as OwnerStandardCategorySelection).categoryKey == key,
          maxWidth: _chipMaxWidth,
          onTap: () => onSelected(OwnerStandardCategorySelection(key)),
        ),
      ),
      if (fifthIsCustom)
        _FilterChipButton(
          label: primaryCustom.displayLabel,
          selected:
              selection is OwnerCustomOtherSelection &&
              (selection as OwnerCustomOtherSelection).normalizedCustom ==
                  primaryCustom.normalized,
          maxWidth: _chipMaxWidth,
          onTap: () =>
              onSelected(OwnerCustomOtherSelection(primaryCustom.normalized)),
        )
      else
        _FilterChipButton(
          label: l10n.ownerServiceCategoryOther,
          selected:
              selection is OwnerGenericOtherSelection ||
              (selection is OwnerStandardCategorySelection &&
                  (selection as OwnerStandardCategorySelection).categoryKey ==
                      ServiceCategoryKeys.other),
          maxWidth: _chipMaxWidth,
          onTap: () => onSelected(const OwnerGenericOtherSelection()),
        ),
      ...ServiceCategoryKeys.topBarTailKeys.map(
        (key) => _FilterChipButton(
          label: serviceCategoryLabelForKey(key, l10n),
          selected:
              selection is OwnerStandardCategorySelection &&
              (selection as OwnerStandardCategorySelection).categoryKey == key,
          maxWidth: _chipMaxWidth,
          onTap: () => onSelected(OwnerStandardCategorySelection(key)),
        ),
      ),
      if (showMore)
        _FilterChipButton(
          label: l10n.ownerServiceCategoriesMore,
          selected: moreHighlighted,
          maxWidth: _chipMaxWidth,
          suffix: Icon(
            AppIcons.keyboard_arrow_down_rounded,
            size: 18,
            color: moreHighlighted ? Colors.white : ZuranoTokens.textDark,
          ),
          onTap: () => _openMoreSheet(
            context,
            l10n,
            primaryCustom: primaryCustom,
            overflow: overflowCustoms,
          ),
        ),
    ];

    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: children.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.small),
        itemBuilder: (context, index) => children[index],
      ),
    );
  }

  bool _moreExplainsSelection(
    OwnerServiceCategorySelection? sel,
    CustomCategoryAggregate? primary,
    List<CustomCategoryAggregate> overflow,
  ) {
    if (sel is OwnerGenericOtherSelection && primary != null) {
      return true;
    }
    if (sel is! OwnerCustomOtherSelection) {
      return false;
    }
    if (primary == null) {
      return overflow.any((e) => e.normalized == sel.normalizedCustom);
    }
    return sel.normalizedCustom != primary.normalized;
  }

  Future<void> _openMoreSheet(
    BuildContext context,
    AppLocalizations l10n, {
    required CustomCategoryAggregate? primaryCustom,
    required List<CustomCategoryAggregate> overflow,
  }) async {
    final scheme = Theme.of(context).colorScheme;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.large,
                  0,
                  AppSpacing.large,
                  AppSpacing.small,
                ),
                child: Text(
                  l10n.ownerServiceCategoriesMoreTitle,
                  style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              ListTile(
                title: Text(l10n.ownerServiceCategoryAllOther),
                subtitle: Text(
                  l10n.ownerServiceCategoryOther,
                  style: TextStyle(color: scheme.onSurfaceVariant),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  onSelected(const OwnerGenericOtherSelection());
                },
              ),
              for (final c in overflow)
                ListTile(
                  title: Text(
                    c.displayLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    onSelected(OwnerCustomOtherSelection(c.normalized));
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  const _FilterChipButton({
    required this.label,
    required this.selected,
    required this.maxWidth,
    required this.onTap,
    this.suffix,
  });

  final String label;
  final bool selected;
  final double maxWidth;
  final VoidCallback onTap;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: ZuranoCategoryChip(
        label: label,
        selected: selected,
        onTap: onTap,
        suffix: suffix,
      ),
    );
  }
}
