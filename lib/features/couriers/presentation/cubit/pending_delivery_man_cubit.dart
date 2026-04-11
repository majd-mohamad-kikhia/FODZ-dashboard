import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:foodzdashbord/core/api/network_service.dart';
import 'package:foodzdashbord/features/couriers/data/api/pending_delivery_man_client.dart';
import 'package:foodzdashbord/features/couriers/data/models/pending_delivery_man_model.dart';

import 'dart:ui';
import 'package:foodzdashbord/core/utils/app_strings.dart';

enum PendingDeliveryManStatus { initial, loading, loaded, error, approving }

class PendingDeliveryManState {
  final PendingDeliveryManStatus status;
  final List<PendingDeliveryMan> deliveryMen;
  final String? errorMessage;
  final String? successMessage;

  PendingDeliveryManState({
    this.status = PendingDeliveryManStatus.initial,
    this.deliveryMen = const [],
    this.errorMessage,
    this.successMessage,
  });

  PendingDeliveryManState copyWith({
    PendingDeliveryManStatus? status,
    List<PendingDeliveryMan>? deliveryMen,
    String? errorMessage,
    String? successMessage,
  }) {
    return PendingDeliveryManState(
      status: status ?? this.status,
      deliveryMen: deliveryMen ?? this.deliveryMen,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}

class PendingDeliveryManCubit extends Cubit<PendingDeliveryManState> {
  final IPendingDeliveryManClient _client;

  PendingDeliveryManCubit()
      : _client = PendingDeliveryManClientImpl(NetworkServices()),
        super(PendingDeliveryManState());

  Future<void> fetchPendingDeliveryMen() async {
    try {
      if (isClosed) return;
      emit(state.copyWith(status: PendingDeliveryManStatus.loading));
    } catch (_) {}

    try {
      final result = await _client.getPendingDeliveryMen();

      result.fold(
        (error) {
          try {
            if (isClosed) return;
            emit(state.copyWith(
              status: PendingDeliveryManStatus.error,
              errorMessage: AppStrings.localizeBackendMessage(error.message ?? '', const Locale('ar')),
            ));
          } catch (_) {}
        },
        (response) {
          try {
            if (isClosed) return;
            emit(state.copyWith(
              status: PendingDeliveryManStatus.loaded,
              deliveryMen: response.deliveryMen,
            ));
          } catch (_) {}
        },
      );
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.cancel) {
        // Ignore cancel exceptions during fast navigation
        return;
      }
      try {
        if (isClosed) return;
        emit(state.copyWith(
          status: PendingDeliveryManStatus.error,
          errorMessage: 'Failed to load pending delivery men: $e',
        ));
      } catch (_) {}
    }
  }

  Future<void> approveDeliveryMan(int deliveryManId) async {
    try {
      if (isClosed) return;
      emit(state.copyWith(status: PendingDeliveryManStatus.approving));
    } catch (_) {}

    final result = await _client.approveDeliveryMan(deliveryManId);

    result.fold(
      (error) {
        try {
          if (isClosed) return;
          emit(state.copyWith(
            status: PendingDeliveryManStatus.error,
            errorMessage: AppStrings.localizeBackendMessage(error.message ?? '', const Locale('ar')),
          ));
        } catch (_) {}
      },
      (message) {
        try {
          if (isClosed) return;
          // Remove the approved delivery man from the list
          final updatedList = state.deliveryMen
              .where((d) => d.id != deliveryManId)
              .toList();
          
          emit(state.copyWith(
            status: PendingDeliveryManStatus.loaded,
            deliveryMen: updatedList,
            successMessage: AppStrings.localizeBackendMessage(message, const Locale('ar')),
          ));
        } catch (_) {}
      },
    );
  }
}
