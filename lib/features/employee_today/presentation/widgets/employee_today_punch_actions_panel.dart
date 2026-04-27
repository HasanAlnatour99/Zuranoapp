import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../employee_dashboard/domain/enums/attendance_punch_type.dart';
import '../employee_today_theme.dart';

/// Modern punch grid for Employee Today — soft tiles, clear hierarchy, ripples,
/// and light stagger + press feedback (see ANIMATION-RULE).
class EmployeeTodayPunchActionsPanel extends StatefulWidget {
  const EmployeeTodayPunchActionsPanel({
    super.key,
    required this.types,
    required this.allowed,
    required this.busyType,
    required this.labelFor,
    required this.iconFor,
    required this.onPunch,
  });

  final List<AttendancePunchType> types;
  final Set<AttendancePunchType> allowed;
  final AttendancePunchType? busyType;
  final String Function(AttendancePunchType) labelFor;
  final IconData Function(AttendancePunchType) iconFor;
  final Future<void> Function(AttendancePunchType type) onPunch;

  static const _radius = 20.0;
  static const _iconCircle = 46.0;

  @override
  State<EmployeeTodayPunchActionsPanel> createState() =>
      _EmployeeTodayPunchActionsPanelState();
}

class _EmployeeTodayPunchActionsPanelState
    extends State<EmployeeTodayPunchActionsPanel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entrance;

  static const _entranceDuration = Duration(milliseconds: 420);

  @override
  void initState() {
    super.initState();
    _entrance = AnimationController(vsync: this, duration: _entranceDuration)
      ..forward();
  }

  @override
  void didUpdateWidget(covariant EmployeeTodayPunchActionsPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(widget.types, oldWidget.types)) {
      _entrance.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _entrance.dispose();
    super.dispose();
  }

  Widget _staggeredTile({
    required int index,
    required int total,
    required Widget child,
  }) {
    if (total <= 0) {
      return child;
    }
    return AnimatedBuilder(
      animation: _entrance,
      builder: (context, _) {
        final begin = index / total;
        final end = (index + 1) / total;
        final t = Interval(
          begin,
          end,
          curve: Curves.easeOutCubic,
        ).transform(_entrance.value);
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, 10 * (1 - t)),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.types.isEmpty) {
      return const SizedBox.shrink();
    }

    final total = widget.types.length;
    var index = 0;
    final rows = <Widget>[];
    for (var i = 0; i < widget.types.length; i += 2) {
      final a = widget.types[i];
      final b = i + 1 < widget.types.length ? widget.types[i + 1] : null;
      final isLastPair = i + 2 >= widget.types.length;
      rows.add(
        Padding(
          padding: EdgeInsets.only(bottom: isLastPair ? 0 : 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _staggeredTile(
                  index: index++,
                  total: total,
                  child: _PunchTile(
                    type: a,
                    allowed: widget.allowed,
                    busyType: widget.busyType,
                    labelFor: widget.labelFor,
                    iconFor: widget.iconFor,
                    onPunch: widget.onPunch,
                  ),
                ),
              ),
              if (b != null) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: _staggeredTile(
                    index: index++,
                    total: total,
                    child: _PunchTile(
                      type: b,
                      allowed: widget.allowed,
                      busyType: widget.busyType,
                      labelFor: widget.labelFor,
                      iconFor: widget.iconFor,
                      onPunch: widget.onPunch,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows,
    );
  }
}

class _PunchTile extends StatefulWidget {
  const _PunchTile({
    required this.type,
    required this.allowed,
    required this.busyType,
    required this.labelFor,
    required this.iconFor,
    required this.onPunch,
  });

  final AttendancePunchType type;
  final Set<AttendancePunchType> allowed;
  final AttendancePunchType? busyType;
  final String Function(AttendancePunchType) labelFor;
  final IconData Function(AttendancePunchType) iconFor;
  final Future<void> Function(AttendancePunchType type) onPunch;

  @override
  State<_PunchTile> createState() => _PunchTileState();
}

class _PunchTileState extends State<_PunchTile> {
  bool _pressed = false;

  @override
  void didUpdateWidget(covariant _PunchTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.busyType != null || !widget.allowed.contains(widget.type)) {
      _pressed = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final canTap =
        widget.allowed.contains(widget.type) && widget.busyType == null;
    final loading = widget.busyType == widget.type;
    final enabledLook = canTap || loading;
    final actionLabel = widget.labelFor(widget.type);

    final borderColor = enabledLook
        ? EmployeeTodayColors.primaryPurple.withValues(alpha: 0.38)
        : EmployeeTodayColors.cardBorder.withValues(alpha: 0.9);
    final fill = enabledLook
        ? EmployeeTodayColors.primaryPurple.withValues(alpha: 0.07)
        : EmployeeTodayColors.punchTileDisabledSurface;
    final iconBg = enabledLook
        ? EmployeeTodayColors.primaryPurple.withValues(alpha: 0.14)
        : EmployeeTodayColors.punchTileDisabledIconCircle;
    final iconFg = enabledLook
        ? EmployeeTodayColors.primaryPurple
        : EmployeeTodayColors.mutedText;
    final titleColor = enabledLook
        ? EmployeeTodayColors.deepText
        : EmployeeTodayColors.mutedText;

    return Semantics(
      button: true,
      enabled: canTap || loading,
      label: actionLabel,
      child: ExcludeSemantics(
        child: AnimatedScale(
          scale: _pressed ? 0.97 : 1,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(
                EmployeeTodayPunchActionsPanel._radius,
              ),
              onTapDown: canTap && !loading
                  ? (_) {
                      setState(() => _pressed = true);
                    }
                  : null,
              onTapUp: canTap && !loading
                  ? (_) {
                      setState(() => _pressed = false);
                    }
                  : null,
              onTapCancel: canTap && !loading
                  ? () {
                      setState(() => _pressed = false);
                    }
                  : null,
              onTap: !canTap || loading
                  ? null
                  : () {
                      widget.onPunch(widget.type);
                    },
              child: Ink(
                decoration: BoxDecoration(
                  color: fill,
                  borderRadius: BorderRadius.circular(
                    EmployeeTodayPunchActionsPanel._radius,
                  ),
                  border: Border.all(color: borderColor),
                  boxShadow: enabledLook
                      ? [
                          BoxShadow(
                            color: EmployeeTodayColors.primaryPurple.withValues(
                              alpha: 0.06,
                            ),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 10, 12),
                  child: Row(
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 180),
                        switchInCurve: Curves.easeOut,
                        switchOutCurve: Curves.easeIn,
                        transitionBuilder: (child, animation) =>
                            FadeTransition(opacity: animation, child: child),
                        child: Container(
                          key: ValueKey<bool>(loading),
                          width: EmployeeTodayPunchActionsPanel._iconCircle,
                          height: EmployeeTodayPunchActionsPanel._iconCircle,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: iconBg,
                            shape: BoxShape.circle,
                          ),
                          child: loading
                              ? const Padding(
                                  padding: EdgeInsets.all(12),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                    color: EmployeeTodayColors.primaryPurple,
                                  ),
                                )
                              : Icon(
                                  widget.iconFor(widget.type),
                                  color: iconFg,
                                  size: 22,
                                ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOutCubic,
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            height: 1.25,
                            color: titleColor,
                            letterSpacing: -0.2,
                          ),
                          child: Text(
                            actionLabel,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      if (enabledLook && !loading)
                        Icon(
                          Icons.chevron_right_rounded,
                          color: EmployeeTodayColors.mutedText.withValues(
                            alpha: 0.7,
                          ),
                          size: 22,
                        ),
                    ],
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
