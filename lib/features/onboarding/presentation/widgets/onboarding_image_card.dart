import 'package:flutter/material.dart';

/// Premium framed illustration for customer onboarding (light purple shell).
class OnboardingImageCard extends StatelessWidget {
  const OnboardingImageCard({
    super.key,
    required this.imagePath,
    required this.height,
    this.showBackground = false,
  });

  final String imagePath;
  final double height;

  /// When false, no gradient card or shadow — image on white (for transparent PNGs).
  final bool showBackground;

  static const _gradientStart = Color(0xFFF8F3FF);
  static const _gradientEnd = Color(0xFFEFE3FF);

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      imagePath,
      fit: BoxFit.contain,
      alignment: Alignment.center,
    );

    if (!showBackground) {
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 24),
        height: height,
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        alignment: Alignment.center,
        child: image,
      );
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_gradientStart, _gradientEnd],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Align(alignment: Alignment.center, child: image),
    );
  }
}
