import 'package:flutter/material.dart';

/// Center-docked owner shell FAB: purple gradient circle with "+" only.
class ZuranoCenterFab extends StatelessWidget {
  const ZuranoCenterFab({super.key, required this.onPressed});

  final VoidCallback onPressed;

  static const double fabSize = 64;
  static const double iconSize = 34;

  @override
  Widget build(BuildContext context) {
    const purpleStart = Color(0xFF7B61FF);
    const purpleEnd = Color(0xFF9F7BFF);

    return SizedBox(
      width: fabSize,
      height: fabSize,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [purpleStart, purpleEnd],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: purpleStart.withValues(alpha: 0.22),
              blurRadius: 14,
              spreadRadius: 0,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: Center(
              child: Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: iconSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
