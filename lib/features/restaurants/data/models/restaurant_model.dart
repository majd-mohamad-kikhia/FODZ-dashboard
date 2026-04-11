class RestaurantModel {
  final int id;
  final String name;
  final String phoneNumber;
  final String emailAddress;
  final String? status;
  final bool? isActive;
  final bool isVerified;
  final String type;
  final String? city;
  final String? country;
  final String? createdAt;
  final String? totalRates;
  final String? averageRating;
  final String image;
  final String? photoUrl;
  final String? coverUrl;
  final String? pdfUrl;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.emailAddress,
    this.status,
    this.isActive,
    required this.isVerified,
    required this.type,
    this.city,
    this.country,
    this.createdAt,
    String? totalRates,
    String? averageRating,
    required this.image,
    this.photoUrl,
    this.coverUrl,
    this.pdfUrl,
  })  : totalRates = totalRates ?? '0',
       averageRating = averageRating ?? '0.0';

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      emailAddress: json['emailAddress'] as String? ?? '',
      status: json['status'] as String?,
      isActive: json['isActive'] as bool?,
      isVerified: json['isVerified'] as bool? ?? false,
      type: json['type'] as String? ?? '',
      city: json['city'] as String? ?? '',
      country: json['country'] as String? ?? '',
      createdAt: json['createdAt'] as String?,
      totalRates: json['totalRates']?.toString() ?? '0',
      averageRating: json['averageRating']?.toString() ?? '0.0',
      image: json['image'] as String? ?? '',
      photoUrl: json['photoUrl'] as String?,
      coverUrl: json['coverUrl'] as String?,
      pdfUrl: json['pdfUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'emailAddress': emailAddress,
      'status': status,
      'isActive': isActive,
      'isVerified': isVerified,
      'type': type,
      'city': city,
      'country': country,
      'createdAt': createdAt,
      'totalRates': totalRates,
      'averageRating': averageRating,
      'image': image,
      'photoUrl': photoUrl,
      'coverUrl': coverUrl,
      'pdfUrl': pdfUrl,
    };
  }

  double get rating {
    try {
      return double.parse(averageRating??'0');
    } catch (e) {
      return 0.0;
    }
  }

  int get reviewsCount {
    try {
      return int.parse(totalRates ?? "0");
    } catch (e) {
      return 0;
    }
  }

  String get displayCover {
    if (coverUrl != null && coverUrl!.isNotEmpty) return coverUrl!;
    if (image.isNotEmpty) return image;
    return photoUrl ?? '';
  }

  String get displayPhoto {
    if (photoUrl != null && photoUrl!.isNotEmpty) return photoUrl!;
    if (image.isNotEmpty) return image;
    return coverUrl ?? '';
  }
}
