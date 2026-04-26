import 'package:flutter/material.dart';

import '../../../../core/theme/auth_premium_tokens.dart';

/// Shared auth layout: theme [ColorScheme.surface], safe area, scroll, keyboard inset.
class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.child,
    this.bottom,
    this.padding = const EdgeInsets.symmetric(
      horizontal: AuthPremiumLayout.screenPadding,
    ),
  });

  final Widget child;
  final Widget? bottom;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;

    return DecoratedBox(
      decoration: BoxDecoration(color: scheme.surface),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        behavior: HitTestBehavior.deferToChild,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: padding.add(
                      EdgeInsets.only(bottom: keyboard > 0 ? 16 : 8),
                    ),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: child,
                  ),
                ),
                if (bottom != null)
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      AuthPremiumLayout.screenPadding,
                      8,
                      AuthPremiumLayout.screenPadding,
                      12 + bottomInset,
                    ),
                    child: bottom!,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
