import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:foodzdashbord/core/api/network_service.dart';
import 'package:foodzdashbord/features/restaurant_details/data/api/restaurant_details_client.dart';
import 'package:foodzdashbord/features/restaurant_details/data/models/restaurant_details_response.dart';

import 'dart:ui';
import 'package:foodzdashbord/core/utils/app_strings.dart';

part 'restaurant_details_state.dart';

class RestaurantDetailsCubit extends Cubit<RestaurantDetailsState> {
  RestaurantDetailsCubit() : super(const RestaurantDetailsState());

  final IRestaurantDetailsClient _client = RestaurantDetailsClientImpl(NetworkServices());

  Future<void> fetchCategories(int restaurantId) async {
    try {
      if (isClosed) return;
      emit(state.copyWith(status: RestaurantDetailsStatus.loading));
    } catch (_) {}

    try {
      final result = await _client.fetchRestaurantCategories(restaurantId);

      result.fold(
        (error) {
          try {
            if (isClosed) return;
            emit(state.copyWith(
              status: RestaurantDetailsStatus.error,
              errorMessage: AppStrings.localizeBackendMessage(error.message ?? 'فشل في تحميل الفئات', const Locale('ar')),
            ));
          } catch (_) {}
        },
        (categories) {
          try {
            if (isClosed) return;
            emit(state.copyWith(
              status: RestaurantDetailsStatus.success,
              categories: categories,
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
          status: RestaurantDetailsStatus.error,
          errorMessage: 'Failed to load categories: $e',
        ));
      } catch (_) {}
    }
  }

  void clear() {
    try {
      if (isClosed) return;
      emit(const RestaurantDetailsState());
    } catch (_) {}
  }
}
