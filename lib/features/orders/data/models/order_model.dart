import 'package:foodzdashbord/features/orders/data/models/order_customer_model.dart';
import 'package:foodzdashbord/features/orders/data/models/order_restaurant_model.dart';

class OrderModel {
  final int id;
  final String status;
  final String paymentStatus;
  final String totalAmount;
  final String paymentMethod;
  final OrderCustomerModel customer;
  final OrderRestaurantModel restaurant;

  OrderModel({
    required this.id,
    required this.status,
    required this.paymentStatus,
    required this.totalAmount,
    required this.paymentMethod,
    required this.customer,
    required this.restaurant,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as int,
      status: json['status'] as String,
      paymentStatus: json['paymentStatus'] as String,
      totalAmount: json['totalAmount'] as String,
      paymentMethod: (json['paymentMethod'] as String?) ?? '',
      customer: OrderCustomerModel.fromJson(json['customer'] as Map<String, dynamic>),
      restaurant: OrderRestaurantModel.fromJson(json['restaurant'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'paymentStatus': paymentStatus,
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'customer': customer.toJson(),
      'restaurant': restaurant.toJson(),
    };
  }

  double get totalPrice {
    try {
      return double.parse(totalAmount);
    } catch (e) {
      return 0.0;
    }
  }

  String get statusArabic {
    switch (status.toLowerCase()) {
      case 'completed':
        return 'مكتمل';
      case 'pending':
        return 'بالانتظار';
      case 'accepted':
        return 'مقبول';
      case 'shipped':
        return 'قيد التوصيل';
      case 'denied':
        return 'مرفوض';
      default:
        return status;
    }
  }

  String get paymentStatusArabic {
    switch (paymentStatus.toLowerCase()) {
      case 'paid':
        return 'مدفوع';
      case 'unpaid':
        return 'غير مدفوع';
      case 'pending':
        return 'بالانتظار';
      default:
        return paymentStatus;
    }
  }

  bool get isCashPayment => paymentMethod.toLowerCase() == 'cash';
}
