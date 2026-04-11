import 'package:foodzdashbord/core/utils/appColors.dart';
import 'package:foodzdashbord/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class AppLoadingShimmer extends StatelessWidget {
  const AppLoadingShimmer({
    super.key,
    this.height,
    this.width,
    this.padding,
    this.borderRadius,
  });

  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final resolvedHeight = height ?? 5.h;
    final resolvedWidth = width ?? 110.rw;
    final resolvedPadding = padding ?? responsiveInsetsAll(10);
    final resolvedBorderRadius = borderRadius ?? BorderRadius.circular(24.rw);

    return Shimmer.fromColors(
      baseColor: AppColors.baseShimmer,
      highlightColor: AppColors.highlightShimmer,
      child: Container(
        height: resolvedHeight,
        width: resolvedWidth,
        padding: resolvedPadding,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey, width: 0.3),
          borderRadius: resolvedBorderRadius,
        ),
      ),
    );
  }
}
