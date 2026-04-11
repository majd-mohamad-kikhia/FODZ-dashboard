// import 'package:flutter/material.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';
// import 'package:real_estate/core/utils/app_colors.dart';
// import 'package:real_estate/core/utils/assets_manager.dart';

// import 'package:real_estate/core/utils/font/font_manager.dart';

// class StatusCodeError extends StatelessWidget {
//   const StatusCodeError({
//     super.key,
//     required this.statusCode,
//     required this.subTitle,
//     required this.buttonText,
//     this.showButton = true,
//     required this.onPressed,
//   });

//   final int statusCode;
//   final String subTitle;
//   final String buttonText;
//   final bool? showButton;
//   final VoidCallback onPressed;

//   @override
//   Widget build(BuildContext context) {
//     String imageAsset;

//     switch (statusCode) {
//       case 500:
//         imageAsset = ImgAssets.status500;
//         break;
//       case 403:
//         imageAsset = ImgAssets.status403;
//         break;
//       default:
//         imageAsset = ImgAssets.status500;
//         break;
//     }

//     return Center(
//       child: SizedBox(
//         height: 75.h,
//         width: 90.w,
//         child: Stack(
//           children: [
//             Positioned(
//               top: 8.h,
//               left: 0,
//               right: 0,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     "Oops !! Error $statusCode",
//                     style: FontManager.heading1.copyWith(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 20.sp,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: 2.h),
//                   Text(
//                     subTitle,
//                     style: FontManager.bodyText.copyWith(
//                       color: Colors.grey,
//                       fontWeight: FontWeight.w500,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: 6.h),
//                   // Center(child: SvgPicture.asset(imageAsset)),
//                 ],
//               ),
//             ),
//             if (showButton!)
//               Positioned(
//                 left: 0,
//                 right: 0,
//                 bottom: 10,
//                 child: InkWell(
//                   onTap: onPressed,
//                   child: Container(
//                     width: 90.w,
//                     height: 5.5.h,
//                     decoration: BoxDecoration(
//                       color: AppColors.secondryColor,
//                       borderRadius: BorderRadius.circular(24.px),
//                     ),
//                     child: Center(
//                       child: Text(
//                         buttonText,
//                         style: TextStyle(
//                           color: AppColors.mainColor,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
