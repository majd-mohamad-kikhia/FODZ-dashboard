import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodzdashbord/features/cities/data/api/cities_client.dart';
import 'package:foodzdashbord/features/cities/data/models/city_model.dart';

part 'cities_state.dart';

class CitiesCubit extends Cubit<CitiesState> {
  CitiesCubit() : super(const CitiesState()) {
    fetchCities();
  }

  final CitiesClient _client = CitiesClient();

  Future<void> fetchCities() async {
    _emitSafely(state.copyWith(status: CitiesStatus.loading));
    final result = await _client.fetchCities();
    result.fold(
      (error) => _emitSafely(state.copyWith(
        status: CitiesStatus.error,
        errorMessage: error.message,
      )),
      (cities) => _emitSafely(state.copyWith(
        status: CitiesStatus.success,
        cities: cities,
      )),
    );
  }

  Future<String?> createCity({required String name, required String nameAr}) async {
    _emitSafely(state.copyWith(isCreating: true));
    final result = await _client.createCity(name: name, nameAr: nameAr);
    return result.fold(
      (error) {
        _emitSafely(state.copyWith(isCreating: false));
        return error.message;
      },
      (city) {
        _emitSafely(state.copyWith(
          isCreating: false,
          cities: [...state.cities, city],
        ));
        return null;
      },
    );
  }

  Future<String?> deleteCity(int cityId) async {
    _emitSafely(state.copyWith(isDeleting: true));
    final result = await _client.deleteCity(cityId);
    return result.fold(
      (error) {
        _emitSafely(state.copyWith(isDeleting: false));
        return error.message;
      },
      (_) {
        _emitSafely(state.copyWith(
          isDeleting: false,
          cities: state.cities.where((c) => c.id != cityId).toList(),
        ));
        return null;
      },
    );
  }

  void _emitSafely(CitiesState newState) {
    if (!isClosed) emit(newState);
  }
}
