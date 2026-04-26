import 'package:flutter/material.dart';

import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/zurano_tokens.dart';
import '../app_modal_sheet.dart';
import '../app_select_field.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

/// Category / option picker styled like [ZuranoTextField].
class ZuranoSelectField<T> extends StatelessWidget {
  const ZuranoSelectField({
    super.key,
    required this.label,
    required this.options,
    required this.value,
    required this.onChanged,
    this.requiredField = false,
    this.sheetTitle,
    this.leading,
    this.enabled = true,
  });

  final String label;
  final List<AppSelectOption<T>> options;
  final T? value;
  final ValueChanged<T?> onChanged;
  final bool requiredField;
  final String? sheetTitle;
  final Widget? leading;
  final bool enabled;

  Future<void> _openSheet(BuildContext context) async {
    if (!enabled) return;

    final selected = await showAppModalBottomSheet<T>(
      context: context,
      builder: (sheetContext) => _ZuranoSelectOptionsSheet<T>(
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
    final selectedOption = options.cast<AppSelectOption<T>?>().firstWhere(
      (option) => option?.value == value,
      orElse: () => null,
    );
    final displayText = selectedOption?.label ?? '';
    final hasSelection = selectedOption != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(
              color: ZuranoTokens.textDark.withValues(
                alpha: enabled ? 1 : 0.45,
              ),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
            children: [
              if (requiredField)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Color(0xFFE11D48)),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: enabled ? () => _openSheet(context) : null,
            borderRadius: BorderRadius.circular(ZuranoTokens.radiusInput),
            child: InputDecorator(
              decoration: InputDecoration(
                filled: true,
                fillColor: ZuranoTokens.inputFill.withValues(
                  alpha: enabled ? 1 : 0.55,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ZuranoTokens.radiusInput),
                  borderSide: const BorderSide(color: ZuranoTokens.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ZuranoTokens.radiusInput),
                  borderSide: const BorderSide(color: ZuranoTokens.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(ZuranoTokens.radiusInput),
                  borderSide: const BorderSide(
                    color: ZuranoTokens.primary,
                    width: 1.4,
                  ),
                ),
                suffixIcon: Icon(
                  AppIcons.unfold_more_rounded,
                  color: enabled
                      ? ZuranoTokens.primary
                      : ZuranoTokens.textGray.withValues(alpha: 0.38),
                ),
              ),
              child: Row(
                children: [
                  if (leading != null) ...[leading!, const SizedBox(width: 12)],
                  Expanded(
                    child: Text(
                      hasSelection ? displayText : ' ',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: hasSelection
                            ? ZuranoTokens.textDark.withValues(
                                alpha: enabled ? 1 : 0.45,
                              )
                            : ZuranoTokens.textGray,
                      ),
                    ),
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

class _ZuranoSelectOptionsSheet<T> extends StatelessWidget {
  const _ZuranoSelectOptionsSheet({
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
                color: ZuranoTokens.textDark,
              ),
            ),
            const SizedBox(height: AppSpacing.small),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: options.length,
                separatorBuilder: (_, _) => Divider(
                  height: AppSpacing.medium,
                  color: ZuranoTokens.border.withValues(alpha: 0.6),
                ),
                itemBuilder: (context, index) {
                  final option = options[index];
                  final selected = option.value == value;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    enabled: option.enabled,
                    leading: option.leading,
                    title: Text(
                      option.label,
                      style: const TextStyle(color: ZuranoTokens.textDark),
                    ),
                    subtitle: option.subtitle == null
                        ? null
                        : Text(
                            option.subtitle!,
                            style: const TextStyle(
                              color: ZuranoTokens.textGray,
                            ),
                          ),
                    onTap: option.enabled
                        ? () => Navigator.of(context).pop(option.value)
                        : null,
                    trailing: selected
                        ? const Icon(
                            AppIcons.check_rounded,
                            color: ZuranoTokens.primary,
                          )
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
