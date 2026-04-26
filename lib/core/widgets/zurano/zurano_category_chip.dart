import 'package:flutter/material.dart';

import '../../theme/zurano_tokens.dart';

class ZuranoCategoryChip extends StatelessWidget {
  const ZuranoCategoryChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.suffix,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            gradient: selected ? ZuranoTokens.primaryGradient : null,
            color: selected ? null : ZuranoTokens.chipUnselected,
            borderRadius: BorderRadius.circular(24),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: ZuranoTokens.primary.withValues(alpha: 0.22),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : const [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: selected ? Colors.white : ZuranoTokens.textDark,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
              if (suffix != null) ...[const SizedBox(width: 4), suffix!],
            ],
          ),
        ),
      ),
    );
  }
}
