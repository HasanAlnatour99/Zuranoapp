import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_motion.dart';

CustomTransitionPage<void> appFadeThroughPage({
  required LocalKey key,
  required Widget child,
  Duration duration = AppMotion.medium,
  Duration reverseDuration = AppMotion.short,
}) {
  return CustomTransitionPage<void>(
    key: key,
    transitionDuration: duration,
    reverseTransitionDuration: reverseDuration,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeThroughTransition(
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        fillColor: Theme.of(context).colorScheme.surface,
        child: child,
      );
    },
  );
}

CustomTransitionPage<void> appSharedAxisPage({
  required LocalKey key,
  required Widget child,
  SharedAxisTransitionType transitionType = SharedAxisTransitionType.horizontal,
  Duration duration = AppMotion.long,
  Duration reverseDuration = AppMotion.medium,
}) {
  return CustomTransitionPage<void>(
    key: key,
    transitionDuration: duration,
    reverseTransitionDuration: reverseDuration,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SharedAxisTransition(
        animation: animation,
        secondaryAnimation: secondaryAnimation,
        transitionType: transitionType,
        fillColor: Theme.of(context).colorScheme.surface,
        child: child,
      );
    },
  );
}

CustomTransitionPage<void> appFadePage({
  required LocalKey key,
  required Widget child,
  Duration duration = AppMotion.medium,
  Duration reverseDuration = AppMotion.short,
}) {
  return CustomTransitionPage<void>(
    key: key,
    transitionDuration: duration,
    reverseTransitionDuration: reverseDuration,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: AppMotion.entranceCurve,
        ),
        child: child,
      );
    },
  );
}
