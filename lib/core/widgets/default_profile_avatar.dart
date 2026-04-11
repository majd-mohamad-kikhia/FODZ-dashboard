import 'package:flutter/material.dart';
import 'package:foodzdashbord/core/utils/assets_manager.dart';

class DefaultProfileAvatar extends StatelessWidget {
  const DefaultProfileAvatar({
    super.key,
    this.radius = 24,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 0,
    this.fit = BoxFit.cover,
    this.assetPath = AssetsPath.man,
    this.tint,
    this.blendMode,
  });

  final double radius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final BoxFit fit;
  final String assetPath;
  final Color? tint;
  final BlendMode? blendMode;

  @override
  Widget build(BuildContext context) {
    final double diameter = radius * 2;

    return Container(
      height: diameter,
      width: diameter,
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFFF2F6F9),
        shape: BoxShape.circle,
        border: borderWidth > 0
            ? Border.all(color: borderColor ?? Colors.white, width: borderWidth)
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        assetPath,
        fit: fit,
        color: tint,
        colorBlendMode: blendMode,
      ),
    );
  }
}
