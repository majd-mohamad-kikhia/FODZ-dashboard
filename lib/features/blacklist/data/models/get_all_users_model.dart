
class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.emailAddress,
    required this.isActive,
    this.banReason,
    this.city,
  });

  final int id;
  final String name;
  final String phoneNumber;
  final String? emailAddress;
  final bool isActive;
  final String? banReason;
  final String? city;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      emailAddress: json['emailAddress'] as String?,
      isActive: json['isActive'] as bool,
      banReason: json['banReason'] as String?,
      city: json['city'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'emailAddress': emailAddress,
      'isActive': isActive,
      'banReason': banReason,
      'city': city,
    };
  }
}
