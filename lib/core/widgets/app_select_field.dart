import 'package:flutter/material.dart';

import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import 'app_modal_sheet.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

class AppSelectOption<T> {
  const AppSelectOption({
    required this.value,
    required this.label,
    this.subtitle,
    this.leading,
    this.enabled = true,
  });

  final T value;
  final String label;
  final String? subtitle;
  final Widget? leading;
  final bool enabled;
}

class AppSelectField<T> extends StatelessWidget {
  const AppSelectField({
    required this.label,
    required this.options,
    required this.value,
    required this.onChanged,
    super.key,
    this.errorText,
    this.hintText,
    this.sheetTitle,
    this.enabled = true,
  });

  final String label;
  final List<AppSelectOption<T>> options;
  final T? value;
  final ValueChanged<T?> onChanged;
  final String? errorText;
  final String? hintText;
  final String? sheetTitle;
  final bool enabled;

  Future<void> _openSheet(BuildContext context) async {
    if (!enabled) return;

    final selected = await showAppModalBottomSheet<T>(
      context: context,
      builder: (sheetContext) => _AppSelectSheet<T>(
        title: sheetTitle ?? label,
        value: value,
        options: options,
      ),
    );

    if (selected != null || options.any((option) => option.value == selected)) {
      onChanged(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final selectedOption = options.cast<AppSelectOption<T>?>().firstWhere(
      (option) => option?.value == value,
      orElse: () => null,
    );
    final displayText = selectedOption?.label ?? hintText ?? '';
    final hasSelection = selectedOption != null;

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.medium),
      onTap: enabled ? () => _openSheet(context) : null,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          errorText: errorText,
          suffixIcon: Icon(
            AppIcons.unfold_more_rounded,
            color: enabled
                ? scheme.primary
                : scheme.onSurface.withValues(alpha: 0.38),
          ),
        ),
        isEmpty: !hasSelection,
        child: Text(
          displayText.isEmpty ? ' ' : displayText,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: hasSelection ? scheme.onSurface : scheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _AppSelectSheet<T> extends StatelessWidget {
  const _AppSelectSheet({
    required this.title,
    required this.options,
    required this.value,
  });

  final String title;
  final List<AppSelectOption<T>> options;
  final T? value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.72;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.large,
          0,
          AppSpacing.large,
          AppSpacing.large,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.small),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: options.length,
                separatorBuilder: (_, _) => Divider(
                  height: AppSpacing.medium,
                  color: scheme.outlineVariant,
                ),
                itemBuilder: (context, index) {
                  final option = options[index];
                  final selected = option.value == value;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    enabled: option.enabled,
                    leading: option.leading,
                    title: Text(option.label),
                    subtitle: option.subtitle == null
                        ? null
                        : Text(option.subtitle!),
                    onTap: option.enabled
                        ? () => Navigator.of(context).pop(option.value)
                        : null,
                    trailing: selected
                        ? Icon(AppIcons.check_rounded, color: scheme.primary)
                        : null,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.medium),
                    ),
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
