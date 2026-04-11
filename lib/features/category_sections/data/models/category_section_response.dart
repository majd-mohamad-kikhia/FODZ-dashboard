class CategorySectionResponse {
  final String message;
  final List<SectionCategory> categories;
  final PaginationInfo pagination;

  CategorySectionResponse({
    required this.message,
    required this.categories,
    required this.pagination,
  });

  factory CategorySectionResponse.fromJson(Map<String, dynamic> json) {
    return CategorySectionResponse(
      message: json['message'] ?? '',
      categories:
          (json['categories'] as List<dynamic>?)
              ?.map((e) => SectionCategory.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pagination: PaginationInfo.fromJson(json['pagination'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'categories': categories.map((e) => e.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}

class SectionCategory {
  final int id;
  final String name;
  final String description;
  final int restaurantId;
  final List<CategoryProduct> products;

  SectionCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.restaurantId,
    required this.products,
  });

  factory SectionCategory.fromJson(Map<String, dynamic> json) {
    return SectionCategory(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      restaurantId: json['restaurantId'] ?? 0,
      products:
          (json['products'] as List<dynamic>?)
              ?.map((e) => CategoryProduct.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'restaurantId': restaurantId,
      'products': products.map((e) => e.toJson()).toList(),
    };
  }
}

class CategoryProduct {
  final int id;
  final String name;
  final String salePrice;
  final String description;

  CategoryProduct({
    required this.id,
    required this.name,
    required this.salePrice,
    required this.description,
  });

  factory CategoryProduct.fromJson(Map<String, dynamic> json) {
    return CategoryProduct(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      salePrice: json['salePrice'] ?? '0',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'salePrice': salePrice,
      'description': description,
    };
  }
}

class PaginationInfo {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;

  PaginationInfo({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.itemsPerPage,
  });

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      totalItems: json['totalItems'] ?? 0,
      itemsPerPage: json['itemsPerPage'] ?? 20,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPage': currentPage,
      'totalPages': totalPages,
      'totalItems': totalItems,
      'itemsPerPage': itemsPerPage,
    };
  }
}
