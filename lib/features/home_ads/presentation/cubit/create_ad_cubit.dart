import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:foodzdashbord/core/api/network_service.dart';
import 'package:foodzdashbord/features/home_ads/data/api/home_ads_client.dart';
import 'package:foodzdashbord/features/home_ads/data/models/active_restaurant_model.dart';

import 'dart:ui';
import 'package:foodzdashbord/core/utils/app_strings.dart';

part 'create_ad_state.dart';

class CreateAdCubit extends Cubit<CreateAdState> {
  CreateAdCubit() : super(const CreateAdState()) {
    fetchActiveRestaurants();
  }

  final IHomeAdsClient _client = HomeAdsClientImpl(NetworkServices());

  Future<void> fetchActiveRestaurants() async {
    try {
      emit(state.copyWith(status: CreateAdStatus.loading));

      final result = await _client.fetchActiveRestaurants();

      result.fold(
        (error) {
          emit(state.copyWith(
            status: CreateAdStatus.error,
            errorMessage: AppStrings.localizeBackendMessage(error.message ?? 'فشل في تحميل المطاعم', const Locale('ar')),
          ));
        },
        (response) {
          emit(state.copyWith(
            status: CreateAdStatus.success,
            restaurants: response.data,
          ));
        },
      );
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.cancel) {
        // Ignore cancel exceptions during fast navigation
        return;
      }
      emit(state.copyWith(
        status: CreateAdStatus.error,
        errorMessage: 'Failed to load restaurants: $e',
      ));
    }
  }

  void selectRestaurant(ActiveRestaurantModel? restaurant) {
    emit(state.copyWith(
      selectedRestaurant: restaurant,
      clearSelectedRestaurant: restaurant == null,
    ));
  }

  void setImage({String? path, Uint8List? bytes, String? fileName}) {
    emit(state.copyWith(
      imagePath: path,
      imageBytes: bytes,
      imageFileName: fileName,
      clearImage: path == null && bytes == null,
    ));
  }

  void retry() {
    fetchActiveRestaurants();
  }
}
