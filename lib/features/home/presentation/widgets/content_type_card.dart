
import 'package:flutter/material.dart';
import 'package:foodzdashbord/core/utils/appColors.dart';
import 'package:foodzdashbord/core/utils/constants.dart';
import 'package:foodzdashbord/features/home/cubit/home_nav_cubit.dart';

class ContentTypeCard extends StatelessWidget {
  const ContentTypeCard({required this.contentType, required this.onTap});

  final DashboardContentType contentType;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.rw, vertical: 16.rh),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.grey200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 48.rw,
                height: 48.rw,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryRed.withOpacity(0.14),
                      AppColors.secondaryRed.withOpacity(0.08),
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.primaryRed.withOpacity(0.12),
                  ),
                ),
                child: Icon(
                  contentType.icon,
                  color: AppColors.primaryRed,
                  size: 18.rf,
                ),
              ),
              SizedBox(height: 12.rh),
              Text(
                contentType.title,
                style: TextStyle(
                  fontSize: 13.rf,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 6.rh),
              Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 14.rf,
                color: AppColors.grey400,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 