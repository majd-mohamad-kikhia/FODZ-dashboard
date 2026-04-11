import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:foodzdashbord/core/api/network_service.dart';
import 'package:foodzdashbord/features/couriers/data/api/delivery_man_client.dart';
import 'package:foodzdashbord/features/couriers/data/models/delivery_man_model.dart';

import 'dart:ui';
import 'package:foodzdashbord/core/utils/app_strings.dart';

part 'delivery_man_state.dart';

enum DeliveryManFilter { all, active, banned }

class DeliveryManCubit extends Cubit<DeliveryManState> {
  final IDeliveryManClient _client;

  DeliveryManCubit()
      : _client = DeliveryManClientImpl(NetworkServices()),
        super(const DeliveryManState());

  final ScrollController scrollController = ScrollController();

  void initialize() {
    scrollController.addListener(_onScroll);
    fetchDeliveryMen();
  }

  void _onScroll() {
    if (_isBottom && !state.isLoadingMore && state.hasMorePages) {
      loadMoreDeliveryMen();
    }
  }

  bool get _isBottom {
    if (!scrollController.hasClients) return false;
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  Future<void> fetchDeliveryMen({bool refresh = false}) async {
    try {
      if (refresh) {
        emit(state.copyWith(
          currentPage: 1,
          deliveryMen: [],
          hasMorePages: true,
        ));
      }

      emit(state.copyWith(status: DeliveryManStatus.loading));

      final result = await _client.getDeliveryMen(
        page: state.currentPage,
        limit: 20,
      );

      result.fold(
        (error) {
          try {
            if (isClosed) return;
            emit(state.copyWith(
              status: DeliveryManStatus.error,
              errorMessage: AppStrings.localizeBackendMessage(error.message ?? 'Failed to fetch delivery men', const Locale('ar')),
            ));
          } catch (_) {}
        },
        (response) {
          try {
            if (isClosed) return;
            final allDeliveryMen = [...state.deliveryMen, ...response.drivers];
            emit(state.copyWith(
              status: DeliveryManStatus.success,
              deliveryMen: allDeliveryMen,
              meta: response.meta,
              hasMorePages: response.meta.page < response.meta.totalPages,
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
          status: DeliveryManStatus.error,
          errorMessage: 'Failed to load delivery men: $e',
        ));
      } catch (_) {}
    }
  }

  Future<void> loadMoreDeliveryMen() async {
    try {
      if (state.isLoadingMore || !state.hasMorePages) return;

      emit(state.copyWith(isLoadingMore: true));

      final nextPage = state.currentPage + 1;
      final result = await _client.getDeliveryMen(
        page: nextPage,
        limit: 20,
      );

      result.fold(
        (error) {
          try {
            if (isClosed) return;
            emit(state.copyWith(
              isLoadingMore: false,
              errorMessage: AppStrings.localizeBackendMessage(error.message ?? 'Failed to load more delivery men', const Locale('ar')),
            ));
          } catch (_) {}
        },
        (response) {
          try {
            if (isClosed) return;
            final allDeliveryMen = [...state.deliveryMen, ...response.drivers];
            emit(state.copyWith(
              isLoadingMore: false,
              deliveryMen: allDeliveryMen,
              currentPage: nextPage,
              meta: response.meta,
              hasMorePages: response.meta.page < response.meta.totalPages,
              errorMessage: null,
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
          isLoadingMore: false,
          errorMessage: 'Failed to load more delivery men: $e',
        ));
      } catch (_) {}
    }
  }

  void changeFilter(DeliveryManFilter filter) {
    emit(state.copyWith(currentFilter: filter));
  }

  Future<void> banDeliveryMan(int deliveryManId) async {
    emit(state.copyWith(actionStatus: DeliveryManActionStatus.loading));

    final result = await _client.banDeliveryMan(deliveryManId);

    result.fold(
      (error) {
        try {
          if (isClosed) return;
          emit(state.copyWith(
            actionStatus: DeliveryManActionStatus.error,
            actionMessage: AppStrings.localizeBackendMessage(error.message ?? 'Failed to ban delivery man', const Locale('ar')),
          ));
        } catch (_) {}
      },
      (message) {
        try {
          if (isClosed) return;
          final updatedList = state.deliveryMen.map((dm) {
            if (dm.id == deliveryManId) {
              return DeliveryMan(
                id: dm.id,
                name: dm.name,
                phoneNumber: dm.phoneNumber,
                emailAddress: dm.emailAddress,
                isActive: false,
              );
            }
            return dm;
          }).toList();

          emit(state.copyWith(
            actionStatus: DeliveryManActionStatus.success,
            actionMessage: AppStrings.localizeBackendMessage(message, const Locale('ar')),
            deliveryMen: updatedList,
          ));
        } catch (_) {}

        Future.delayed(const Duration(seconds: 2), () {
          try {
            if (!isClosed) {
              emit(state.copyWith(
                actionStatus: DeliveryManActionStatus.idle,
                actionMessage: null,
              ));
            }
          } catch (_) {}
        });
      },
    );
  }

  Future<void> unbanDeliveryMan(int deliveryManId) async {
    emit(state.copyWith(actionStatus: DeliveryManActionStatus.loading));

    final result = await _client.unbanDeliveryMan(deliveryManId);

    result.fold(
      (error) {
        try {
          if (isClosed) return;
          emit(state.copyWith(
            actionStatus: DeliveryManActionStatus.error,
            actionMessage: AppStrings.localizeBackendMessage(error.message ?? 'Failed to unban delivery man', const Locale('ar')),
          ));
        } catch (_) {}
      },
      (message) {
        try {
          if (isClosed) return;
          final updatedList = state.deliveryMen.map((dm) {
            if (dm.id == deliveryManId) {
              return DeliveryMan(
                id: dm.id,
                name: dm.name,
                phoneNumber: dm.phoneNumber,
                emailAddress: dm.emailAddress,
                isActive: true,
              );
            }
            return dm;
          }).toList();

          emit(state.copyWith(
            actionStatus: DeliveryManActionStatus.success,
            actionMessage: AppStrings.localizeBackendMessage(message, const Locale('ar')),
            deliveryMen: updatedList,
          ));
        } catch (_) {}

        Future.delayed(const Duration(seconds: 2), () {
          try {
            if (!isClosed) {
              emit(state.copyWith(
                actionStatus: DeliveryManActionStatus.idle,
                actionMessage: null,
              ));
            }
          } catch (_) {}
        });
      },
    );
  }

  Future<void> giveWarning(int deliveryManId, String title, String body) async {
    emit(state.copyWith(actionStatus: DeliveryManActionStatus.loading));

    final result = await _client.giveWarning(deliveryManId, title, body);

    result.fold(
      (error) {
        try {
          if (isClosed) return;
          emit(state.copyWith(
            actionStatus: DeliveryManActionStatus.error,
            actionMessage: AppStrings.localizeBackendMessage(error.message ?? 'Failed to send warning', const Locale('ar')),
          ));
        } catch (_) {}
      },
      (message) {
        try {
          if (isClosed) return;
          emit(state.copyWith(
            actionStatus: DeliveryManActionStatus.success,
            actionMessage: AppStrings.localizeBackendMessage(message, const Locale('ar')),
          ));
        } catch (_) {}

        Future.delayed(const Duration(seconds: 2), () {
          try {
            if (!isClosed) {
              emit(state.copyWith(
                actionStatus: DeliveryManActionStatus.idle,
                actionMessage: null,
              ));
            }
          } catch (_) {}
        });
      },
    );
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    return super.close();
  }
}
