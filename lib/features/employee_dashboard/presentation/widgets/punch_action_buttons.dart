import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class PunchActionButton extends StatelessWidget {
  const PunchActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.isPrimary,
    required this.isLoading,
    this.onPressed,
  });

  final String label;
  final IconData icon;
  final bool isPrimary;
  final bool isLoading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final p = ZuranoPremiumUiColors.primaryPurple;
    final child = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: isPrimary ? Colors.white : p,
            ),
          )
        else
          Icon(icon, color: isPrimary ? Colors.white : p),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: isPrimary ? Colors.white : p,
          ),
        ),
      ],
    );

    if (isPrimary) {
      return SizedBox(
        height: 58,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              colors: [Color(0xFF7B2FF7), Color(0xFF9B51E0)],
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: isLoading ? null : onPressed,
              child: Center(child: child),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 58,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: p.withValues(alpha: 0.85), width: 1.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          foregroundColor: p,
          backgroundColor: Colors.white,
        ),
        onPressed: isLoading ? null : onPressed,
        child: child,
      ),
    );
  }
}
