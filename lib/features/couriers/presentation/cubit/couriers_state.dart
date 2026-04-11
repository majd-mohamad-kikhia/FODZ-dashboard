part of 'couriers_cubit.dart';

enum CouriersStatus { initial, loading, success, error }

class CouriersState {
  const CouriersState({
    this.status = CouriersStatus.initial,
    this.couriers = const [],
    this.searchTerm = '',
    this.errorMessage = '',
    this.selectedCourier,
  });

  final CouriersStatus status;
  final List<CourierModel> couriers;
  final String searchTerm;
  final String errorMessage;
  final CourierModel? selectedCourier;

  List<CourierModel> get filteredCouriers {
    if (searchTerm.isEmpty) return couriers;
    final String lowerSearch = searchTerm.toLowerCase();
    return couriers
        .where((c) =>
            c.name.toLowerCase().contains(lowerSearch) ||
            c.phoneNumber.contains(lowerSearch) ||
            c.id.contains(lowerSearch))
        .toList();
  }

  CouriersState copyWith({
    CouriersStatus? status,
    List<CourierModel>? couriers,
    String? searchTerm,
    String? errorMessage,
    CourierModel? selectedCourier,
  }) {
    return CouriersState(
      status: status ?? this.status,
      couriers: couriers ?? this.couriers,
      searchTerm: searchTerm ?? this.searchTerm,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedCourier: selectedCourier ?? this.selectedCourier,
    );
  }
}

class CourierModel {
  const CourierModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.isWorking,
    required this.photoUrl,
    this.email,
    this.vehicleType,
    this.city,
    this.joinedDate,
    this.completedOrders = 0,
  });

  final String id;
  final String name;
  final String phoneNumber;
  final bool isWorking;
  final String photoUrl;
  final String? email;
  final String? vehicleType;
  final String? city;
  final String? joinedDate;
  final int completedOrders;
}
