import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:foodzdashbord/core/utils/appColors.dart';
import 'package:foodzdashbord/core/utils/constants.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({
    super.key,
    required this.title,
    required this.subTitle,
    required this.buttonText,
    this.showButton = true,
    required this.onPressed,
  });

  final String title;
  final String subTitle;
  final String buttonText;
  final bool? showButton;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 75.h,
        width: 90.w,
        child: Stack(
          children: [
            Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Center(child: SvgPicture.asset(error)),
                    3.h.vSpace,
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold, fontSize: 20.sp),
                      textAlign: TextAlign.center,
                    ),
                    2.h.vSpace,
                    Text(
                      subTitle,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )),
            showButton!
                ? Positioned(
                    left: 0,
                    right: 0,
                    bottom: 10,
                    child: InkWell(
                      onTap: () {
                        debugPrint(
                            "🔴 ErrorScreen: زر المحاولة مرة أخرى تم النقر عليه!");
                        onPressed(); // ثم قم بتشغيل الـ callback الأصلي
                      },
                      child: Container(
                        width: 90.w,
                        height: 5.5.h,
                        decoration: BoxDecoration(
                          color: AppColors.secondaryRed,
                          borderRadius: BorderRadius.circular(24.px),
                        ),
                        child: Center(
                          child: Text(
                            buttonText,
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              color: AppColors.primaryRed,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ))
                : SizedBox()
          ],
        ),
      ),
    );
  }
}
