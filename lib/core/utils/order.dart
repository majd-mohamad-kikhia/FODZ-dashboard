import 'package:equatable/equatable.dart';

// Enum to represent the different states of an order
enum OrderStatus {
  pending, // New order, waiting for accept/reject
  inPreparation, // قيد التحضير
  waitingForDelegate, // بانتظار المندوب
  deliveredToDelegate, // تم تسليم الطلب للمندوب
  completed, // Order delivered to the customer
  rejected, // Order rejected by the restaurant
}

class Order extends Equatable {
  final String id;
  final String productName;
  final int quantity;
  final String customerName;
  final String orderTime;
  final String coverImage;
  final OrderStatus status;

  const Order({
    required this.id,
    required this.productName,
    required this.quantity,
    required this.customerName,
    required this.orderTime,
    required this.coverImage,
    required this.status,
  });

  Order copyWith({OrderStatus? status}) {
    return Order(
      id: id,
      productName: productName,
      quantity: quantity,
      customerName: customerName,
      orderTime: orderTime,
      coverImage: coverImage,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [id, productName, quantity, customerName, orderTime, coverImage, status];
}
