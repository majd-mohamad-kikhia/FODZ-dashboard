class BannedUserModel {
  const BannedUserModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.banReason,
  });

  final int id;
  final String name;
  final String phoneNumber;
  final String banReason;

  factory BannedUserModel.fromJson(Map<String, dynamic> json) {
    return BannedUserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      banReason: json['banReason'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'banReason': banReason,
    };
  }
}
