import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

/// Material 3 [Switch] with Zurano purple track/thumb.
class ZuranoSwitch extends StatelessWidget {
  const ZuranoSwitch({super.key, required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeThumbColor: Colors.white,
      activeTrackColor: ZuranoPremiumUiColors.primaryPurple,
      inactiveThumbColor: ZuranoPremiumUiColors.textSecondary,
      inactiveTrackColor: ZuranoPremiumUiColors.border,
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
    );
  }
}
