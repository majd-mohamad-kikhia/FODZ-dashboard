part of 'delivery_man_cubit.dart';

enum DeliveryManStatus { initial, loading, success, error }
enum DeliveryManActionStatus { idle, loading, success, error }

class DeliveryManState {
  const DeliveryManState({
    this.status = DeliveryManStatus.initial,
    this.actionStatus = DeliveryManActionStatus.idle,
    this.deliveryMen = const [],
    this.currentPage = 1,
    this.hasMorePages = true,
    this.isLoadingMore = false,
    this.currentFilter = DeliveryManFilter.all,
    this.errorMessage,
    this.actionMessage,
    this.meta,
  });

  final DeliveryManStatus status;
  final DeliveryManActionStatus actionStatus;
  final List<DeliveryMan> deliveryMen;
  final int currentPage;
  final bool hasMorePages;
  final bool isLoadingMore;
  final DeliveryManFilter currentFilter;
  final String? errorMessage;
  final String? actionMessage;
  final DeliveryManMeta? meta;

  List<DeliveryMan> get filteredDeliveryMen {
    switch (currentFilter) {
      case DeliveryManFilter.all:
        return deliveryMen;
      case DeliveryManFilter.active:
        return deliveryMen.where((dm) => dm.isActive).toList();
      case DeliveryManFilter.banned:
        return deliveryMen.where((dm) => !dm.isActive).toList();
    }
  }

  DeliveryManState copyWith({
    DeliveryManStatus? status,
    DeliveryManActionStatus? actionStatus,
    List<DeliveryMan>? deliveryMen,
    int? currentPage,
    bool? hasMorePages,
    bool? isLoadingMore,
    DeliveryManFilter? currentFilter,
    String? errorMessage,
    String? actionMessage,
    DeliveryManMeta? meta,
  }) {
    return DeliveryManState(
      status: status ?? this.status,
      actionStatus: actionStatus ?? this.actionStatus,
      deliveryMen: deliveryMen ?? this.deliveryMen,
      currentPage: currentPage ?? this.currentPage,
      hasMorePages: hasMorePages ?? this.hasMorePages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      currentFilter: currentFilter ?? this.currentFilter,
      errorMessage: errorMessage,
      actionMessage: actionMessage,
      meta: meta ?? this.meta,
    );
  }
}
