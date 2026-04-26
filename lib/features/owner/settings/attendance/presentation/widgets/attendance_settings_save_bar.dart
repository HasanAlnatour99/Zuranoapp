import 'package:flutter/material.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../l10n/app_localizations.dart';

/// Sticky bottom bar with the unified "Save changes" CTA.
class AttendanceSettingsSaveBar extends StatelessWidget {
  const AttendanceSettingsSaveBar({
    super.key,
    required this.dirty,
    required this.saving,
    required this.onSave,
  });

  final bool dirty;
  final bool saving;
  final Future<void> Function() onSave;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mediaPadding = MediaQuery.of(context).viewPadding.bottom;

    return AnimatedSlide(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      offset: dirty ? Offset.zero : const Offset(0, 1.2),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 180),
        opacity: dirty ? 1 : 0,
        child: IgnorePointer(
          ignoring: !dirty,
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 12, 20, 14 + mediaPadding),
            decoration: BoxDecoration(
              color: ZuranoPremiumUiColors.cardBackground,
              border: Border(
                top: BorderSide(color: ZuranoPremiumUiColors.border),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14111827),
                  blurRadius: 24,
                  offset: Offset(0, -6),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: saving ? null : () => onSave(),
                  style: FilledButton.styleFrom(
                    backgroundColor: ZuranoPremiumUiColors.primaryPurple,
                    disabledBackgroundColor: ZuranoPremiumUiColors.primaryPurple
                        .withValues(alpha: 0.6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: saving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          l10n.ownerAttendanceSettingsSave,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
