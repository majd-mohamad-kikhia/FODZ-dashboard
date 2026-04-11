import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodzdashbord/core/utils/appColors.dart';
import 'package:foodzdashbord/core/utils/constants.dart';
import 'package:foodzdashbord/core/widgets/app_cached_image.dart';
import 'package:foodzdashbord/features/restaurants/data/models/restaurant_model.dart';
import 'package:foodzdashbord/features/home/cubit/home_nav_cubit.dart';
import 'package:foodzdashbord/features/restaurant_details/presentation/cubit/restaurant_details_cubit.dart';
import 'package:foodzdashbord/features/restaurant_details/data/models/restaurant_details_response.dart';
import 'package:shimmer/shimmer.dart';

class RestaurantDetailsScreen extends StatelessWidget {
  const RestaurantDetailsScreen({super.key, required this.restaurant});

  final RestaurantModel restaurant;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RestaurantDetailsCubit()..fetchCategories(restaurant.id),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              restaurant.name,
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 18.rf,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: AppColors.textDark),
              onPressed: () {
                // Use HomeNavCubit to navigate back instead of Navigator.pop
                HomeNavCubit? homeNavCubit;
                try {
                  homeNavCubit = BlocProvider.of<HomeNavCubit>(context);
                } catch (_) {
                  homeNavCubit = null;
                }

                if (homeNavCubit != null) {
                  // Clear the selected restaurant to go back to restaurants list
                  homeNavCubit.selectSection(HomeSection.restaurants);
                } else {
                  // Fallback to navigator pop if cubit not found
                  Navigator.pop(context);
                }
              },
            ),
          ),
          body: RestaurantDetailsView(restaurant: restaurant),
        ),
      ),
    );
  }

  static String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) {
      return 'غير متوفر';
    }
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) {
      return raw;
    }
    return '${parsed.year}-${parsed.month.toString().padLeft(2, '0')}-${parsed.day.toString().padLeft(2, '0')}';
  }
}

class RestaurantDetailsView extends StatelessWidget {
  const RestaurantDetailsView({super.key, required this.restaurant});

  final RestaurantModel restaurant;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 32.rh),
      child: Padding(
        padding: responsiveInsetsSymmetric(horizontal: 12, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _HeroPanel(restaurant: restaurant),
            30.vSpace,
            _CategoriesSection(restaurant: restaurant),
          ],
        ),
      ),
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({required this.restaurant});

  final RestaurantModel restaurant;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.rw, vertical: 16.rh),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.rw),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 6.rw,
            spreadRadius: 4.rw,
            offset: const Offset(1, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.rw),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.8),
                  blurRadius: 6.rw,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: AppCachedImage(
              imageUrl: restaurant.image,
              width: 350.rw,
              height: 260.rh,
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(25.rw),
              errorWidget: (context) => Container(
                width: 350.rw,
                height: 260.rh,
                color: AppColors.grey200,
                child: Icon(Icons.restaurant_rounded, size: 40, color: AppColors.grey500),
              ),
            ),
          ),
          204.hSpace,
          SizedBox(
            width: 800.rw,
            child: _QuickFactsRow(restaurant: restaurant),
          ),
        ],
      ),
    );
  }
}

class _QuickFactsRow extends StatelessWidget {
  const _QuickFactsRow({required this.restaurant});

  final RestaurantModel restaurant;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: responsiveInsetsSymmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoItem(
                  label: 'الاسم',
                  value: restaurant.name,
                ),
                12.vSpace,
                _InfoItem(
                  label: 'النوع',
                  value: restaurant.type,
                ),
              ],
            ),
          ),
          12.hSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoItem(
                  label: 'التقييم',
                  value: restaurant.rating.toStringAsFixed(1),
                  icon: Icons.star_rounded,
                  iconColor: AppColors.accentOrange,
                ),
                12.vSpace,
                _InfoItem(
                  label: 'عدد المقيمين',
                  value: restaurant.reviewsCount.toString(),
                ),
                12.vSpace,
                _InfoItem(
                  label: 'تاريخ الانضمام',
                  value: RestaurantDetailsScreen._formatDate(restaurant.createdAt),
                ),
              ],
            ),
          ),
          12.hSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoItem(
                  label: 'رقم الهاتف',
                  value: restaurant.phoneNumber,
                ),
                12.vSpace,
                _InfoItem(
                  label: 'البريد الالكتروني',
                  value: restaurant.emailAddress,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({
    required this.label,
    required this.value,
    this.icon,
    this.iconColor,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10.rf,
            fontWeight: FontWeight.w600,
            color: AppColors.grey600,
          ),
        ),
        4.vSpace,
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 12.rf, color: iconColor ?? AppColors.primaryRed),
              4.hSpace,
            ],
            Flexible(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 12.rf,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CategoriesSection extends StatelessWidget {
  const _CategoriesSection({required this.restaurant});

  final RestaurantModel restaurant;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantDetailsCubit, RestaurantDetailsState>(
      builder: (context, state) {
        if (state.status == RestaurantDetailsStatus.loading) {
          return _buildShimmerLoading();
        }

        if (state.status == RestaurantDetailsStatus.error) {
          return _buildErrorState(context, state.errorMessage);
        }

        if (state.categories.isEmpty) {
          return _buildEmptyState();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الفئات',
              style: TextStyle(
                fontSize: 16.rf,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            16.vSpace,
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16.rw,
                mainAxisSpacing: 16.rh,
                childAspectRatio: 1.2,
              ),
              itemCount: state.categories.length,
              itemBuilder: (context, index) {
                return _CategoryCard(
                  category: state.categories[index],
                  restaurant: restaurant,
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildShimmerLoading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الفئات',
          style: TextStyle(
            fontSize: 16.rf,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        16.vSpace,
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16.rw,
            mainAxisSpacing: 16.rh,
            childAspectRatio: 1.2,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            return Shimmer.fromColors(
              baseColor: AppColors.grey200,
              highlightColor: AppColors.grey300,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.rw),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64.rw,
            color: AppColors.primaryRed,
          ),
          16.vSpace,
          Text(
            message,
            style: TextStyle(
              fontSize: 16.rf,
              color: AppColors.grey600,
            ),
            textAlign: TextAlign.center,
          ),
          16.vSpace,
          ElevatedButton(
            onPressed: () {
              context.read<RestaurantDetailsCubit>().fetchCategories(restaurant.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              padding: EdgeInsets.symmetric(horizontal: 24.rw, vertical: 12.rh),
            ),
            child: Text(
              'إعادة المحاولة',
              style: TextStyle(
                fontSize: 14.rf,
                color: Colors.white,
              ),
            ),
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
          Icon(
            Icons.category_outlined,
            size: 64.rw,
            color: AppColors.grey400,
          ),
          16.vSpace,
          Text(
            'لا توجد فئات متاحة',
            style: TextStyle(
              fontSize: 16.rf,
              color: AppColors.grey600,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category, required this.restaurant});

  final RestaurantCategory category;
  final RestaurantModel restaurant;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          // Navigate to category products
          HomeNavCubit? homeNavCubit;
          try {
            homeNavCubit = BlocProvider.of<HomeNavCubit>(context);
          } catch (_) {
            homeNavCubit = null;
          }

          if (homeNavCubit != null) {
            homeNavCubit.openCategoryProductsById(
              restaurantId: restaurant.id,
              categoryId: category.id,
              categoryName: category.name,
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.rw),
            border: Border.all(color: AppColors.grey200),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 8.rw,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: category.photoURL != null
                    ? AppCachedImage(
                        imageUrl: category.photoURL!,
                        fit: BoxFit.cover,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16.rw)),
                        errorWidget: (context) => Container(
                          color: AppColors.grey200,
                          child: Icon(Icons.fastfood, size: 40, color: AppColors.grey400),
                        ),
                      )
                    : Container(
                        color: AppColors.grey200,
                        child: Icon(Icons.fastfood, size: 40, color: AppColors.grey400),
                      ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(12.rw),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        category.name,
                        style: TextStyle(
                          fontSize: 14.rf,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      4.vSpace,
                      Text(
                        'ID: ${category.id}',
                        style: TextStyle(
                          fontSize: 10.rf,
                          color: AppColors.grey500,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      2.vSpace,
                      Text(
                        category.description,
                        style: TextStyle(
                          fontSize: 11.rf,
                          color: AppColors.grey600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

