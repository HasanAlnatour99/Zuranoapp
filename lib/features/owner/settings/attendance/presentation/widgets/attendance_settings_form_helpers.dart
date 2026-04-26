import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../core/theme/app_colors.dart';
import '../../../../../settings/presentation/widgets/zurano/zurano_switch.dart';

/// Settings-style row: title + optional subtitle + Zurano switch.
class AttendanceSwitchRow extends StatelessWidget {
  const AttendanceSwitchRow({
    super.key,
    required this.label,
    this.subtitle,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = enabled
        ? ZuranoPremiumUiColors.textPrimary
        : ZuranoPremiumUiColors.textSecondary;
    return Opacity(
      opacity: enabled ? 1 : 0.55,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: ZuranoPremiumUiColors.textSecondary,
                      height: 1.35,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          ZuranoSwitch(value: value, onChanged: enabled ? onChanged : (_) {}),
        ],
      ),
    );
  }
}

/// Compact ± stepper used for "max punches", "max breaks" etc.
class AttendanceStepperRow extends StatelessWidget {
  const AttendanceStepperRow({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.enabled = true,
  });

  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canDec = enabled && value > min;
    final canInc = enabled && value < max;
    return Opacity(
      opacity: enabled ? 1 : 0.55,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: ZuranoPremiumUiColors.textPrimary,
              ),
            ),
          ),
          _StepperButton(
            icon: Icons.remove_rounded,
            onTap: canDec ? () => onChanged(value - 1) : null,
          ),
          Container(
            constraints: const BoxConstraints(minWidth: 56),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '$value',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: ZuranoPremiumUiColors.textPrimary,
              ),
            ),
          ),
          _StepperButton(
            icon: Icons.add_rounded,
            onTap: canInc ? () => onChanged(value + 1) : null,
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return Material(
      color: disabled
          ? ZuranoPremiumUiColors.lightSurface
          : ZuranoPremiumUiColors.softPurple,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(
            icon,
            size: 18,
            color: disabled
                ? ZuranoPremiumUiColors.textSecondary
                : ZuranoPremiumUiColors.primaryPurple,
          ),
        ),
      ),
    );
  }
}

/// Numeric input row with inline minutes/% suffix and ± validation.
class AttendanceNumberField extends StatefulWidget {
  const AttendanceNumberField({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.suffix,
    this.enabled = true,
  });

  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;
  final String? suffix;
  final bool enabled;

  @override
  State<AttendanceNumberField> createState() => _AttendanceNumberFieldState();
}

class _AttendanceNumberFieldState extends State<AttendanceNumberField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toString());
  }

  @override
  void didUpdateWidget(covariant AttendanceNumberField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value.toString() != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.value.toString(),
        selection: TextSelection.collapsed(
          offset: widget.value.toString().length,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _commit(String raw) {
    final parsed = int.tryParse(raw);
    if (parsed == null) {
      _controller.text = widget.value.toString();
      return;
    }
    final clamped = parsed.clamp(widget.min, widget.max);
    if (clamped != widget.value) {
      widget.onChanged(clamped);
    }
    if (clamped != parsed) {
      _controller.text = clamped.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Opacity(
      opacity: widget.enabled ? 1 : 0.55,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.label,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: ZuranoPremiumUiColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _controller,
            enabled: widget.enabled,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: _commit,
            decoration: InputDecoration(
              filled: true,
              fillColor: ZuranoPremiumUiColors.lightSurface,
              suffixText: widget.suffix,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: ZuranoPremiumUiColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: ZuranoPremiumUiColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: ZuranoPremiumUiColors.primaryPurple,
                  width: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
