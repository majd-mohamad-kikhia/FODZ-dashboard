import 'package:foodzdashbord/features/orders/data/models/order_model.dart';

class OrdersResponseModel {
  final String message;
  final List<OrderModel> orders;

  OrdersResponseModel({
    required this.message,
    required this.orders,
  });

  factory OrdersResponseModel.fromJson(Map<String, dynamic> json) {
    return OrdersResponseModel(
      message: json['message'] as String,
      orders: (json['orders'] as List<dynamic>)
          .map((order) => OrderModel.fromJson(order as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'orders': orders.map((o) => o.toJson()).toList(),
    };
  }
}
