class OrderCustomerModel {
  final int id;
  final String name;
  final String phoneNumber;

  OrderCustomerModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
  });

  factory OrderCustomerModel.fromJson(Map<String, dynamic> json) {
    return OrderCustomerModel(
      id: json['id'] as int,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
    };
  }
}
