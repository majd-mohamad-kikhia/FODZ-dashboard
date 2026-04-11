class RestaurantMenuCategory {
  const RestaurantMenuCategory({required this.name, required this.items});

  final String name;
  final List<RestaurantMenuItem> items;
}

class RestaurantMenuItem {
  const RestaurantMenuItem({
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.rating = 0.0,
    this.isPopular = false,
    this.brandName,
    this.brandLogo,
  });

  final String title;
  final String description;
  final double price;
  final double rating;
  final String imageUrl;
  final bool isPopular;
  final String? brandName;
  final String? brandLogo;
}
