import 'package:foodzdashbord/features/auth/data/models/admin_model.dart';

class LoginResponseModel {
  final String message;
  final String token;
  final AdminModel admin;

  LoginResponseModel({
    required this.message,
    required this.token,
    required this.admin,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      message: json['message'] as String,
      token: json['token'] as String,
      admin: AdminModel.fromJson(json['admin'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'token': token,
      'admin': admin.toJson(),
    };
  }
}
