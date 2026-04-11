class PendingDeliveryMan {
  final int id;
  final String name;
  final String phoneNumber;
  final String emailAddress;
  final String? pdf1Url;
  final String? pdf2Url;
  final String? pdf3Url;

  PendingDeliveryMan({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.emailAddress,
    this.pdf1Url,
    this.pdf2Url,
    this.pdf3Url,
  });

  factory PendingDeliveryMan.fromJson(Map<String, dynamic> json) {
    return PendingDeliveryMan(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      emailAddress: json['emailAddress'] as String? ?? '',
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
      'pdf1Url': pdf1Url,
      'pdf2Url': pdf2Url,
      'pdf3Url': pdf3Url,
    };
  }
}

class PendingDeliveryMenResponse {
  final String message;
  final List<PendingDeliveryMan> deliveryMen;

  PendingDeliveryMenResponse({
    required this.message,
    required this.deliveryMen,
  });

  factory PendingDeliveryMenResponse.fromJson(Map<String, dynamic> json) {
    return PendingDeliveryMenResponse(
      message: json['message'] as String? ?? '',
      deliveryMen: (json['deliveryMen'] as List<dynamic>?)
          ?.map((item) => PendingDeliveryMan.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'deliveryMen': deliveryMen.map((d) => d.toJson()).toList(),
    };
  }
}
