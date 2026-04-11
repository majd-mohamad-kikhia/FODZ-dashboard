import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:foodzdashbord/core/api/network_service.dart';
import 'package:foodzdashbord/features/restaurants/data/api/pending_restaurants_client.dart';
import 'package:foodzdashbord/features/restaurants/data/models/pending_restaurant_model.dart';

import 'dart:ui';
import 'package:foodzdashbord/core/utils/app_strings.dart';

part 'pending_restaurants_state.dart';

class PendingRestaurantsCubit extends Cubit<PendingRestaurantsState> {
  PendingRestaurantsCubit() : super(const PendingRestaurantsState()) {
    fetchPendingRestaurants();
  }

  final IPendingRestaurantsClient _client = PendingRestaurantsClientImpl(NetworkServices());

  Future<void> fetchPendingRestaurants() async {
    try {
      emit(state.copyWith(status: PendingRestaurantsStatus.loading));

      final result = await _client.fetchPendingRestaurants();

      result.fold(
        (error) {
          emit(state.copyWith(
            status: PendingRestaurantsStatus.error,
            errorMessage: AppStrings.localizeBackendMessage(error.message ?? 'فشل في تحميل المطاعم المعلقة', const Locale('ar')),
          ));
        },
        (restaurants) {
          emit(state.copyWith(
            status: PendingRestaurantsStatus.success,
            restaurants: restaurants,
          ));
        },
      );
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.cancel) {
        // Ignore cancel exceptions during fast navigation
        return;
      }
      emit(state.copyWith(
        status: PendingRestaurantsStatus.error,
        errorMessage: 'Failed to load pending restaurants: $e',
      ));
    }
  }

  Future<bool> acceptRestaurant(int restaurantId) async {
    final result = await _client.acceptRestaurant(restaurantId);

    return result.fold(
      (error) {
        return false;
      },
      (success) {
        if (success) {
          final updatedRestaurants = state.restaurants
              .where((r) => r.id != restaurantId)
              .toList();
          emit(state.copyWith(restaurants: updatedRestaurants));
        }
        return success;
      },
    );
  }

  Future<bool> declineRestaurant(int restaurantId) async {
    final result = await _client.declineRestaurant(restaurantId);

    return result.fold(
      (error) {
        return false;
      },
      (success) {
        if (success) {
          final updatedRestaurants = state.restaurants
              .where((r) => r.id != restaurantId)
              .toList();
          emit(state.copyWith(restaurants: updatedRestaurants));
        }
        return success;
      },
    );
  }

  Future<void> refresh() async {
    await fetchPendingRestaurants();
  }
}
