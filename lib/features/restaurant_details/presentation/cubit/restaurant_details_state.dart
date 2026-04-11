part of 'restaurant_details_cubit.dart';

enum RestaurantDetailsStatus { initial, loading, success, error }

class RestaurantDetailsState {
  const RestaurantDetailsState({
    this.status = RestaurantDetailsStatus.initial,
    this.categories = const [],
    this.errorMessage = '',
  });

  final RestaurantDetailsStatus status;
  final List<RestaurantCategory> categories;
  final String errorMessage;

  RestaurantDetailsState copyWith({
    RestaurantDetailsStatus? status,
    List<RestaurantCategory>? categories,
    String? errorMessage,
  }) {
    return RestaurantDetailsState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
