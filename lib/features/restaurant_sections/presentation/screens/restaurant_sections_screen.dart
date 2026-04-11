import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodzdashbord/core/api/network_service.dart';
import 'package:foodzdashbord/core/utils/constants.dart';
import 'package:foodzdashbord/core/widgets/local_app_bar.dart';
import 'package:foodzdashbord/features/restaurant_sections/data/api/restaurant_sections_client.dart';
import 'package:foodzdashbord/features/restaurant_sections/presentation/cubit/restaurant_sections_cubit.dart';
import 'package:shimmer/shimmer.dart';

class RestaurantSectionsScreen extends StatelessWidget {
  final SectionType sectionType;
  final String title;

  const RestaurantSectionsScreen({
    super.key,
    required this.sectionType,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RestaurantSectionsCubit(
        RestaurantSectionsClient(NetworkServices()),
      )..fetchRestaurants(sectionType: sectionType),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: LocalAppBar(
          title: title,
          showBackButton: true,
        ),
        body: BlocBuilder<RestaurantSectionsCubit, RestaurantSectionsState>(
          builder: (context, state) {
            if (state.isLoading && state.restaurants.isEmpty) {
              return _buildShimmerLoading();
            }

            if (state.errorMessage != null && state.restaurants.isEmpty) {
              return _buildErrorState(context, state.errorMessage!);
            }

            if (state.restaurants.isEmpty) {
              return _buildEmptyState();
            }

            return RefreshIndicator(
              onRefresh: () => context
                  .read<RestaurantSectionsCubit>()
                  .refresh(sectionType),
              child: NotificationListener<ScrollNotification>(
                onNotification: (scrollInfo) {
                  if (scrollInfo.metrics.pixels ==
                          scrollInfo.metrics.maxScrollExtent &&
                      !state.isLoadingMore &&
                      state.hasMorePages) {
                    context
                        .read<RestaurantSectionsCubit>()
                        .loadMore(sectionType);
                  }
                  return false;
                },
                child: ListView.builder(
                  padding: EdgeInsets.all(16.rw),
                  itemCount:
                      state.restaurants.length + (state.isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == state.restaurants.length) {
                      return _buildLoadingMoreIndicator();
                    }

                    final restaurant = state.restaurants[index];
                    return _buildRestaurantCard(restaurant);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRestaurantCard(restaurant) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.rh),
      padding: EdgeInsets.all(16.rw),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.rw),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50.rw,
                height: 50.rw,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8.rw),
                ),
                child: Icon(
                  Icons.restaurant,
                  color: Colors.grey.shade400,
                  size: 24.rw,
                ),
              ),
              SizedBox(width: 12.rw),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      restaurant.name,
                      style: TextStyle(
                        fontSize: 16.rf,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.rh),
                    Text(
                      '${restaurant.city}, ${restaurant.country}',
                      style: TextStyle(
                        fontSize: 14.rf,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              if (restaurant.isVerified)
                Icon(
                  Icons.verified,
                  color: Colors.blue,
                  size: 20.rw,
                ),
            ],
          ),
          SizedBox(height: 12.rh),
          Row(
            children: [
              Icon(Icons.phone, size: 16.rw, color: Colors.grey.shade600),
              SizedBox(width: 4.rw),
              Text(
                restaurant.phoneNumber,
                style: TextStyle(
                  fontSize: 14.rf,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(width: 16.rw),
              Icon(Icons.email, size: 16.rw, color: Colors.grey.shade600),
              SizedBox(width: 4.rw),
              Expanded(
                child: Text(
                  restaurant.emailAddress,
                  style: TextStyle(
                    fontSize: 14.rf,
                    color: Colors.grey.shade600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.rh),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.rw,
                  vertical: 4.rh,
                ),
                decoration: BoxDecoration(
                  color: restaurant.isActive
                      ? Colors.green.shade50
                      : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(4.rw),
                ),
                child: Text(
                  restaurant.isActive ? 'نشط' : 'غير نشط',
                  style: TextStyle(
                    fontSize: 12.rf,
                    color: restaurant.isActive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 8.rw),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.rw,
                  vertical: 4.rh,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(4.rw),
                ),
                child: Text(
                  restaurant.type,
                  style: TextStyle(
                    fontSize: 12.rf,
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: EdgeInsets.all(16.rw),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            margin: EdgeInsets.only(bottom: 12.rh),
            height: 120.rh,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.rw),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingMoreIndicator() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.rh),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64.rw,
            color: Colors.red,
          ),
          SizedBox(height: 16.rh),
          Text(
            errorMessage,
            style: TextStyle(
              fontSize: 16.rf,
              color: Colors.grey.shade700,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.rh),
          ElevatedButton(
            onPressed: () {
              context.read<RestaurantSectionsCubit>().refresh(sectionType);
            },
            child: const Text('إعادة المحاولة'),
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
            Icons.restaurant_menu,
            size: 64.rw,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 16.rh),
          Text(
            'لا توجد مطاعم',
            style: TextStyle(
              fontSize: 16.rf,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
