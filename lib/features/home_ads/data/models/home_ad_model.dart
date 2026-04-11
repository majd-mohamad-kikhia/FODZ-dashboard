class HomeAdModel {
  final int id;
  final int resId;
  final String? photoUrl;
  final AdRestaurant restaurant;

  HomeAdModel({
    required this.id,
    required this.resId,
    this.photoUrl,
    required this.restaurant,
  });

  factory HomeAdModel.fromJson(Map<String, dynamic> json) {
    return HomeAdModel(
      id: json['id'] as int,
      resId: json['resId'] as int,
      photoUrl: json['photoUrl'] as String?,
      restaurant: AdRestaurant.fromJson(json['restaurant'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'resId': resId,
      'photoUrl': photoUrl,
      'restaurant': restaurant.toJson(),
    };
  }
}

class AdRestaurant {
  final int id;
  final String name;
  final String? photoUrl;
  final String? coverUrl;

  AdRestaurant({
    required this.id,
    required this.name,
    this.photoUrl,
    this.coverUrl,
  });

  factory AdRestaurant.fromJson(Map<String, dynamic> json) {
    return AdRestaurant(
      id: json['id'] as int,
      name: json['name'] as String,
      photoUrl: json['photoUrl'] as String?,
      coverUrl: json['coverUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'photoUrl': photoUrl,
      'coverUrl': coverUrl,
    };
  }
}
