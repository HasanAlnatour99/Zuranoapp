import 'package:flutter/material.dart';

import '../../theme/zurano_tokens.dart';

class ZuranoStatCard extends StatelessWidget {
  const ZuranoStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.highlighted = false,
  });

  final String label;
  final String value;
  final IconData icon;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: highlighted ? ZuranoTokens.activeCardFill : ZuranoTokens.surface,
        borderRadius: BorderRadius.circular(ZuranoTokens.radiusCard),
        border: Border.all(
          color: highlighted ? ZuranoTokens.secondary : ZuranoTokens.border,
        ),
        boxShadow: ZuranoTokens.softCardShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: highlighted
                  ? const Color(0xFFE9D5FF)
                  : const Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: highlighted ? ZuranoTokens.primary : ZuranoTokens.textGray,
              size: 22,
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.fade,
                  style: const TextStyle(
                    fontSize: 13,
                    color: ZuranoTokens.textGray,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: highlighted
                        ? ZuranoTokens.primary
                        : ZuranoTokens.textDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
