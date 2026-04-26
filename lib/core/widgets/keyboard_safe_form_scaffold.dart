import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// Extra space below the last field when the keyboard is closed (and stacked on
/// [MediaQuery.viewInsets.bottom] when it is open).
const double kKeyboardSafePaddingExtra = 24;

/// Bottom inset for full-screen scrollable forms: keyboard height + [extra].
double keyboardSafeBottomPadding(
  BuildContext context, {
  double extra = kKeyboardSafePaddingExtra,
}) {
  return MediaQuery.viewInsetsOf(context).bottom + extra;
}

/// Full-page pattern: [LayoutBuilder] + [SingleChildScrollView] + [ConstrainedBox]
/// so short forms still fill the viewport and long forms scroll with the keyboard.
///
/// Use inside [Scaffold] body (typically wrapped in [SafeArea] via [AppFormScaffold]).
class KeyboardSafeScrollForm extends StatelessWidget {
  const KeyboardSafeScrollForm({
    super.key,
    required this.child,
    this.horizontalPadding = AppSpacing.large,
    this.topPadding = AppSpacing.large,
    this.bottomPaddingExtra = kKeyboardSafePaddingExtra,
    this.physics,
  });

  final Widget child;
  final double horizontalPadding;
  final double topPadding;
  final double bottomPaddingExtra;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
        return SingleChildScrollView(
          physics: physics,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            topPadding,
            horizontalPadding,
            bottomInset + bottomPaddingExtra,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: child,
          ),
        );
      },
    );
  }
}

/// [Scaffold] + [SafeArea] + [KeyboardSafeScrollForm] for routed form screens.
class AppFormScaffold extends StatelessWidget {
  const AppFormScaffold({
    super.key,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = true,
    required this.child,
    this.horizontalPadding = AppSpacing.large,
    this.topPadding = AppSpacing.large,
    this.bottomPaddingExtra = kKeyboardSafePaddingExtra,
  });

  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Color? backgroundColor;
  final bool resizeToAvoidBottomInset;
  final Widget child;
  final double horizontalPadding;
  final double topPadding;
  final double bottomPaddingExtra;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: appBar,
      backgroundColor: backgroundColor,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      body: SafeArea(
        child: KeyboardSafeScrollForm(
          horizontalPadding: horizontalPadding,
          topPadding: topPadding,
          bottomPaddingExtra: bottomPaddingExtra,
          child: child,
        ),
      ),
    );
  }
}

/// Scrollable body for [showAppModalBottomSheet] / [AppModalSheetContainer].
/// The container already applies keyboard [AnimatedPadding]; this adds
/// drag-to-dismiss, tap-outside unfocus, and comfortable trailing padding.
class KeyboardSafeModalFormScroll extends StatelessWidget {
  const KeyboardSafeModalFormScroll({
    super.key,
    required this.child,
    this.padding,
    this.onTapOutsideToUnfocus = true,
    this.physics,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool onTapOutsideToUnfocus;
  final ScrollPhysics? physics;

  static EdgeInsetsGeometry defaultPadding() {
    return const EdgeInsets.fromLTRB(
      AppSpacing.large,
      AppSpacing.large,
      AppSpacing.large,
      AppSpacing.large + kKeyboardSafePaddingExtra,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scroll = SingleChildScrollView(
      physics: physics,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: padding ?? defaultPadding(),
      child: child,
    );

    if (!onTapOutsideToUnfocus) {
      return scroll;
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      behavior: HitTestBehavior.deferToChild,
      child: scroll,
    );
  }
}
