
import 'package:flutter/material.dart';
import 'package:foodzdashbord/core/utils/appColors.dart';
import 'package:foodzdashbord/core/utils/constants.dart';
import 'package:foodzdashbord/features/home/cubit/home_nav_cubit.dart';

class ScreenCard extends StatelessWidget {
  const ScreenCard({
    required this.screen,
    required this.isActive,
    required this.onTap,
  });

  final DashboardScreen screen;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(horizontal: 16.rw, vertical: 16.rh),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primaryRed.withOpacity(0.10)
                : AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isActive ? AppColors.primaryRed : AppColors.grey200,
              width: isActive ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isActive ? 0.06 : 0.02),
                blurRadius: isActive ? 16 : 10,
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
                  color: isActive
                      ? AppColors.primaryRed.withOpacity(0.12)
                      : AppColors.grey200.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  screen.icon,
                  color: isActive ? AppColors.primaryRed : AppColors.grey600,
                  size: 18.rf,
                ),
              ),
              SizedBox(height: 12.rh),
              Text(
                screen.title,
                style: TextStyle(
                  fontSize: 13.rf,
                  fontWeight: FontWeight.w700,
                  color: isActive ? AppColors.textDark : AppColors.grey600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
