class DeliveryMan {
  final int id;
  final String name;
  final String phoneNumber;
  final String? emailAddress;
  final bool isActive;
  final String? pdf1Url;
  final String? pdf2Url;
  final String? pdf3Url;

  DeliveryMan({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.emailAddress,
    required this.isActive,
    this.pdf1Url,
    this.pdf2Url,
    this.pdf3Url,
  });

  factory DeliveryMan.fromJson(Map<String, dynamic> json) {
    return DeliveryMan(
      id: json['id'] as int,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      emailAddress: json['emailAddress'] as String?,
      isActive: json['isActive'] as bool,
      pdf1Url: json['pdf1Url'] as String?,
      pdf2Url: json['pdf2Url'] as String?,
      pdf3Url: json['pdf3Url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'emailAddress': emailAddress,
      'isActive': isActive,
      'pdf1Url': pdf1Url,
      'pdf2Url': pdf2Url,
      'pdf3Url': pdf3Url,
    };
  }
}

class DeliveryManMeta {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  DeliveryManMeta({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory DeliveryManMeta.fromJson(Map<String, dynamic> json) {
    return DeliveryManMeta(
      total: json['total'] as int,
      page: json['page'] as int,
      limit: json['limit'] as int,
      totalPages: json['totalPages'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'page': page,
      'limit': limit,
      'totalPages': totalPages,
    };
  }
}

class DeliveryManResponse {
  final String message;
  final List<DeliveryMan> drivers;
  final DeliveryManMeta meta;

  DeliveryManResponse({
    required this.message,
    required this.drivers,
    required this.meta,
  });

  factory DeliveryManResponse.fromJson(Map<String, dynamic> json) {
    return DeliveryManResponse(
      message: json['message'] as String,
      drivers: (json['drivers'] as List<dynamic>)
          .map((item) => DeliveryMan.fromJson(item as Map<String, dynamic>))
          .toList(),
      meta: DeliveryManMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'drivers': drivers.map((d) => d.toJson()).toList(),
      'meta': meta.toJson(),
    };
  }
}
