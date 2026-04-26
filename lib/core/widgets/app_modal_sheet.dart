import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import 'keyboard_safe_form_scaffold.dart';

Future<T?> showAppModalBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool expand = false,
  bool useRootNavigator = false,
  bool isDismissible = true,
  bool enableDrag = true,
}) {
  final scheme = Theme.of(context).colorScheme;
  return showMaterialModalBottomSheet<T>(
    context: context,
    expand: expand,
    useRootNavigator: useRootNavigator,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    backgroundColor: Colors.transparent,
    barrierColor: scheme.scrim.withValues(alpha: 0.5),
    builder: (modalContext) =>
        AppModalSheetContainer(expand: expand, child: builder(modalContext)),
  );
}

class AppModalSheetContainer extends StatelessWidget {
  const AppModalSheetContainer({
    required this.child,
    super.key,
    this.showHandle = true,

    /// When true (e.g. full-height modal), the body is placed in an [Expanded]
    /// so scroll views get bounded vertical constraints and avoid overflow.
    this.expand = false,
  });

  final Widget child;
  final bool showHandle;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final handle = <Widget>[
      if (showHandle) ...[
        const SizedBox(height: AppSpacing.small),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: scheme.outline.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        const SizedBox(height: AppSpacing.small),
      ],
    ];

    final paddedBody = AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: child,
    );

    return SafeArea(
      top: false,
      child: Material(
        color: scheme.surfaceContainer,
        surfaceTintColor: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xlarge),
          ),
        ),
        child: expand
            ? Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ...handle,
                  Expanded(child: paddedBody),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [...handle, paddedBody],
              ),
      ),
    );
  }
}

/// Scrollable body for [showModalBottomSheet] forms (`isScrollControlled: true`)
/// when not using [showAppModalBottomSheet]. Applies safe area, keyboard inset,
/// and drag-to-dismiss. Prefer [showAppModalBottomSheet] for styled chrome.
class AppRawBottomSheetFormBody extends StatelessWidget {
  const AppRawBottomSheetFormBody({
    super.key,
    required this.child,
    this.padding,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding:
              padding ??
              const EdgeInsets.fromLTRB(
                AppSpacing.large,
                AppSpacing.large,
                AppSpacing.large,
                AppSpacing.large + kKeyboardSafePaddingExtra,
              ),
          child: child,
        ),
      ),
    );
  }
}
