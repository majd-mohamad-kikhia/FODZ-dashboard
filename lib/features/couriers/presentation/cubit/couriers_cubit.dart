import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'couriers_state.dart';

class CouriersCubit extends Cubit<CouriersState> {
  CouriersCubit() : super(const CouriersState()) {
    _initialize();
  }

  final TextEditingController searchController = TextEditingController();

  void _initialize() {
    // TODO: Fetch couriers from API
    emit(state.copyWith(
      status: CouriersStatus.success,
      couriers: _mockCouriers,
    ));
  }

  void updateSearch(String term) {
    emit(state.copyWith(searchTerm: term));
  }

  void clearSearch() {
    searchController.clear();
    emit(state.copyWith(searchTerm: ''));
  }

  void selectCourier(CourierModel courier) {
    emit(state.copyWith(selectedCourier: courier));
  }

  void clearSelectedCourier() {
    emit(state.copyWith(selectedCourier: null));
  }

  @override
  Future<void> close() {
    searchController.dispose();
    return super.close();
  }
}

// Mock data
final List<CourierModel> _mockCouriers = [
  CourierModel(
    id: '1',
    name: 'محمد أحمد',
    phoneNumber: '0501234567',
    isWorking: true,
    photoUrl: 'https://via.placeholder.com/100',
  ),
  CourierModel(
    id: '2',
    name: 'خالد سعيد',
    phoneNumber: '0507654321',
    isWorking: true,
    photoUrl: 'https://via.placeholder.com/100',
  ),
  CourierModel(
    id: '3',
    name: 'عبدالله علي',
    phoneNumber: '0509876543',
    isWorking: false,
    photoUrl: 'https://via.placeholder.com/100',
  ),
  CourierModel(
    id: '4',
    name: 'فهد حسن',
    phoneNumber: '0503456789',
    isWorking: true,
    photoUrl: 'https://via.placeholder.com/100',
  ),
  CourierModel(
    id: '5',
    name: 'سلطان عمر',
    phoneNumber: '0508765432',
    isWorking: false,
    photoUrl: 'https://via.placeholder.com/100',
  ),
  CourierModel(
    id: '6',
    name: 'ناصر يوسف',
    phoneNumber: '0502345678',
    isWorking: true,
    photoUrl: 'https://via.placeholder.com/100',
  ),
];
