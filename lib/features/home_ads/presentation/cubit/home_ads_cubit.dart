import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:foodzdashbord/core/api/network_service.dart';
import 'package:foodzdashbord/features/home_ads/data/api/home_ads_client.dart';
import 'package:foodzdashbord/features/home_ads/data/models/home_ad_model.dart';

import 'dart:ui';
import 'package:foodzdashbord/core/utils/app_strings.dart';

part 'home_ads_state.dart';

class HomeAdsCubit extends Cubit<HomeAdsState> {
  HomeAdsCubit() : super(const HomeAdsState()) {
    fetchHomeAds();
  }

  final IHomeAdsClient _client = HomeAdsClientImpl(NetworkServices());

  Future<void> fetchHomeAds() async {
    try {
      emit(state.copyWith(status: HomeAdsStatus.loading));

      final result = await _client.fetchHomeAds();

      result.fold(
        (error) {
          try {
            if (isClosed) return;
            emit(state.copyWith(
              status: HomeAdsStatus.error,
              errorMessage: AppStrings.localizeBackendMessage(error.message ?? 'فشل في تحميل الإعلانات', const Locale('ar')),
            ));
          } catch (_) {}
        },
        (response) {
          try {
            if (isClosed) return;
            emit(state.copyWith(
              status: HomeAdsStatus.success,
              homeAds: response.data,
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
          status: HomeAdsStatus.error,
          errorMessage: 'Failed to load home ads: $e',
        ));
      } catch (_) {}
    }
  }

  Future<bool> createHomeAd({
    required int resId,
    required String imagePath,
  }) async {
    final result = await _client.createHomeAd(
      resId: resId,
      imagePath: imagePath,
    );

    return result.fold(
      (error) => false,
      (data) {
        fetchHomeAds();
        return true;
      },
    );
  }

  Future<bool> deleteHomeAd(int adId) async {
    final result = await _client.deleteHomeAd(adId);

    return result.fold(
      (error) => false,
      (data) {
        fetchHomeAds();
        return true;
      },
    );
  }

  void retry() {
    fetchHomeAds();
  }
}
