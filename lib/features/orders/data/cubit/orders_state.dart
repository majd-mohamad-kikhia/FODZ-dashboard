part of 'orders_cubit.dart';

enum OrdersStatus { initial, loading, success, error }

class OrdersState {
  const OrdersState({
    this.status = OrdersStatus.initial,
    this.orders = const [],
    this.searchTerm = '',
    this.errorMessage = '',
  });

  final OrdersStatus status;
  final List<OrderModel> orders;
  final String searchTerm;
  final String errorMessage;

  List<OrderModel> get filteredOrders {
    if (searchTerm.isEmpty) return orders;
    final String lowerSearch = searchTerm.toLowerCase();
    return orders
        .where((o) =>
            o.id.toString().contains(lowerSearch) ||
            o.restaurant.name.toLowerCase().contains(lowerSearch) ||
            o.customer.name.toLowerCase().contains(lowerSearch) ||
            o.customer.phoneNumber.toLowerCase().contains(lowerSearch))
        .toList();
  }

  OrdersState copyWith({
    OrdersStatus? status,
    List<OrderModel>? orders,
    String? searchTerm,
    String? errorMessage,
  }) {
    return OrdersState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      searchTerm: searchTerm ?? this.searchTerm,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
