class RestaurantDetailsResponse {
  final String message;
  final List<RestaurantCategory> categories;

  RestaurantDetailsResponse({
    required this.message,
    required this.categories,
  });

  factory RestaurantDetailsResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantDetailsResponse(
      message: json['message'] ?? '',
      categories: (json['categories'] as List<dynamic>?)
              ?.map((e) => RestaurantCategory.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'categories': categories.map((e) => e.toJson()).toList(),
    };
  }
}

class RestaurantCategory {
  final int id;
  final String name;
  final String description;
  final int restaurantId;
  final String? photoURL;

  RestaurantCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.restaurantId,
    this.photoURL,
  });

  factory RestaurantCategory.fromJson(Map<String, dynamic> json) {
    return RestaurantCategory(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      restaurantId: json['restaurantId'] ?? 0,
      photoURL: json['photoURL'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'restaurantId': restaurantId,
      'photoURL': photoURL,
    };
  }
}
