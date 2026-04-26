import 'package:flutter/material.dart';

import '../../../../../core/widgets/app_primary_button.dart';

class StickyCreateBarberFooter extends StatelessWidget {
  const StickyCreateBarberFooter({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.leadingIcon = Icons.person_add_alt_1_rounded,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final IconData leadingIcon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surface,
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, -4),
            color: scheme.shadow.withValues(alpha: 0.08),
          ),
        ],
        border: Border(
          top: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.45)),
        ),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12 + bottom),
        child: AppPrimaryButton(
          label: label,
          onPressed: onPressed,
          isLoading: isLoading,
          isDisabled: isDisabled,
          leadingIcon: leadingIcon,
        ),
      ),
    );
  }
}
