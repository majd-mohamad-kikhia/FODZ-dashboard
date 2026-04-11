import 'package:equatable/equatable.dart';

class RestaurantCategory extends Equatable {
  const RestaurantCategory({
    required this.id,
    required this.name,
    required this.itemsCount,
    this.coverImage,
    this.description,
    this.isActive = true,
  });

  final String id;
  final String name;
  final int itemsCount;
  final String? coverImage;
  final String? description;
  final bool isActive;

  RestaurantCategory copyWith({
    String? id,
    String? name,
    int? itemsCount,
    String? coverImage,
    String? description,
    bool? isActive,
  }) {
    return RestaurantCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      itemsCount: itemsCount ?? this.itemsCount,
      coverImage: coverImage ?? this.coverImage,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [id, name, itemsCount, coverImage, description, isActive];
}
