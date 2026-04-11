class ProductSectionResponse {
  final String message;
  final List<SectionProduct> products;
  final PaginationInfo pagination;

  ProductSectionResponse({
    required this.message,
    required this.products,
    required this.pagination,
  });

  factory ProductSectionResponse.fromJson(Map<String, dynamic> json) {
    return ProductSectionResponse(
      message: json['message'] ?? '',
      products: (json['products'] as List<dynamic>?)
              ?.map((e) => SectionProduct.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pagination: PaginationInfo.fromJson(json['pagination'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'products': products.map((e) => e.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}

class SectionProduct {
  final int id;
  final String name;
  final String salePrice;
  final String description;
  final List<ProductOffer> offers;

  SectionProduct({
    required this.id,
    required this.name,
    required this.salePrice,
    required this.description,
    required this.offers,
  });

  factory SectionProduct.fromJson(Map<String, dynamic> json) {
    return SectionProduct(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      salePrice: json['salePrice'] ?? '0',
      description: json['description'] ?? '',
      offers: (json['offers'] as List<dynamic>?)
              ?.map((e) => ProductOffer.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'salePrice': salePrice,
      'description': description,
      'offers': offers.map((e) => e.toJson()).toList(),
    };
  }

  bool get hasOffer => offers.isNotEmpty;
  
  String get displayPrice {
    if (hasOffer) {
      return offers.first.plessingPrice;
    }
    return salePrice;
  }
}

class ProductOffer {
  final int id;
  final String plessingPrice;
  final String startDate;
  final String endDate;

  ProductOffer({
    required this.id,
    required this.plessingPrice,
    required this.startDate,
    required this.endDate,
  });

  factory ProductOffer.fromJson(Map<String, dynamic> json) {
    return ProductOffer(
      id: json['id'] ?? 0,
      plessingPrice: json['plessingPrice'] ?? '0',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plessingPrice': plessingPrice,
      'startDate': startDate,
      'endDate': endDate,
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
