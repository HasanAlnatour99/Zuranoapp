import 'package:flutter/material.dart';

import '../motion/app_motion.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';

/// Consistent elevated surface: border, optional shadow, theme-aware fill.
///
/// When [onTap] is set and [animatePress] is true, applies a brief scale feedback
/// on press (reduced or skipped when [MediaQuery.disableAnimations] is true).
class AppSurfaceCard extends StatefulWidget {
  const AppSurfaceCard({
    required this.child,
    super.key,
    this.padding,
    this.margin,
    this.borderRadius,
    this.onTap,
    this.color,
    this.showShadow = true,
    this.showBorder = true,

    /// Outline alpha on [ColorScheme.outline] when [showBorder] is true.
    this.outlineOpacity = 0.38,
    this.shadowBlurRadius = 22,
    this.shadowYOffset = 10,
    this.shadowOpacity = 0.11,
    this.animatePress = true,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  static const EdgeInsetsGeometry _defaultPadding = EdgeInsets.all(
    AppSpacing.medium,
  );
  final double? borderRadius;
  final VoidCallback? onTap;
  final Color? color;
  final bool showShadow;
  final bool showBorder;
  final double outlineOpacity;
  final double shadowBlurRadius;
  final double shadowYOffset;
  final double shadowOpacity;
  final bool animatePress;

  @override
  State<AppSurfaceCard> createState() => _AppSurfaceCardState();
}

class _AppSurfaceCardState extends State<AppSurfaceCard> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (widget.onTap == null || !widget.animatePress) {
      return;
    }
    if (_pressed == value) {
      return;
    }
    setState(() => _pressed = value);
  }

  @override
  void didUpdateWidget(covariant AppSurfaceCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.onTap == null) {
      _pressed = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final radius = widget.borderRadius ?? AppRadius.xlarge;
    final fill = widget.color ?? scheme.surfaceContainer;

    final decoration = BoxDecoration(
      color: fill,
      borderRadius: BorderRadius.circular(radius),
      border: widget.showBorder
          ? Border.all(
              color: scheme.outline.withValues(alpha: widget.outlineOpacity),
            )
          : null,
      boxShadow: widget.showShadow
          ? [
              BoxShadow(
                color: scheme.shadow.withValues(alpha: widget.shadowOpacity),
                blurRadius: widget.shadowBlurRadius,
                offset: Offset(0, widget.shadowYOffset),
              ),
            ]
          : null,
    );

    final content = Padding(
      padding: widget.padding ?? AppSurfaceCard._defaultPadding,
      child: widget.child,
    );

    Widget card = DecoratedBox(decoration: decoration, child: content);

    if (widget.onTap != null) {
      card = Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(radius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(radius),
          child: card,
        ),
      );

      final usePress =
          widget.animatePress && !AppMotion.disableAnimations(context);
      final scale = usePress && _pressed
          ? AppMotion.interactionPressScale
          : 1.0;

      card = AnimatedScale(
        scale: scale,
        duration: AppMotion.effectiveDuration(context, AppMotion.short),
        curve: AppMotion.entranceCurve,
        child: Listener(
          behavior: HitTestBehavior.translucent,
          onPointerDown: (_) => _setPressed(true),
          onPointerUp: (_) => _setPressed(false),
          onPointerCancel: (_) => _setPressed(false),
          child: card,
        ),
      );
    }

    if (widget.margin != null) {
      card = Padding(padding: widget.margin!, child: card);
    }

    return card;
  }
}
