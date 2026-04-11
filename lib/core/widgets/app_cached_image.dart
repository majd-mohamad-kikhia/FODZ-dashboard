import 'package:cached_network_image/cached_network_image.dart';
import 'package:foodzdashbord/core/utils/appColors.dart';
import 'package:foodzdashbord/core/widgets/app_loading_shimmer.dart';
import 'package:flutter/material.dart';

class AppCachedImage extends StatelessWidget {
  const AppCachedImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
  });

  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final WidgetBuilder? placeholder;
  final WidgetBuilder? errorWidget;

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (imageUrl.trim().isEmpty) {
      content = errorWidget?.call(context) ??
          Container(
            color: AppColors.grey200,
            alignment: Alignment.center,
            child: const Icon(Icons.broken_image_outlined, color: AppColors.grey500),
          );
    } else {
      content = CachedNetworkImage(
        imageUrl: imageUrl,
        fit: fit,
        width: width,
        height: height,
        placeholder: (context, _) => placeholder?.call(context) ??
            Center(
              child: AppLoadingShimmer(
                height: height,
                width: width,
                borderRadius: borderRadius,
              ),
            ),
        errorWidget: (context, _, __) => errorWidget?.call(context) ??
            Container(
              color: AppColors.grey200,
              alignment: Alignment.center,
              child: const Icon(Icons.broken_image_outlined, color: AppColors.grey500),
            ),
      );
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: content,
      );
    }

    return content;
  }
}
