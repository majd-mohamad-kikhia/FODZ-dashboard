
 import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodzdashbord/core/utils/appColors.dart';
import 'package:foodzdashbord/core/utils/constants.dart';
import 'package:foodzdashbord/features/home_ads/presentation/cubit/home_ads_cubit.dart';
import 'package:foodzdashbord/features/sections/presentation/cubit/sections_cubit.dart';
import 'package:shimmer/shimmer.dart';

Widget buildShimmerLoading(String categoryName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16.rw),
          child: Row(
            children: [
              Icon(Icons.arrow_back, color: AppColors.textDark),
              12.hSpace,
              Text(
                categoryName,
                style: TextStyle(
                  fontSize: 18.rf,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16.rw),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: AppColors.grey200,
                highlightColor: AppColors.grey300,
                child: Container(
                  margin: EdgeInsets.only(bottom: 12.rh),
                  height: 100.rh,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildErrorState(BuildContext context, String message, VoidCallback onRetry) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64.rw, color: AppColors.primaryRed),
          16.vSpace,
          Text(
            message,
            style: TextStyle(fontSize: 16.rf, color: AppColors.grey600),
            textAlign: TextAlign.center,
          ),
          16.vSpace,
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              padding: EdgeInsets.symmetric(horizontal: 24.rw, vertical: 12.rh),
            ),
            child: Text(
              'إعادة المحاولة',
              style: TextStyle(fontSize: 14.rf, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 64.rw,
            color: AppColors.grey400,
          ),
          16.vSpace,
          Text(
            'لا توجد منتجات في هذه الفئة',
            style: TextStyle(fontSize: 16.rf, color: AppColors.grey600),
          ),
        ],
      ),
    );
  }
  
  Widget buildAdEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.ad_units, size: 64.rf, color: AppColors.grey400),
          SizedBox(height: 16.rh),
          Text(
            'لا توجد إعلانات',
            style: TextStyle(fontSize: 16.rf, color: AppColors.grey600),
          ),
        ],
      ),
    );
  }
  Widget buildAdErrorState(BuildContext context, String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64.rf, color: AppColors.primaryRed),
          SizedBox(height: 16.rh),
          Text(
            errorMessage,
            style: TextStyle(fontSize: 16.rf, color: AppColors.grey700),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.rh),
          ElevatedButton(
            onPressed: () {
              context.read<HomeAdsCubit>().retry();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              foregroundColor: Colors.white,
            ),
            child: Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
 Widget buildShimmerLoadingSections() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Center(
        child: CircularProgressIndicator(color: AppColors.primaryRed),
      ),
    );
  }


  Widget buildErrorStateSections(BuildContext context, String error) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 48.rf, color: AppColors.primaryRed),
            SizedBox(height: 16.rh),
            Text(
              error,
              style: TextStyle(fontSize: 14.rf, color: AppColors.primaryRed),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.rh),
            ElevatedButton(
              onPressed: () => context.read<SectionsCubit>().fetchSections(),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
  Widget buildEmptyStateSections() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.inbox_outlined, size: 48.rf, color: AppColors.grey400),
            SizedBox(height: 16.rh),
            Text(
              'لا توجد أقسام حالياً',
              style: TextStyle(fontSize: 14.rf, color: AppColors.grey600),
            ),
          ],
        ),
      ),
    );
  }
