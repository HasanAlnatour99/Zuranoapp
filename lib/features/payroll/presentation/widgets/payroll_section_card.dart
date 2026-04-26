import 'package:flutter/material.dart';

import '../../../../core/motion/app_motion.dart';
import '../../../../core/motion/app_motion_widgets.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_surface_card.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

class PayrollSectionCard extends StatefulWidget {
  const PayrollSectionCard({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.expandable = false,
    this.initiallyExpanded = true,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final bool expandable;
  final bool initiallyExpanded;

  @override
  State<PayrollSectionCard> createState() => _PayrollSectionCardState();
}

class _PayrollSectionCardState extends State<PayrollSectionCard>
    with SingleTickerProviderStateMixin {
  late bool _expanded = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return AppSurfaceCard(
      borderRadius: AppRadius.large,
      showShadow: false,
      outlineOpacity: 0.18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(AppRadius.medium),
            onTap: widget.expandable
                ? () => setState(() => _expanded = !_expanded)
                : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  if (widget.expandable)
                    AnimatedRotation(
                      turns: _expanded ? 0.5 : 0,
                      duration: AppMotion.effectiveDuration(
                        context,
                        AppMotion.short,
                      ),
                      curve: AppMotion.entranceCurve,
                      child: Icon(
                        AppIcons.keyboard_arrow_up_rounded,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (widget.subtitle != null &&
              widget.subtitle!.trim().isNotEmpty) ...[
            const SizedBox(height: AppSpacing.small / 2),
            Text(
              widget.subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.medium),
          AnimatedSize(
            duration: AppMotion.effectiveDuration(
              context,
              AppMotion.sectionExpand,
            ),
            curve: AppMotion.emphasizedCurve,
            alignment: Alignment.topCenter,
            child: AppFadeThroughSwitcher(
              transitionKey: _expanded,
              child: _expanded
                  ? KeyedSubtree(
                      key: const ValueKey<String>('expanded'),
                      child: widget.child,
                    )
                  : const SizedBox(
                      key: ValueKey<String>('collapsed'),
                      width: double.infinity,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
