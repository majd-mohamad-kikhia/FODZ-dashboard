import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:foodzdashbord/core/api/network_service.dart';
import 'package:foodzdashbord/features/restaurants/data/api/restaurants_client.dart';
import 'package:foodzdashbord/features/restaurants/data/models/restaurant_model.dart';

import 'dart:ui';
import 'package:foodzdashbord/core/utils/app_strings.dart';

part 'restaurants_state.dart';

class RestaurantsCubit extends Cubit<RestaurantsState> {
  RestaurantsCubit() : super(const RestaurantsState()) {
    _initialize();
  }

  final TextEditingController searchController = TextEditingController();
  final IRestaurantsClient _restaurantsClient = RestaurantsClientImpl(NetworkServices());

  Future<void> fetchRestaurants() async {
    try {
      emit(state.copyWith(status: RestaurantsStatus.loading));

      final result = await _restaurantsClient.fetchRestaurants();

      result.fold(
        (error) {
          try {
            if (isClosed) return;
            emit(state.copyWith(
              status: RestaurantsStatus.error,
              errorMessage: AppStrings.localizeBackendMessage(error.message ?? 'فشل في تحميل المطاعم', const Locale('ar')),
            ));
          } catch (_) {}
        },
        (restaurants) {
          try {
            if (isClosed) return;
            emit(state.copyWith(
              status: RestaurantsStatus.success,
              restaurants: restaurants,
            ));
          } catch (_) {}
        },
      );
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.cancel) {
        // Ignore cancel exceptions during fast navigation
        return;
      }
      try {
        if (isClosed) return;
        emit(state.copyWith(
          status: RestaurantsStatus.error,
          errorMessage: 'Failed to load restaurants: $e',
        ));
      } catch (_) {}
    }
  }

  Future<void> _initialize() async {
    try {
      if (isClosed) return;
      emit(state.copyWith(status: RestaurantsStatus.loading));

      final result = await _restaurantsClient.fetchRestaurants();

      result.fold(
        (error) {
          if (isClosed) return;
          emit(state.copyWith(
            status: RestaurantsStatus.error,
            errorMessage: AppStrings.localizeBackendMessage(error.message ?? 'فشل في تحميل المطاعم', const Locale('ar')),
          ));
        },
        (restaurants) {
          if (isClosed) return;
          emit(state.copyWith(
            status: RestaurantsStatus.success,
            restaurants: restaurants,
          ));
        },
      );
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.cancel) return;
      if (isClosed) return;
      emit(state.copyWith(
        status: RestaurantsStatus.error,
        errorMessage: 'Failed to load restaurants: $e',
      ));
    }
  }

  void updateSearch(String term) {
    emit(state.copyWith(searchTerm: term));
  }

  void clearSearch() {
    searchController.clear();
    emit(state.copyWith(searchTerm: ''));
  }

  void filterByType(String type) {
    emit(state.copyWith(selectedType: type));
  }

  void filterByActiveStatus(String filter) {
    emit(state.copyWith(activeFilter: filter));
  }

  Future<void> banRestaurant(int restaurantId) async {
    emit(state.copyWith(actionStatus: RestaurantActionStatus.loading));

    final result = await _restaurantsClient.banRestaurant(restaurantId);

    result.fold(
      (error) {
        emit(state.copyWith(
          actionStatus: RestaurantActionStatus.error,
          actionMessage: AppStrings.localizeBackendMessage(
            error.message ?? 'فشل في حظر المطعم',
            const Locale('ar'),
          ),
        ));
      },
      (message) {
        final updatedRestaurants = state.restaurants.map((r) {
          if (r.id == restaurantId) {
            return RestaurantModel(
              id: r.id,
              name: r.name,
              phoneNumber: r.phoneNumber,
              emailAddress: r.emailAddress,
              status: r.status,
              isActive: false,
              isVerified: r.isVerified,
              type: r.type,
              city: r.city,
              country: r.country,
              createdAt: r.createdAt,
              totalRates: r.totalRates,
              averageRating: r.averageRating,
              image: r.image,
              photoUrl: r.photoUrl,
              coverUrl: r.coverUrl,
            );
          }
          return r;
        }).toList();

        emit(state.copyWith(
          actionStatus: RestaurantActionStatus.success,
          actionMessage: AppStrings.localizeBackendMessage(message, const Locale('ar')),
          restaurants: updatedRestaurants,
        ));

        Future.delayed(const Duration(seconds: 2), () {
          if (!isClosed) {
            emit(state.copyWith(
              actionStatus: RestaurantActionStatus.idle,
              actionMessage: null,
            ));
          }
        });
      },
    );
  }

  Future<void> unbanRestaurant(int restaurantId) async {
    emit(state.copyWith(actionStatus: RestaurantActionStatus.loading));

    final result = await _restaurantsClient.unbanRestaurant(restaurantId);

    result.fold(
      (error) {
        emit(state.copyWith(
          actionStatus: RestaurantActionStatus.error,
          actionMessage: AppStrings.localizeBackendMessage(
            error.message ?? 'فشل في إلغاء حظر المطعم',
            const Locale('ar'),
          ),
        ));
      },
      (message) {
        final updatedRestaurants = state.restaurants.map((r) {
          if (r.id == restaurantId) {
            return RestaurantModel(
              id: r.id,
              name: r.name,
              phoneNumber: r.phoneNumber,
              emailAddress: r.emailAddress,
              status: r.status,
              isActive: true,
              isVerified: r.isVerified,
              type: r.type,
              city: r.city,
              country: r.country,
              createdAt: r.createdAt,
              totalRates: r.totalRates,
              averageRating: r.averageRating,
              image: r.image,
              photoUrl: r.photoUrl,
              coverUrl: r.coverUrl,
            );
          }
          return r;
        }).toList();

        emit(state.copyWith(
          actionStatus: RestaurantActionStatus.success,
          actionMessage: message,
          restaurants: updatedRestaurants,
        ));

        Future.delayed(const Duration(seconds: 2), () {
          if (!isClosed) {
            emit(state.copyWith(
              actionStatus: RestaurantActionStatus.idle,
              actionMessage: null,
            ));
          }
        });
      },
    );
  }

  @override
  Future<void> close() {
    searchController.dispose();
    return super.close();
  }
}
