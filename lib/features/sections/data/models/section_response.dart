class SectionsResponse {
  final List<Section> sections;

  SectionsResponse({required this.sections});

  factory SectionsResponse.fromJson(Map<String, dynamic> json) {
    return SectionsResponse(
      sections: (json['sections'] as List<dynamic>?)
              ?.map((e) => Section.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sections': sections.map((e) => e.toJson()).toList(),
    };
  }
}

class Section {
  final int id;
  final String screen;
  final String type;
  final String name;
  final List<SectionItem> items;

  Section({
    required this.id,
    required this.screen,
    required this.type,
    required this.name,
    required this.items,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      id: json['id'] ?? 0,
      screen: json['screen'] ?? '',
      type: json['type'] ?? '',
      name: json['name'] ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => SectionItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'screen': screen,
      'type': type,
      'name': name,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }

  String get screenDisplayName {
    switch (screen) {
      case 'res':
        return 'مطاعم';
      case 'fam':
        return 'أسر منتجة';
      case 'pless':
        return 'نعمة';
      default:
        return screen;
    }
  }

  String get typeDisplayName {
    switch (type) {
      case 'restaurant':
        return 'مطاعم';
      case 'cat':
        return 'فئات';
      case 'product':
        return 'منتجات';
      default:
        return type;
    }
  }
}

class SectionItem {
  final int id;
  final int sectionId;
  final int? categoryId;
  final int? productId;
  final int? restaurantId;
  final SectionCategory? category;
  final SectionProduct? product;
  final SectionRestaurant? restaurant;

  SectionItem({
    required this.id,
    required this.sectionId,
    this.categoryId,
    this.productId,
    this.restaurantId,
    this.category,
    this.product,
    this.restaurant,
  });

  factory SectionItem.fromJson(Map<String, dynamic> json) {
    return SectionItem(
      id: json['id'] ?? 0,
      sectionId: json['sectionId'] ?? 0,
      categoryId: json['categoryId'],
      productId: json['productId'],
      restaurantId: json['restaurantId'],
      category: json['category'] != null
          ? SectionCategory.fromJson(json['category'])
          : null,
      product: json['product'] != null
          ? SectionProduct.fromJson(json['product'])
          : null,
      restaurant: json['restaurant'] != null
          ? SectionRestaurant.fromJson(json['restaurant'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sectionId': sectionId,
      if (categoryId != null) 'categoryId': categoryId,
      if (productId != null) 'productId': productId,
      if (restaurantId != null) 'restaurantId': restaurantId,
      if (category != null) 'category': category!.toJson(),
      if (product != null) 'product': product!.toJson(),
      if (restaurant != null) 'restaurant': restaurant!.toJson(),
    };
  }
}

class SectionCategory {
  final int id;
  final String name;

  SectionCategory({
    required this.id,
    required this.name,
  });

  factory SectionCategory.fromJson(Map<String, dynamic> json) {
    return SectionCategory(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class SectionProduct {
  final int id;
  final String name;
  final String salePrice;
  final String? plessingPrice;

  SectionProduct({
    required this.id,
    required this.name,
    required this.salePrice,
    this.plessingPrice,
  });

  factory SectionProduct.fromJson(Map<String, dynamic> json) {
    return SectionProduct(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      salePrice: json['salePrice'] ?? '0',
      plessingPrice: json['plessingPrice'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'salePrice': salePrice,
      if (plessingPrice != null) 'plessingPrice': plessingPrice,
    };
  }

  bool get hasOffer => plessingPrice != null;
}

class SectionRestaurant {
  final int id;
  final String name;

  SectionRestaurant({
    required this.id,
    required this.name,
  });

  factory SectionRestaurant.fromJson(Map<String, dynamic> json) {
    return SectionRestaurant(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
