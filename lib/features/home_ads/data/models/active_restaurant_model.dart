class ActiveRestaurantModel {
  final int id;
  final String name;
  final String? photoUrl;
  final String? coverUrl;
  final String type;
  final String description;

  ActiveRestaurantModel({
    required this.id,
    required this.name,
    this.photoUrl,
    this.coverUrl,
    required this.type,
    required this.description,
  });

  factory ActiveRestaurantModel.fromJson(Map<String, dynamic> json) {
    return ActiveRestaurantModel(
      id: json['id'] as int,
      name: json['name'] as String,
      photoUrl: json['photoUrl'] as String?,
      coverUrl: json['coverUrl'] as String?,
      type: json['type'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'photoUrl': photoUrl,
      'coverUrl': coverUrl,
      'type': type,
      'description': description,
    };
  }
}

class ActiveRestaurantResponse {
  final String message;
  final List<ActiveRestaurantModel> data;

  ActiveRestaurantResponse({
    required this.message,
    required this.data,
  });

  factory ActiveRestaurantResponse.fromJson(Map<String, dynamic> json) {
    return ActiveRestaurantResponse(
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((restaurant) => ActiveRestaurantModel.fromJson(restaurant as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.map((restaurant) => restaurant.toJson()).toList(),
    };
  }
}
