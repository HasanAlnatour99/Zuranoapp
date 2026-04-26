import 'package:flutter/material.dart';

abstract final class AppMotion {
  static const Duration short = Duration(milliseconds: 220);
  static const Duration medium = Duration(milliseconds: 280);
  static const Duration long = Duration(milliseconds: 360);
  static const Duration emphasized = Duration(milliseconds: 420);

  static const Duration cardEntrance = Duration(milliseconds: 280);
  static const Duration listEntrance = Duration(milliseconds: 240);
  static const Duration sectionExpand = Duration(milliseconds: 320);
  static const Duration switcher = Duration(milliseconds: 260);
  static const Duration containerTransform = Duration(milliseconds: 420);

  static const Duration staggerStep = Duration(milliseconds: 48);
  static const int maxStaggerSteps = 6;

  static const Curve entranceCurve = Curves.easeOutCubic;
  static const Curve exitCurve = Curves.easeInCubic;
  static const Curve emphasizedCurve = Curves.easeOutQuart;

  static const double cardSlideOffset = 12;
  static const double listSlideOffset = 10;
  static const double successScaleBegin = 0.96;

  /// Subtle “press in” for tappable cards and primary buttons (HIG-style feedback).
  static const double interactionPressScale = 0.985;

  static Duration staggeredDelay(
    int index, {
    Duration step = staggerStep,
    int maxSteps = maxStaggerSteps,
  }) {
    final safeIndex = index.clamp(0, maxSteps);
    return step * safeIndex;
  }

  static bool disableAnimations(BuildContext context) =>
      MediaQuery.maybeOf(context)?.disableAnimations ?? false;

  static Duration effectiveDuration(BuildContext context, Duration duration) =>
      disableAnimations(context) ? Duration.zero : duration;

  static Duration effectiveDelay(BuildContext context, Duration duration) =>
      disableAnimations(context) ? Duration.zero : duration;
}
