import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum AppIllustrationSize { small, medium, large, hero }

class AppIllustration extends StatelessWidget {
  const AppIllustration({
    required this.assetName,
    this.size = AppIllustrationSize.large,
    this.dimension,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.semanticLabel,
    this.color,
    this.maxWidth = 360,
    this.maxHeight = 260,
    super.key,
  });

  final String assetName;
  final AppIllustrationSize size;
  final double? dimension;
  final BoxFit fit;
  final AlignmentGeometry alignment;
  final String? semanticLabel;
  final Color? color;
  final double maxWidth;
  final double maxHeight;

  double _sizeForPreset(AppIllustrationSize preset) {
    switch (preset) {
      case AppIllustrationSize.small:
        return 116;
      case AppIllustrationSize.medium:
        return 156;
      case AppIllustrationSize.large:
        return 196;
      case AppIllustrationSize.hero:
        return 228;
    }
  }

  bool get _isSvgAsset => assetName.toLowerCase().endsWith('.svg');

  @override
  Widget build(BuildContext context) {
    final targetSize = dimension ?? _sizeForPreset(size);

    return Semantics(
      label: semanticLabel,
      image: true,
      child: Align(
        alignment: alignment,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: maxHeight),
          child: _isSvgAsset
              ? SvgPicture.asset(
                  assetName,
                  width: targetSize,
                  height: targetSize,
                  fit: fit,
                  colorFilter: color == null
                      ? null
                      : ColorFilter.mode(color!, BlendMode.srcIn),
                )
              : Image.asset(
                  assetName,
                  width: targetSize,
                  height: targetSize,
                  fit: fit,
                  alignment: alignment is Alignment
                      ? alignment as Alignment
                      : Alignment.center,
                  color: color,
                ),
        ),
      ),
    );
  }
}
