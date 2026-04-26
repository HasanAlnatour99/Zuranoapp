import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../motion/app_motion.dart';

/// Brand gradient and outline colors for app buttons.
abstract final class AppButtonColors {
  static const Color gradientStart = Color(0xFF7C3AED);
  static const Color gradientEnd = Color(0xFF8B5CF6);
  static const Color accent = Color(0xFF7C3AED);
}

enum AppButtonType { primary, secondary }

enum AppButtonSize {
  small(40),
  medium(48),
  large(56);

  const AppButtonSize(this.height);
  final double height;
}

/// Full-width CTA with primary (gradient) and secondary (outlined) styles,
/// loading/disabled states, optional leading icon, haptics, and press scale.
///
/// Optional enhancement: animate the gradient stops or direction on press/focus
/// (e.g. [AnimationController] + custom painter) without changing this API.
class AppButton extends StatefulWidget {
  const AppButton({
    required this.text,
    required this.onPressed,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.large,
    this.isLoading = false,
    this.isDisabled = false,
    this.leadingIcon,
    super.key,
  });

  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final AppButtonSize size;
  final bool isLoading;
  final bool isDisabled;
  final IconData? leadingIcon;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  static const double _borderRadius = 18;
  static const double _secondaryBorderWidth = 1.5;
  static const double _horizontalPadding = 24;
  static const double _iconGap = 10;
  static const double _pressScale = 0.97;

  static const LinearGradient _primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [AppButtonColors.gradientStart, AppButtonColors.gradientEnd],
  );

  static const Color _disabledBackground = Color(0xFFE0E0E0);
  static const Color _disabledForeground = Color(0xFF757575);

  bool _pressed = false;

  bool get _enabled =>
      !widget.isLoading && !widget.isDisabled && widget.onPressed != null;

  void _setPressed(bool value) {
    if (!_enabled) {
      return;
    }
    if (_pressed == value) {
      return;
    }
    setState(() => _pressed = value);
  }

  @override
  void didUpdateWidget(covariant AppButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_enabled) {
      _pressed = false;
    }
  }

  void _handleTap() {
    if (!_enabled) {
      return;
    }
    HapticFeedback.lightImpact();
    widget.onPressed?.call();
  }

  double _iconSize() {
    switch (widget.size) {
      case AppButtonSize.small:
        return 18;
      case AppButtonSize.medium:
        return 20;
      case AppButtonSize.large:
        return 22;
    }
  }

  double _progressSize() {
    switch (widget.size) {
      case AppButtonSize.small:
        return 18;
      case AppButtonSize.medium:
        return 20;
      case AppButtonSize.large:
        return 22;
    }
  }

  Widget _buildLabel(Color foreground) {
    final style =
        Theme.of(context).textTheme.labelLarge?.copyWith(
          color: foreground,
          fontWeight: FontWeight.w600,
        ) ??
        TextStyle(color: foreground, fontWeight: FontWeight.w600);

    if (widget.leadingIcon == null) {
      return Text(widget.text, style: style, textAlign: TextAlign.center);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(widget.leadingIcon, size: _iconSize(), color: foreground),
        SizedBox(width: _iconGap),
        Flexible(
          child: Text(
            widget.text,
            style: style,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildLoading(Color indicatorColor) {
    return SizedBox(
      height: _progressSize(),
      width: _progressSize(),
      child: CircularProgressIndicator(
        strokeWidth: 2.4,
        valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
      ),
    );
  }

  List<BoxShadow>? _primaryShadow(bool show) {
    if (!show) {
      return null;
    }
    return [
      BoxShadow(
        color: AppButtonColors.gradientStart.withValues(alpha: 0.18),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final anim = !AppMotion.disableAnimations(context);
    final scale = anim && _pressed && _enabled ? _pressScale : 1.0;

    final isPrimary = widget.type == AppButtonType.primary;
    final primaryLooksActive =
        isPrimary &&
        (widget.isLoading || (!widget.isDisabled && widget.onPressed != null));
    final showPrimaryShadow = primaryLooksActive;

    late final Widget child;

    if (widget.isLoading) {
      child = isPrimary
          ? _buildLoading(Colors.white)
          : _buildLoading(AppButtonColors.accent);
    } else if (!_enabled) {
      child = _buildLabel(_disabledForeground);
    } else if (isPrimary) {
      child = _buildLabel(Colors.white);
    } else {
      child = _buildLabel(AppButtonColors.accent);
    }

    final height = widget.size.height;

    final content = ClipRRect(
      borderRadius: BorderRadius.circular(_borderRadius),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _enabled ? _handleTap : null,
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_borderRadius),
          ),
          splashColor: isPrimary
              ? Colors.white.withValues(alpha: 0.18)
              : AppButtonColors.accent.withValues(alpha: 0.12),
          highlightColor: isPrimary
              ? Colors.white.withValues(alpha: 0.12)
              : AppButtonColors.accent.withValues(alpha: 0.08),
          child: Ink(
            decoration: _decoration(isPrimary),
            child: SizedBox(
              width: double.infinity,
              height: height,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: _horizontalPadding,
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    return AnimatedScale(
      scale: scale,
      duration: AppMotion.effectiveDuration(context, AppMotion.short),
      curve: AppMotion.entranceCurve,
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) => _setPressed(true),
        onPointerUp: (_) => _setPressed(false),
        onPointerCancel: (_) => _setPressed(false),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_borderRadius),
            boxShadow: _primaryShadow(showPrimaryShadow),
          ),
          child: content,
        ),
      ),
    );
  }

  BoxDecoration _decoration(bool isPrimary) {
    if (widget.isLoading) {
      if (isPrimary) {
        return BoxDecoration(
          gradient: _primaryGradient,
          borderRadius: BorderRadius.circular(_borderRadius),
        );
      }
      return BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(_borderRadius),
        border: Border.all(
          color: AppButtonColors.accent,
          width: _secondaryBorderWidth,
        ),
      );
    }

    final inactive = widget.isDisabled || widget.onPressed == null;
    if (inactive) {
      if (isPrimary) {
        return BoxDecoration(
          color: _disabledBackground,
          borderRadius: BorderRadius.circular(_borderRadius),
        );
      }
      return BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(_borderRadius),
        border: Border.all(
          color: _disabledForeground.withValues(alpha: 0.45),
          width: _secondaryBorderWidth,
        ),
      );
    }

    if (isPrimary) {
      return BoxDecoration(
        gradient: _primaryGradient,
        borderRadius: BorderRadius.circular(_borderRadius),
      );
    }
    return BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(_borderRadius),
      border: Border.all(
        color: AppButtonColors.accent,
        width: _secondaryBorderWidth,
      ),
    );
  }
}
