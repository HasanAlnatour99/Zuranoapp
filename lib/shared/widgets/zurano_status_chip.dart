import 'package:flutter/material.dart';

/// Compact pill status (Zurano) — reusable across employee and owner surfaces.
class ZuranoStatusChip extends StatelessWidget {
  const ZuranoStatusChip({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    this.backgroundColor,
    this.compact = false,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final Color color;

  /// Optional end text (e.g. punch time), same color treatment as [label].
  final String? trailing;

  /// When null, a soft fill is derived from [color].
  final Color? backgroundColor;

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? color.withValues(alpha: 0.10);
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 36),
      child: Container(
        padding: EdgeInsetsDirectional.fromSTEB(
          compact ? 10 : 14,
          compact ? 8 : 10,
          compact ? 10 : 14,
          compact ? 8 : 10,
        ),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: compact ? 16 : 18, color: color),
            SizedBox(width: compact ? 6 : 8),
            Flexible(
              child: Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w700,
                  fontSize: compact ? 12 : 13,
                ),
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 8),
              Text(
                trailing!,
                style: TextStyle(
                  color: color.withValues(alpha: 0.92),
                  fontWeight: FontWeight.w700,
                  fontSize: compact ? 11.5 : 12.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
