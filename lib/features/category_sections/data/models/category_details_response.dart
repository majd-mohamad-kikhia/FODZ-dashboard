class CategoryDetailsResponse {
  final String message;
  final List<CategoryProduct> data;

  CategoryDetailsResponse({
    required this.message,
    required this.data,
  });

  factory CategoryDetailsResponse.fromJson(Map<String, dynamic> json) {
    return CategoryDetailsResponse(
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => CategoryProduct.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class CategoryProduct {
  final int id;
  final String name;
  final String description;
  final String salePrice;
  final int prepTimeMinutes;
  final List<ProductOffer> offers;
  final String? photoURL;

  CategoryProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.salePrice,
    required this.prepTimeMinutes,
    required this.offers,
    this.photoURL,
  });

  factory CategoryProduct.fromJson(Map<String, dynamic> json) {
    return CategoryProduct(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      salePrice: json['salePrice'] ?? '0',
      prepTimeMinutes: json['prepTimeMinutes'] ?? 0,
      offers: (json['offers'] as List<dynamic>?)
              ?.map((e) => ProductOffer.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      photoURL: json['photoURL'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'salePrice': salePrice,
      'prepTimeMinutes': prepTimeMinutes,
      'offers': offers.map((e) => e.toJson()).toList(),
      'photoURL': photoURL,
    };
  }
}

class ProductOffer {
  final int id;
  final String type;
  final String? amount;
  final String? percentage;
  final String startDate;
  final String endDate;

  ProductOffer({
    required this.id,
    required this.type,
    this.amount,
    this.percentage,
    required this.startDate,
    required this.endDate,
  });

  factory ProductOffer.fromJson(Map<String, dynamic> json) {
    return ProductOffer(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      amount: json['amount'],
      percentage: json['percentage'],
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'percentage': percentage,
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}
