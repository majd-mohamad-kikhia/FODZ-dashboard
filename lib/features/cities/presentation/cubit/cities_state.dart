part of 'cities_cubit.dart';

enum CitiesStatus { initial, loading, success, error }

class CitiesState extends Equatable {
  const CitiesState({
    this.status = CitiesStatus.initial,
    this.cities = const [],
    this.errorMessage,
    this.isCreating = false,
    this.isDeleting = false,
  });

  final CitiesStatus status;
  final List<CityModel> cities;
  final String? errorMessage;
  final bool isCreating;
  final bool isDeleting;

  CitiesState copyWith({
    CitiesStatus? status,
    List<CityModel>? cities,
    String? errorMessage,
    bool? isCreating,
    bool? isDeleting,
  }) {
    return CitiesState(
      status: status ?? this.status,
      cities: cities ?? this.cities,
      errorMessage: errorMessage ?? this.errorMessage,
      isCreating: isCreating ?? this.isCreating,
      isDeleting: isDeleting ?? this.isDeleting,
    );
  }

  @override
  List<Object?> get props => [status, cities, errorMessage, isCreating, isDeleting];
}
