import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodzdashbord/core/utils/appColors.dart';
import 'package:foodzdashbord/core/widgets/app_cached_image.dart';
import 'package:foodzdashbord/features/restaurants/presentation/cubit/restaurants_cubit.dart';
import 'package:foodzdashbord/features/restaurants/presentation/cubit/pending_restaurants_cubit.dart';
import 'package:foodzdashbord/features/restaurants/data/models/restaurant_model.dart';
import 'package:foodzdashbord/features/restaurants/presentation/widgets/pending_restaurants_grid.dart';
import 'package:foodzdashbord/features/home/cubit/home_nav_cubit.dart';
import 'dart:html' as html;

class RestaurantsScreen extends StatelessWidget {
  const RestaurantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PendingRestaurantsCubit(),
      child: const _RestaurantsView(),
    );
  }
}

class _RestaurantsView extends StatelessWidget {
  const _RestaurantsView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<RestaurantsCubit, RestaurantsState>(
      listenWhen: (previous, current) =>
          previous.actionMessage != current.actionMessage,
      listener: (context, state) {
        if (state.actionMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.actionMessage!),
              backgroundColor: state.actionStatus == RestaurantActionStatus.success
                  ? Colors.green
                  : AppColors.primaryRed,
            ),
          );
        }
      },
      child: DefaultTabController(
        length: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SearchBar(),
            const _ActiveFilterButtons(),
          BlocBuilder<RestaurantsCubit, RestaurantsState>(
            builder: (context, state) {
              return Container(
                color: Colors.white,
                child: TabBar(
                  onTap: (index) {
                    if (index < 2) {
                      context.read<RestaurantsCubit>().fetchRestaurants();
                      final restaurantType = index == 1 ? 'home' : 'restaurant';
                      context.read<RestaurantsCubit>().filterByType(restaurantType);
                    }
                  },
                  labelColor: AppColors.primaryRed,
                  unselectedLabelColor: AppColors.grey600,
                  indicatorColor: AppColors.primaryRed,
                  indicatorWeight: 3,
                  tabs: const [
                    Tab(
                      text: 'مطاعم',
                      icon: Icon(Icons.restaurant_rounded),
                    ),
                    Tab(
                      text: 'أسر منتجة',
                      icon: Icon(Icons.home_work_rounded),
                    ),
                    Tab(
                      text: 'في الإنتظار',
                      icon: Icon(Icons.pending_rounded),
                    ),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: TabBarView(
              children: [
                const _RestaurantsGrid(),
                const _RestaurantsGrid(),
                const PendingRestaurantsGrid(),
              ],
            ),
          ),
        ],
        ),
      ),
    );
  }
}

class _ActiveFilterButtons extends StatelessWidget {
  const _ActiveFilterButtons();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantsCubit, RestaurantsState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: Colors.white,
          child: Row(
            children: [
              Text(
                'الحالة:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              SizedBox(width: 12),
              _FilterChip(
                label: 'الكل',
                isSelected: state.activeFilter == 'all',
                onTap: () => context.read<RestaurantsCubit>().filterByActiveStatus('all'),
              ),
              SizedBox(width: 8),
              _FilterChip(
                label: 'فعّال',
                isSelected: state.activeFilter == 'active',
                onTap: () => context.read<RestaurantsCubit>().filterByActiveStatus('active'),
              ),
              SizedBox(width: 8),
              _FilterChip(
                label: 'غير فعّال',
                isSelected: state.activeFilter == 'inactive',
                onTap: () => context.read<RestaurantsCubit>().filterByActiveStatus('inactive'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryRed : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryRed : AppColors.grey300,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.grey600,
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RestaurantsCubit>();

    return BlocBuilder<RestaurantsCubit, RestaurantsState>(
      buildWhen: (previous, current) => previous.searchTerm != current.searchTerm,
      builder: (context, state) {
        return TextField(
          controller: cubit.searchController,
          onChanged: cubit.updateSearch,
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textDark,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'ابحث عن مطعم...',
            hintStyle: TextStyle(
              fontSize: 14,
              color: AppColors.grey400,
            ),
            prefixIcon: state.searchTerm.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.close_rounded, color: AppColors.grey600, size: 20),
                    onPressed: cubit.clearSearch,
                  )
                : null,
            suffixIcon: Icon(Icons.search_rounded, size: 20, color: AppColors.primaryRed),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.grey200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.grey200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primaryRed, width: 1.5),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        );
      },
    );
  }
}

class _RestaurantsGrid extends StatelessWidget {
  const _RestaurantsGrid();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantsCubit, RestaurantsState>(
      builder: (context, state) {
        if (state.status == RestaurantsStatus.loading) {
          return Center(child: CircularProgressIndicator(color: AppColors.primaryRed));
        }

        if (state.filteredRestaurants.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.restaurant_menu_rounded, size: 48, color: AppColors.grey400),
                SizedBox(height: 16),
                Text(
                  'لا توجد مطاعم',
                  style: TextStyle(fontSize: 16, color: AppColors.grey600),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.1,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemCount: state.filteredRestaurants.length,
          itemBuilder: (context, index) {
            final restaurant = state.filteredRestaurants[index];
            return _RestaurantCard(restaurant: restaurant);
          },
        );
      },
    );
  }
}

class _RestaurantCard extends StatelessWidget {
  const _RestaurantCard({required this.restaurant});

  final RestaurantModel restaurant;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          HomeNavCubit? homeNavCubit;
          try {
            homeNavCubit = BlocProvider.of<HomeNavCubit>(context);
          } catch (_) {
            homeNavCubit = null;
          }

          if (homeNavCubit != null) {
            homeNavCubit.openRestaurantDetails(restaurant);
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.grey200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AppCachedImage(
                    imageUrl: restaurant.displayCover,
                    fit: BoxFit.cover,
                    errorWidget: (context) => Container(
                      color: AppColors.grey200,
                      child: Icon(Icons.restaurant, size: 40, color: AppColors.grey400),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: (restaurant.isActive ?? false)
                            ? AppColors.primaryRed
                            : AppColors.grey500,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        (restaurant.isActive ?? false) ? 'فعّال' : 'غير فعّال',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AppCachedImage(
                        imageUrl: restaurant.displayPhoto,
                        width: 32,
                        height: 32,
                        fit: BoxFit.cover,
                        borderRadius: BorderRadius.circular(8),
                        errorWidget: (context) => Container(
                          width: 32,
                          height: 32,
                          color: AppColors.grey200,
                          child: Icon(Icons.restaurant, size: 16, color: AppColors.grey400),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              restaurant.name,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 2),
                            Text(
                              '${restaurant.type} • ${restaurant.city}',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.grey600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Icon(Icons.star, size: 14, color: AppColors.accentOrange),
                      SizedBox(width: 4),
                      Text(
                        restaurant.rating.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        '(${restaurant.reviewsCount})',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.grey600,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.phone, size: 12, color: AppColors.grey500),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          restaurant.phoneNumber,
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.grey600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  if (restaurant.pdfUrl != null && restaurant.pdfUrl!.isNotEmpty ||
                      restaurant.paymentReceiptUrl != null && restaurant.paymentReceiptUrl!.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          if (restaurant.pdfUrl != null && restaurant.pdfUrl!.isNotEmpty)
                            Expanded(
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () => _openUrl(context, restaurant.pdfUrl!),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: Colors.blue, width: 1),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.picture_as_pdf, size: 14, color: Colors.blue),
                                        SizedBox(width: 4),
                                        Text(
                                          'عرض الملف',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (restaurant.pdfUrl != null && restaurant.pdfUrl!.isNotEmpty &&
                              restaurant.paymentReceiptUrl != null && restaurant.paymentReceiptUrl!.isNotEmpty)
                            SizedBox(width: 6),
                          if (restaurant.paymentReceiptUrl != null && restaurant.paymentReceiptUrl!.isNotEmpty)
                            Expanded(
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () => _openUrl(context, restaurant.paymentReceiptUrl!),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: Colors.green, width: 1),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          _isPdf(restaurant.paymentReceiptUrl!)
                                              ? Icons.receipt_long
                                              : Icons.image_outlined,
                                          size: 14,
                                          color: Colors.green,
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          'إيصال الدفع',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  SizedBox(height: 8),
                  BlocBuilder<RestaurantsCubit, RestaurantsState>(
                    builder: (context, state) {
                      final isLoading = state.actionStatus == RestaurantActionStatus.loading;
                      final isActive = restaurant.isActive ?? false;
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: isLoading
                              ? null
                              : () {
                                  if (isActive) {
                                    context.read<RestaurantsCubit>().banRestaurant(restaurant.id);
                                  } else {
                                    context.read<RestaurantsCubit>().unbanRestaurant(restaurant.id);
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isActive ? AppColors.primaryRed : Colors.green,
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: isLoading
                              ? SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : Icon(
                                  isActive ? Icons.block : Icons.check_circle,
                                  size: 14,
                                  color: Colors.white,
                                ),
                          label: Text(
                            isActive ? 'حظر' : 'إلغاء الحظر',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    },
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

  bool _isPdf(String url) {
    final lower = url.toLowerCase();
    return lower.endsWith('.pdf') || lower.contains('.pdf?');
  }

  void _openUrl(BuildContext context, String url) {
    try {
      html.window.open(url, '_blank');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('فشل في فتح الملف'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
