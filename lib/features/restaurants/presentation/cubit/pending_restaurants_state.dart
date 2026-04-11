part of 'pending_restaurants_cubit.dart';

enum PendingRestaurantsStatus { initial, loading, success, error }

class PendingRestaurantsState {
  const PendingRestaurantsState({
    this.status = PendingRestaurantsStatus.initial,
    this.restaurants = const [],
    this.errorMessage = '',
  });

  final PendingRestaurantsStatus status;
  final List<PendingRestaurantModel> restaurants;
  final String errorMessage;

  PendingRestaurantsState copyWith({
    PendingRestaurantsStatus? status,
    List<PendingRestaurantModel>? restaurants,
    String? errorMessage,
  }) {
    return PendingRestaurantsState(
      status: status ?? this.status,
      restaurants: restaurants ?? this.restaurants,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
