import 'package:flutter/material.dart';

import '../../../../../core/theme/auth_premium_tokens.dart';
import '../../../../../core/utils/localized_input_validators.dart';
import '../../../../../l10n/app_localizations.dart';

class AddBarberPasswordChecklist extends StatelessWidget {
  const AddBarberPasswordChecklist({
    super.key,
    required this.l10n,
    required this.password,
    required this.confirm,
  });

  final AppLocalizations l10n;
  final String password;
  final String confirm;

  @override
  Widget build(BuildContext context) {
    final p = password;
    final c = confirm;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AddBarberPasswordChecklistRow(
          label: l10n.addBarberChecklistMinLength,
          met: LocalizedInputValidators.addBarberPasswordRuleMinLengthMet(p),
        ),
        AddBarberPasswordChecklistRow(
          label: l10n.addBarberChecklistUppercase,
          met: LocalizedInputValidators.addBarberPasswordRuleUpperMet(p),
        ),
        AddBarberPasswordChecklistRow(
          label: l10n.addBarberChecklistLowercase,
          met: LocalizedInputValidators.addBarberPasswordRuleLowerMet(p),
        ),
        AddBarberPasswordChecklistRow(
          label: l10n.addBarberChecklistDigit,
          met: LocalizedInputValidators.addBarberPasswordRuleDigitMet(p),
        ),
        AddBarberPasswordChecklistRow(
          label: l10n.addBarberChecklistPasswordsMatch,
          met: LocalizedInputValidators.addBarberPasswordsMatchMet(p, c),
        ),
      ],
    );
  }
}

class AddBarberPasswordChecklistRow extends StatelessWidget {
  const AddBarberPasswordChecklistRow({
    super.key,
    required this.label,
    required this.met,
  });

  final String label;
  final bool met;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            met ? Icons.check_circle : Icons.circle_outlined,
            size: 20,
            color: met
                ? AuthPremiumColors.success
                : scheme.onSurfaceVariant.withValues(alpha: 0.45),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
