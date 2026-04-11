import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:foodzdashbord/core/api/network_service.dart';
import 'package:foodzdashbord/features/orders/data/api/orders_client.dart';
import 'package:foodzdashbord/features/orders/data/models/order_model.dart';

import 'dart:ui';
import 'package:foodzdashbord/core/utils/app_strings.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super(const OrdersState()) {
    _initialize();
  }

  final TextEditingController searchController = TextEditingController();
  final IOrdersClient _ordersClient = OrdersClientImpl(NetworkServices());

  Future<void> _initialize() async {
    try {
      emit(state.copyWith(status: OrdersStatus.loading));

      final result = await _ordersClient.fetchOrders();

      result.fold(
        (error) {
          try {
            if (isClosed) return;
            emit(state.copyWith(
              status: OrdersStatus.error,
              errorMessage: AppStrings.localizeBackendMessage(error.message ?? 'فشل في تحميل الطلبات', const Locale('ar')),
            ));
          } catch (_) {}
        },
        (orders) {
          try {
            if (isClosed) return;
            emit(state.copyWith(
              status: OrdersStatus.success,
              orders: orders,
            ));
          } catch (_) {}
        },
      );
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.cancel) {
        // Ignore cancel exceptions during fast navigation
        return;
      }
      emit(state.copyWith(
        status: OrdersStatus.error,
        errorMessage: 'Failed to load orders: $e',
      ));
    }
  }

  void updateSearch(String term) {
    emit(state.copyWith(searchTerm: term));
  }

  void clearSearch() {
    searchController.clear();
    emit(state.copyWith(searchTerm: ''));
  }

  Future<void> cancelOrder(int orderId, String reason) async {
    try {
      if (isClosed) return;

      emit(state.copyWith(status: OrdersStatus.loading));

      final result = await _ordersClient.cancelOrder(orderId, reason);

      result.fold(
        (error) {
          if (isClosed) return;
          emit(state.copyWith(
            status: OrdersStatus.error,
            errorMessage: AppStrings.localizeBackendMessage(error.message ?? 'فشل في إلغاء الطلب', const Locale('ar')),
          ));
        },
        (_) {
          // On success, refresh the orders list
          _initialize();
        },
      );
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(
        status: OrdersStatus.error,
        errorMessage: 'Failed to cancel order: $e',
      ));
    }
  }

  @override
  Future<void> close() {
    searchController.dispose();
    return super.close();
  }
}
