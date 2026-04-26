import 'package:flutter/material.dart';

import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import 'app_surface_card.dart';

/// Avatar + identity row with an optional edit action.
class CustomerProfileHeaderCard extends StatelessWidget {
  const CustomerProfileHeaderCard({
    super.key,
    required this.displayName,
    required this.email,
    this.onEditPressed,
    this.editLabel,
  });

  final String displayName;
  final String email;
  final VoidCallback? onEditPressed;
  final String? editLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final trimmed = displayName.trim();
    final initial = _initialLetter(trimmed);

    return AppSurfaceCard(
      margin: EdgeInsets.zero,
      borderRadius: AppRadius.xlarge,
      padding: const EdgeInsets.all(AppSpacing.large),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: scheme.inverseSurface,
              borderRadius: BorderRadius.circular(AppRadius.large),
            ),
            alignment: Alignment.center,
            child: Text(
              initial,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: scheme.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.medium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName.trim().isEmpty ? '—' : displayName.trim(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (onEditPressed != null && (editLabel ?? '').trim().isNotEmpty)
            TextButton(
              onPressed: onEditPressed,
              style: TextButton.styleFrom(
                foregroundColor: scheme.onSurfaceVariant,
                backgroundColor: scheme.surfaceContainerHighest,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.medium,
                  vertical: AppSpacing.small,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                ),
              ),
              child: Text(
                editLabel!.trim(),
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

String _initialLetter(String trimmed) {
  if (trimmed.isEmpty) {
    return '?';
  }
  final first = trimmed.runes.first;
  return String.fromCharCode(first).toUpperCase();
}
