import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import '../../l10n/app_localizations.dart';

/// Compact strength hint shown while the password field is focused (progressive disclosure).
class PasswordStrengthIndicator extends StatelessWidget {
  const PasswordStrengthIndicator({required this.password, super.key});

  final String password;

  static int score(String password) {
    var s = 0;
    if (password.length >= 6) s++;
    if (password.length >= 10) s++;
    if (RegExp(r'[A-Z]').hasMatch(password)) s++;
    if (RegExp(r'[0-9]').hasMatch(password)) s++;
    if (RegExp(r'[^A-Za-z0-9]').hasMatch(password)) s++;
    return s.clamp(0, 4);
  }

  static String labelForScore(AppLocalizations l10n, int score) {
    switch (score) {
      case 0:
      case 1:
        return l10n.passwordStrengthHintWeak;
      case 2:
        return l10n.passwordStrengthHintOk;
      case 3:
        return l10n.passwordStrengthHintStrong;
      default:
        return l10n.passwordStrengthHintExcellent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final level = score(password);
    final label = labelForScore(l10n, level);

    return Semantics(
      label: l10n.passwordStrengthSemanticLabel(label),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(4, (index) {
              final filled = index < level;
              return Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.only(
                    end: index < 3 ? AppSpacing.small : 0,
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 4,
                    decoration: BoxDecoration(
                      color: filled ? scheme.primary : scheme.outline,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: AppSpacing.small),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
