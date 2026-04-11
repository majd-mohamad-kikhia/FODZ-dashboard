class OrderRestaurantModel {
  final int id;
  final String name;

  OrderRestaurantModel({
    required this.id,
    required this.name,
  });

  factory OrderRestaurantModel.fromJson(Map<String, dynamic> json) {
    return OrderRestaurantModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
