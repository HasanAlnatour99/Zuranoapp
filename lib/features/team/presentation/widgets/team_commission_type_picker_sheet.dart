import 'package:flutter/material.dart';

import '../../../employees/domain/commission_type.dart';
import '../../../../l10n/app_localizations.dart';

class TeamCommissionTypePickerSheet extends StatelessWidget {
  const TeamCommissionTypePickerSheet({super.key, required this.selectedType});

  final CommissionType selectedType;

  static const Color _textDark = Color(0xFF111827);
  static const Color _textMuted = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 46,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const _PickerIconBubble(
                  icon: Icons.account_balance_wallet_rounded,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.teamCommissionPickerTitle,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: _textDark,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        l10n.teamCommissionPickerSubtitle,
                        style: TextStyle(fontSize: 14, color: _textMuted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _CommissionTypeCard(
              title: l10n.teamCommissionPickerPercentageTitle,
              subtitle: l10n.teamCommissionPickerPercentageSubtitle,
              icon: Icons.percent_rounded,
              selected: selectedType == CommissionType.percentage,
              onTap: () => Navigator.pop(context, CommissionType.percentage),
            ),
            const SizedBox(height: 12),
            _CommissionTypeCard(
              title: l10n.teamCommissionPickerFixedTitle,
              subtitle: l10n.teamCommissionPickerFixedSubtitle,
              icon: Icons.payments_rounded,
              selected: selectedType == CommissionType.fixed,
              onTap: () => Navigator.pop(context, CommissionType.fixed),
            ),
            const SizedBox(height: 12),
            _CommissionTypeCard(
              title: l10n.teamCommissionPickerMixedTitle,
              subtitle: l10n.teamCommissionPickerMixedSubtitle,
              icon: Icons.add_card_rounded,
              selected: selectedType == CommissionType.percentagePlusFixed,
              onTap: () =>
                  Navigator.pop(context, CommissionType.percentagePlusFixed),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommissionTypeCard extends StatelessWidget {
  const _CommissionTypeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  static const Color _purple = Color(0xFF7C3AED);
  static const Color _softPurple = Color(0xFFF4ECFF);
  static const Color _border = Color(0xFFE5E7EB);
  static const Color _textDark = Color(0xFF111827);
  static const Color _textMuted = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: selected ? _softPurple : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: selected ? _purple : _border,
          width: selected ? 1.6 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: selected
                ? _purple.withValues(alpha: 0.14)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: selected ? 18 : 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _PickerIconBubble(icon: icon),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w800,
                          color: _textDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.35,
                          color: _textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: selected
                      ? const Icon(
                          Icons.check_circle_rounded,
                          key: ValueKey('selected'),
                          color: _purple,
                          size: 26,
                        )
                      : const Icon(
                          Icons.radio_button_unchecked_rounded,
                          key: ValueKey('unselected'),
                          color: Color(0xFFD1D5DB),
                          size: 24,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PickerIconBubble extends StatelessWidget {
  const _PickerIconBubble({required this.icon});

  final IconData icon;

  static const _purple = Color(0xFF7C3AED);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE9DDFE)),
      ),
      child: Icon(icon, color: _purple, size: 23),
    );
  }
}
