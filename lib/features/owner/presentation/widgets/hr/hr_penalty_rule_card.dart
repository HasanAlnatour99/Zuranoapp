import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../settings/presentation/widgets/zurano/zurano_icon_box.dart';
import '../../../../settings/presentation/widgets/zurano/zurano_switch.dart';

class HrPenaltyRuleCard extends StatelessWidget {
  const HrPenaltyRuleCard({
    super.key,
    required this.title,
    required this.icon,
    required this.enabledChipOnLabel,
    required this.enabledChipOffLabel,
    required this.enabled,
    required this.firstLabel,
    required this.firstValue,
    required this.secondLabel,
    required this.secondValue,
    required this.appliesWhenLabel,
    required this.appliesWhenBody,
    required this.onToggle,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final String enabledChipOnLabel;
  final String enabledChipOffLabel;
  final bool enabled;
  final String firstLabel;
  final String firstValue;
  final String secondLabel;
  final String secondValue;
  final String appliesWhenLabel;
  final String appliesWhenBody;
  final ValueChanged<bool> onToggle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: ZuranoPremiumUiColors.cardBackground,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: ZuranoPremiumUiColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F111827),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 6,
              decoration: const BoxDecoration(
                color: ZuranoPremiumUiColors.primaryPurple,
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(22),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 10, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: onTap,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              ZuranoIconBox(icon: icon, size: 42, iconSize: 22),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  title,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: ZuranoPremiumUiColors.textPrimary,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: ZuranoPremiumUiColors.softPurple,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  enabled
                                      ? enabledChipOnLabel
                                      : enabledChipOffLabel,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: ZuranoPremiumUiColors.deepPurple,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right_rounded,
                                color: ZuranoPremiumUiColors.textSecondary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _RuleMetric(
                            label: firstLabel,
                            value: firstValue,
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: ZuranoPremiumUiColors.border,
                        ),
                        Expanded(
                          child: _RuleMetric(
                            label: secondLabel,
                            value: secondValue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                appliesWhenLabel,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: ZuranoPremiumUiColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                appliesWhenBody,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: ZuranoPremiumUiColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ZuranoSwitch(value: enabled, onChanged: onToggle),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RuleMetric extends StatelessWidget {
  const _RuleMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: ZuranoPremiumUiColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: ZuranoPremiumUiColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
