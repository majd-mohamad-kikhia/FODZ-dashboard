class PendingRestaurantModel {
  final int id;
  final String name;
  final String phoneNumber;
  final String emailAddress;
  final String status;
  final bool isActive;
  final bool isVerified;
  final String type;
  final String? city;
  final String? country;
  final String? photoUrl;
  final String? coverUrl;
  final String? pdfUrl;
  final String? receiptUrl;
  final String? paymentReceiptUrl;

  PendingRestaurantModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.emailAddress,
    required this.status,
    required this.isActive,
    required this.isVerified,
    required this.type,
    this.city,
    this.country,
    this.photoUrl,
    this.coverUrl,
    this.pdfUrl,
    this.receiptUrl,
    this.paymentReceiptUrl,
  });

  factory PendingRestaurantModel.fromJson(Map<String, dynamic> json) {
    return PendingRestaurantModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      emailAddress: json['emailAddress'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      isActive: json['isActive'] as bool? ?? false,
      isVerified: json['isVerified'] as bool? ?? false,
      type: json['type'] as String? ?? '',
      city: json['city'] as String?,
      country: json['country'] as String?,
      photoUrl: json['photoUrl'] as String?,
      coverUrl: json['coverUrl'] as String?,
      pdfUrl: json['pdfUrl'] as String?,
      receiptUrl: json['receiptUrl'] as String?,
      paymentReceiptUrl: json['paymentReceiptUrl'] as String?,
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
      'photoUrl': photoUrl,
      'coverUrl': coverUrl,
      'pdfUrl': pdfUrl,
      'receiptUrl': receiptUrl,
      'paymentReceiptUrl': paymentReceiptUrl,
    };
  }

  String get displayCover {
    if (coverUrl != null && coverUrl!.isNotEmpty) return coverUrl!;
    return photoUrl ?? '';
  }

  String get displayPhoto {
    if (photoUrl != null && photoUrl!.isNotEmpty) return photoUrl!;
    return coverUrl ?? '';
  }
}
