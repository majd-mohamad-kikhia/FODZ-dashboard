class RestaurantSectionResponse {
  final String message;
  final List<SectionRestaurant> restaurants;
  final PaginationInfo pagination;

  RestaurantSectionResponse({
    required this.message,
    required this.restaurants,
    required this.pagination,
  });

  factory RestaurantSectionResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantSectionResponse(
      message: json['message'] ?? '',
      restaurants: (json['restaurants'] as List<dynamic>?)
              ?.map((e) => SectionRestaurant.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      pagination: PaginationInfo.fromJson(json['pagination'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'restaurants': restaurants.map((e) => e.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }
}

class SectionRestaurant {
  final int id;
  final String name;
  final String phoneNumber;
  final String emailAddress;
  final String type;
  final String city;
  final String country;
  final String latitude;
  final String longitude;
  final bool isActive;
  final bool isVerified;

  SectionRestaurant({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.emailAddress,
    required this.type,
    required this.city,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.isActive,
    required this.isVerified,
  });

  factory SectionRestaurant.fromJson(Map<String, dynamic> json) {
    return SectionRestaurant(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      emailAddress: json['emailAddress'] ?? '',
      type: json['type'] ?? '',
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      isActive: json['isActive'] ?? false,
      isVerified: json['isVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'emailAddress': emailAddress,
      'type': type,
      'city': city,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'isActive': isActive,
      'isVerified': isVerified,
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
