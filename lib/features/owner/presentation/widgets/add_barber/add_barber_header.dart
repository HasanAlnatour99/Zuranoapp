import 'package:flutter/material.dart';

import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';

class AddBarberHeader extends StatelessWidget {
  const AddBarberHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onBack,
    this.compact = false,
  });

  final String title;
  final String subtitle;
  final VoidCallback onBack;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final topPad = compact ? AppSpacing.small : AppSpacing.medium;
    final bottomPad = compact ? AppSpacing.medium : AppSpacing.large;
    final titleSize = compact ? 20.0 : 22.0;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppRadius.xlarge),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: AlignmentDirectional.topStart,
                end: AlignmentDirectional.bottomEnd,
                colors: [
                  scheme.primary,
                  Color.lerp(scheme.primary, scheme.secondary, 0.35)!,
                ],
              ),
            ),
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(
                  4,
                  topPad,
                  AppSpacing.small,
                  bottomPad,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: IconButton(
                        onPressed: onBack,
                        style: IconButton.styleFrom(
                          foregroundColor: scheme.onPrimary,
                          backgroundColor: scheme.onPrimary.withValues(
                            alpha: 0.12,
                          ),
                        ),
                        icon: const Icon(Icons.arrow_back_rounded),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                        start: AppSpacing.small,
                        end: AppSpacing.large,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            textAlign: TextAlign.start,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: scheme.onPrimary,
                              fontWeight: FontWeight.w800,
                              fontSize: titleSize,
                              height: 1.15,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.small),
                          Text(
                            subtitle,
                            textAlign: TextAlign.start,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: scheme.onPrimary.withValues(alpha: 0.92),
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          PositionedDirectional(
            end: -40,
            top: -24,
            child: IgnorePointer(
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: scheme.onPrimary.withValues(alpha: 0.06),
                ),
              ),
            ),
          ),
          PositionedDirectional(
            start: -30,
            bottom: -20,
            child: IgnorePointer(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: scheme.onPrimary.withValues(alpha: 0.05),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
