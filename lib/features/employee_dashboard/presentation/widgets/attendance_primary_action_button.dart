import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../application/employee_today_attendance_vm.dart';

class AttendancePrimaryActionButton extends StatefulWidget {
  const AttendancePrimaryActionButton({
    super.key,
    required this.actionType,
    required this.enabled,
    required this.onTap,
    this.subtitleOverride,
    this.loading = false,
  });

  final EmployeePunchActionType actionType;
  final bool enabled;
  final VoidCallback? onTap;
  final String? subtitleOverride;
  final bool loading;

  @override
  State<AttendancePrimaryActionButton> createState() =>
      _AttendancePrimaryActionButtonState();
}

class _AttendancePrimaryActionButtonState
    extends State<AttendancePrimaryActionButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = _title(l10n, widget.actionType);
    final subtitle =
        widget.subtitleOverride ?? _subtitle(l10n, widget.actionType);
    final isRtl = switch (Directionality.of(context)) {
      ui.TextDirection.rtl => true,
      ui.TextDirection.ltr => false,
    };

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 220),
      opacity: widget.enabled ? 1 : 0.55,
      child: GestureDetector(
        onTapDown: widget.enabled
            ? (_) => setState(() => _pressed = true)
            : null,
        onTapUp: widget.enabled
            ? (_) => setState(() => _pressed = false)
            : null,
        onTapCancel: widget.enabled
            ? () => setState(() => _pressed = false)
            : null,
        onTap: widget.enabled ? widget.onTap : null,
        child: AnimatedScale(
          scale: _pressed ? 0.985 : 1,
          duration: const Duration(milliseconds: 120),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 260),
            curve: Curves.fastOutSlowIn,
            height: 76,
            padding: const EdgeInsetsDirectional.only(start: 14, end: 12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6D28D9), Color(0xFF8B5CF6)],
                begin: AlignmentDirectional.centerStart,
                end: AlignmentDirectional.centerEnd,
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFDDD6FE)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6D28D9).withValues(alpha: 0.22),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 260),
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 240),
                    child: widget.loading
                        ? const Padding(
                            key: ValueKey('loading'),
                            padding: EdgeInsets.all(14),
                            child: CircularProgressIndicator(strokeWidth: 2.4),
                          )
                        : Icon(
                            _icon(widget.actionType),
                            key: ValueKey(widget.actionType),
                            color: Colors.white,
                            size: 26,
                          ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 260),
                    child: Column(
                      key: ValueKey('${widget.actionType}_$subtitle'),
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFFEDE9FE),
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  isRtl
                      ? Icons.chevron_left_rounded
                      : Icons.chevron_right_rounded,
                  size: 28,
                  color: const Color(0xFFEDE9FE),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _title(AppLocalizations l10n, EmployeePunchActionType type) {
    switch (type) {
      case EmployeePunchActionType.punchIn:
        return l10n.employeeTodayPunchIn;
      case EmployeePunchActionType.punchOut:
        return l10n.employeeTodayPunchOut;
      case EmployeePunchActionType.breakIn:
        return l10n.employeeTodayBreakIn;
      case EmployeePunchActionType.breakOut:
        return l10n.employeeTodayBreakOut;
      case EmployeePunchActionType.none:
        return l10n.employeeTodayNoAction;
    }
  }

  String _subtitle(AppLocalizations l10n, EmployeePunchActionType type) {
    switch (type) {
      case EmployeePunchActionType.punchIn:
        return l10n.employeeTodayPrimaryPunchInSubtitle;
      case EmployeePunchActionType.punchOut:
        return l10n.employeeTodayPrimaryPunchOutSubtitle;
      case EmployeePunchActionType.breakIn:
        return l10n.employeeTodayPrimaryBreakInSubtitle;
      case EmployeePunchActionType.breakOut:
        return l10n.employeeTodayPrimaryBreakOutSubtitle;
      case EmployeePunchActionType.none:
        return l10n.employeeTodayActionUnavailable;
    }
  }

  IconData _icon(EmployeePunchActionType type) {
    switch (type) {
      case EmployeePunchActionType.punchIn:
        return Icons.login_rounded;
      case EmployeePunchActionType.punchOut:
        return Icons.logout_rounded;
      case EmployeePunchActionType.breakIn:
        return Icons.play_circle_rounded;
      case EmployeePunchActionType.breakOut:
        return Icons.free_breakfast_rounded;
      case EmployeePunchActionType.none:
        return Icons.block_rounded;
    }
  }
}
