import 'package:foodzdashbord/features/restaurants/data/models/restaurant_model.dart';

class RestaurantsResponseModel {
  final String message;
  final List<RestaurantModel> restaurants;

  RestaurantsResponseModel({
    required this.message,
    required this.restaurants,
  });

  factory RestaurantsResponseModel.fromJson(Map<String, dynamic> json) {
    return RestaurantsResponseModel(
      message: json['message'] as String,
      restaurants: (json['restaurants'] as List<dynamic>)
          .map((restaurant) => RestaurantModel.fromJson(restaurant as Map<String, dynamic>))
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
