import 'package:equatable/equatable.dart';

// Enum to represent the different states of an order
enum ProductProgressStatus {
  inPreparation, // قيد التحضير
  waitingForDelegate, // بانتظار المندوب
  deliveredToDelegate, // تم تسليم الطلب للمندوب
}

class ProductProgress extends Equatable {
  final String id;
  final String productName;
  final int quantity;
  final String customerName;
  final String orderTime;
  final ProductProgressStatus status;

  const ProductProgress({
    required this.id,
    required this.productName,
    required this.quantity,
    required this.customerName,
    required this.orderTime,
    required this.status,
  });

  ProductProgress copyWith({ProductProgressStatus? status}) {
    return ProductProgress(
      id: id,
      productName: productName,
      quantity: quantity,
      customerName: customerName,
      orderTime: orderTime,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [id, productName, quantity, customerName, orderTime, status];
}
