import 'package:foodzdashbord/features/restaurants/data/models/pending_restaurant_model.dart';

class PendingRestaurantsResponseModel {
  final String message;
  final List<PendingRestaurantModel> restaurants;

  PendingRestaurantsResponseModel({
    required this.message,
    required this.restaurants,
  });

  factory PendingRestaurantsResponseModel.fromJson(Map<String, dynamic> json) {
    return PendingRestaurantsResponseModel(
      message: json['message'] as String,
      restaurants: (json['restaurants'] as List<dynamic>)
          .map((restaurant) => PendingRestaurantModel.fromJson(restaurant as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'restaurants': restaurants.map((r) => r.toJson()).toList(),
    };
  }
}
