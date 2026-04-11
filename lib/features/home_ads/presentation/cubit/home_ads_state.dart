part of 'home_ads_cubit.dart';

enum HomeAdsStatus { initial, loading, success, error }

class HomeAdsState {
  final HomeAdsStatus status;
  final List<HomeAdModel> homeAds;
  final String? errorMessage;

  const HomeAdsState({
    this.status = HomeAdsStatus.initial,
    this.homeAds = const [],
    this.errorMessage,
  });

  HomeAdsState copyWith({
    HomeAdsStatus? status,
    List<HomeAdModel>? homeAds,
    String? errorMessage,
  }) {
    return HomeAdsState(
      status: status ?? this.status,
      homeAds: homeAds ?? this.homeAds,
      errorMessage: errorMessage,
    );
  }
}
