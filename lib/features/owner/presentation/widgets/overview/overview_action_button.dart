import 'package:flutter/material.dart';

import 'overview_design_tokens.dart';

/// Compact primary/secondary action used on the owner overview insight card.
class OverviewActionButton extends StatelessWidget {
  const OverviewActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.primary = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 44,
        child: ElevatedButton.icon(
          onPressed: onTap,
          icon: Icon(icon, size: OwnerOverviewTypography.actionIcon),
          label: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.center,
            child: Text(
              label,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: OwnerOverviewTypography.actionLabel,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            backgroundColor: primary ? const Color(0xFF7C3AED) : Colors.white,
            foregroundColor: primary ? Colors.white : const Color(0xFF0F172A),
            side: primary
                ? BorderSide.none
                : const BorderSide(color: Color(0xFFE5E7EB)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
      ),
    );
  }
}
