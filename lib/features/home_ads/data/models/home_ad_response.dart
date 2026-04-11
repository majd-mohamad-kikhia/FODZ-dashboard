import 'package:foodzdashbord/features/home_ads/data/models/home_ad_model.dart';

class HomeAdResponse {
  final String message;
  final List<HomeAdModel> data;

  HomeAdResponse({
    required this.message,
    required this.data,
  });

  factory HomeAdResponse.fromJson(Map<String, dynamic> json) {
    return HomeAdResponse(
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((ad) => HomeAdModel.fromJson(ad as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.map((ad) => ad.toJson()).toList(),
    };
  }
}
