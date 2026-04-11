import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodzdashbord/features/restaurants/data/models/restaurant_model.dart';
import 'package:shimmer/shimmer.dart';

import 'package:foodzdashbord/core/utils/appColors.dart';
import 'package:foodzdashbord/core/utils/constants.dart';
import 'package:foodzdashbord/features/home/cubit/home_nav_cubit.dart';
import 'package:foodzdashbord/features/restaurant_sections/data/api/restaurant_sections_client.dart';
import 'package:foodzdashbord/features/restaurant_sections/presentation/cubit/restaurant_sections_cubit.dart';
import 'package:foodzdashbord/features/sections/presentation/cubit/section_selection_cubit.dart';

class RestaurantsListingGrid extends StatelessWidget {
  const RestaurantsListingGrid({super.key, required this.config});

  final DashboardSectionConfig config;

  @override
  Widget build(BuildContext context) {
    final sectionType = SectionTypeConverter.fromDashboardScreen(config.screen);

    return BlocBuilder<RestaurantSectionsCubit, RestaurantSectionsState>(
      builder: (context, state) {
        if (state.isLoading && state.restaurants.isEmpty) {
          return _buildShimmerLoading();
        }

        if (state.errorMessage != null && state.restaurants.isEmpty) {
          return _buildErrorState(context, state.errorMessage!, sectionType);
        }

        if (state.restaurants.isEmpty) {
          return _buildEmptyState();
        }

        return BlocBuilder<SectionSelectionCubit, SectionSelectionState>(
          builder: (context, selectionState) {
            return NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                if (scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent &&
                    !state.isLoadingMore &&
                    state.hasMorePages) {
                  context.read<RestaurantSectionsCubit>().loadMore(sectionType);
                }
                return false;
              },
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount:
                    state.restaurants.length + (state.isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == state.restaurants.length) {
                    return _buildLoadingMoreCard();
                  }

                  final restaurant = state.restaurants[index];
                  final isSelected = selectionState.selectedIds.contains(
                    restaurant.id,
                  );
                  return _RestaurantCard(
                    restaurant: restaurant,
                    index: index,
                    isSelected: isSelected,
                    onTap: () {
                      context.read<SectionSelectionCubit>().toggleSelection(
                        restaurant.id,
                      );
                    },
                    onDoubleTap: () {
                      // Navigate to restaurant details
                      HomeNavCubit? homeNavCubit;
                      try {
                        homeNavCubit = BlocProvider.of<HomeNavCubit>(context);
                      } catch (_) {
                        homeNavCubit = null;
                      }

                      if (homeNavCubit != null) {
                        // Convert SectionRestaurant to RestaurantModel
                        final restaurantModel = RestaurantModel(
                          id: restaurant.id,
                          name: restaurant.name,
                          phoneNumber: restaurant.phoneNumber,
                          emailAddress: restaurant.emailAddress,
                          status: restaurant.isActive ? 'active' : 'inactive',
                          isActive: restaurant.isActive,
                          isVerified: restaurant.isVerified,
                          type: restaurant.type,
                          city: restaurant.city,
                          country: restaurant.country,
                          createdAt: null, // Not available in SectionRestaurant
                          totalRates: '0', // Default value
                          averageRating: '0.0', // Default value
                          image: '', // Default empty, will show placeholder
                        );

                        homeNavCubit.openRestaurantDetails(restaurantModel);
                      }
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildShimmerLoading() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppColors.grey200,
          highlightColor: Colors.grey.shade50,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingMoreCard() {
    return Container(
      padding: responsiveInsetsAll(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryRed,
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    String errorMessage,
    SectionType sectionType,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64.rw, color: AppColors.primaryRed),
          SizedBox(height: 16.rh),
          Text(
            errorMessage,
            style: TextStyle(fontSize: 16.rf, color: AppColors.grey700),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.rh),
          ElevatedButton(
            onPressed: () {
              context.read<RestaurantSectionsCubit>().refresh(sectionType);
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant_menu, size: 64.rw, color: AppColors.grey400),
          SizedBox(height: 16.rh),
          Text(
            'لا توجد مطاعم',
            style: TextStyle(fontSize: 16.rf, color: AppColors.grey600),
          ),
        ],
      ),
    );
  }
}

class _RestaurantCard extends StatelessWidget {
  const _RestaurantCard({
    required this.restaurant,
    required this.index,
    required this.isSelected,
    required this.onTap,
    required this.onDoubleTap,
  });

  final dynamic restaurant;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDoubleTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        onDoubleTap: onDoubleTap,
        child: Container(
          padding: responsiveInsetsAll(16),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryRed.withOpacity(0.05)
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.primaryRed : AppColors.grey200,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40.rw,
                    height: 40.rw,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryRed.withOpacity(0.14),
                          AppColors.secondaryRed.withOpacity(0.08),
                        ],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primaryRed.withOpacity(0.14),
                      ),
                    ),
                    child: Icon(
                      Icons.restaurant_rounded,
                      color: AppColors.primaryRed,
                      size: 15.rf,
                    ),
                  ),
                  const Spacer(),
                  if (isSelected)
                    Container(
                      padding: EdgeInsets.all(4.rw),
                      decoration: BoxDecoration(
                        color: AppColors.primaryRed,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        size: 14.rf,
                        color: Colors.white,
                      ),
                    )
                  else if (restaurant.isVerified)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.rw,
                        vertical: 4.rh,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.successGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.verified,
                            size: 12.rf,
                            color: AppColors.successGreen,
                          ),
                          SizedBox(width: 4.rw),
                          Text(
                            'موثق',
                            style: TextStyle(
                              fontSize: 10.rf,
                              fontWeight: FontWeight.w600,
                              color: AppColors.successGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const Spacer(),
              Text(
                restaurant.name,
                style: TextStyle(
                  fontSize: 14.rf,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4.rh),
              Text(
                '${restaurant.city}, ${restaurant.country}',
                style: TextStyle(fontSize: 11.rf, color: AppColors.grey600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8.rh),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.rw,
                      vertical: 3.rh,
                    ),
                    decoration: BoxDecoration(
                      color: restaurant.isActive
                          ? AppColors.successGreen.withOpacity(0.1)
                          : AppColors.grey200,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      restaurant.isActive ? 'نشط' : 'غير نشط',
                      style: TextStyle(
                        fontSize: 10.rf,
                        fontWeight: FontWeight.w600,
                        color: restaurant.isActive
                            ? AppColors.successGreen
                            : AppColors.grey600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
