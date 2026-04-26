import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import 'app_motion.dart';
import 'package:barber_shop_app/core/ui/app_icons.dart';

typedef AppOpenContainerClosedBuilder =
    Widget Function(BuildContext context, VoidCallback openContainer);

class AppMotionPlayback extends StatefulWidget {
  const AppMotionPlayback({super.key, required this.child});

  final Widget child;

  static _AppMotionPlaybackState? _maybeOf(BuildContext context) =>
      context.findAncestorStateOfType<_AppMotionPlaybackState>();

  @override
  State<AppMotionPlayback> createState() => _AppMotionPlaybackState();
}

class _AppMotionPlaybackState extends State<AppMotionPlayback> {
  final Set<Object> _playedMotionIds = <Object>{};

  bool shouldAnimate(Object motionId) => _playedMotionIds.add(motionId);

  @override
  Widget build(BuildContext context) => widget.child;
}

class AppEntranceMotion extends StatefulWidget {
  const AppEntranceMotion({
    super.key,
    required this.child,
    required this.motionId,
    this.index = 0,
    this.duration = AppMotion.cardEntrance,
    this.slideOffset = AppMotion.cardSlideOffset,
    this.enabled = true,
  });

  final Widget child;
  final Object motionId;
  final int index;
  final Duration duration;
  final double slideOffset;
  final bool enabled;

  @override
  State<AppEntranceMotion> createState() => _AppEntranceMotionState();
}

class _AppEntranceMotionState extends State<AppEntranceMotion> {
  late final bool _shouldAnimate = _resolveShouldAnimate();

  bool _resolveShouldAnimate() {
    if (!widget.enabled) {
      return false;
    }
    final playback = AppMotionPlayback._maybeOf(context);
    return playback?.shouldAnimate(widget.motionId) ?? true;
  }

  @override
  Widget build(BuildContext context) {
    if (!_shouldAnimate || AppMotion.disableAnimations(context)) {
      return widget.child;
    }

    return Animate(
      key: ValueKey<Object>('motion-${widget.motionId}'),
      delay: AppMotion.effectiveDelay(
        context,
        AppMotion.staggeredDelay(widget.index),
      ),
      effects: <Effect<dynamic>>[
        FadeEffect(
          duration: AppMotion.effectiveDuration(context, widget.duration),
          curve: AppMotion.entranceCurve,
          begin: 0,
          end: 1,
        ),
        MoveEffect(
          duration: AppMotion.effectiveDuration(context, widget.duration),
          curve: AppMotion.entranceCurve,
          begin: Offset(0, widget.slideOffset),
          end: Offset.zero,
        ),
      ],
      child: widget.child,
    );
  }
}

class AppFadeThroughSwitcher extends StatelessWidget {
  const AppFadeThroughSwitcher({
    super.key,
    required this.child,
    required this.transitionKey,
    this.duration = AppMotion.switcher,
  });

  final Widget child;
  final Object transitionKey;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
      duration: AppMotion.effectiveDuration(context, duration),
      reverse: false,
      transitionBuilder:
          (
            Widget child,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return FadeThroughTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              fillColor: Colors.transparent,
              child: child,
            );
          },
      child: KeyedSubtree(key: ValueKey<Object>(transitionKey), child: child),
    );
  }
}

class AppSharedAxisSwitcher extends StatelessWidget {
  const AppSharedAxisSwitcher({
    super.key,
    required this.child,
    required this.transitionKey,
    this.duration = AppMotion.switcher,
    this.transitionType = SharedAxisTransitionType.horizontal,
  });

  final Widget child;
  final Object transitionKey;
  final Duration duration;
  final SharedAxisTransitionType transitionType;

  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
      duration: AppMotion.effectiveDuration(context, duration),
      reverse: false,
      transitionBuilder:
          (
            Widget child,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: transitionType,
              fillColor: Colors.transparent,
              child: child,
            );
          },
      child: KeyedSubtree(key: ValueKey<Object>(transitionKey), child: child),
    );
  }
}

class AppOpenContainerRoute extends StatelessWidget {
  const AppOpenContainerRoute({
    super.key,
    required this.closedBuilder,
    required this.openBuilder,
    this.borderRadius = AppRadius.large,
    this.transitionDuration = AppMotion.containerTransform,
    this.tappable = false,
  });

  final AppOpenContainerClosedBuilder closedBuilder;
  final CloseContainerBuilder openBuilder;
  final double borderRadius;
  final Duration transitionDuration;
  final bool tappable;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return OpenContainer(
      transitionDuration: AppMotion.effectiveDuration(
        context,
        transitionDuration,
      ),
      closedElevation: 0,
      openElevation: 0,
      closedColor: Colors.transparent,
      openColor: scheme.surface,
      middleColor: scheme.surface,
      tappable: tappable,
      closedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      openShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      closedBuilder: (context, openContainer) =>
          closedBuilder(context, openContainer),
      openBuilder: openBuilder,
    );
  }
}

class AppSuccessToastContent extends StatelessWidget {
  const AppSuccessToastContent({
    super.key,
    required this.message,
    this.icon = AppIcons.check_circle_rounded,
  });

  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(AppRadius.large),
            border: Border.all(color: scheme.primary.withValues(alpha: 0.22)),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.medium,
            vertical: AppSpacing.small + 2,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: scheme.primary, size: 18),
              const SizedBox(width: AppSpacing.small),
              Flexible(
                child: Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(
          duration: AppMotion.effectiveDuration(context, AppMotion.short),
          curve: AppMotion.entranceCurve,
        )
        .scale(
          begin: const Offset(
            AppMotion.successScaleBegin,
            AppMotion.successScaleBegin,
          ),
          end: const Offset(1, 1),
          duration: AppMotion.effectiveDuration(context, AppMotion.short),
          curve: AppMotion.entranceCurve,
        );
  }
}

void showAppSuccessSnackBar(BuildContext context, String message) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 0,
      backgroundColor: Colors.transparent,
      content: AppSuccessToastContent(message: message),
    ),
  );
}
