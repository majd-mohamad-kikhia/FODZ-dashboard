class AdminModel {
  final int id;
  final String name;
  final String email;
  final String phoneNumber;

  AdminModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }
}
