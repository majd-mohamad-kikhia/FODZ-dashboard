import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String? description;
  final double price;
  final String imageUrl;
  final bool isActive;
  final List<String> addons;
  final int? preparationTime;

  const Product({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.imageUrl,
    this.isActive = true,
    this.addons = const [],
    this.preparationTime,
  });

  @override
  List<Object?> get props =>
      [id, name, description, price, imageUrl, isActive, addons, preparationTime];

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    bool? isActive,
    List<String>? addons,
    int? preparationTime,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
      addons: addons ?? this.addons,
      preparationTime: preparationTime ?? this.preparationTime,
    );
  }
}
