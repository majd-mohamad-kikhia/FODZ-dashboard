part of 'restaurants_cubit.dart';

enum RestaurantsStatus { initial, loading, success, error }
enum RestaurantActionStatus { idle, loading, success, error }

class RestaurantsState {
  const RestaurantsState({
    this.status = RestaurantsStatus.initial,
    this.actionStatus = RestaurantActionStatus.idle,
    this.restaurants = const [],
    this.searchTerm = '',
    this.errorMessage = '',
    this.actionMessage,
    this.selectedType = 'restaurant', // Default to restaurant type
    this.activeFilter = 'all', // 'all', 'active', or 'inactive'
  });

  final RestaurantsStatus status;
  final RestaurantActionStatus actionStatus;
  final List<RestaurantModel> restaurants;
  final String searchTerm;
  final String errorMessage;
  final String? actionMessage;
  final String selectedType; // 'restaurant' or 'home'
  final String activeFilter; // 'all', 'active', or 'inactive'

  List<RestaurantModel> get filteredRestaurants {
    // First filter by type
    var filtered = restaurants.where((r) => r.type == selectedType).toList();
    
    // Then filter by active status
    if (activeFilter == 'active') {
      filtered = filtered.where((r) => r.isActive ?? false).toList();
    } else if (activeFilter == 'inactive') {
      filtered = filtered.where((r) => !(r.isActive ?? false)).toList();
    }
    
    // Finally filter by search term
    if (searchTerm.isEmpty) return filtered;
    final String lowerSearch = searchTerm.toLowerCase();
    return filtered
        .where((r) =>
            r.name.toLowerCase().contains(lowerSearch) ||
            r.emailAddress.toLowerCase().contains(lowerSearch) ||
            r.phoneNumber.toLowerCase().contains(lowerSearch) ||
            (r.city?.toLowerCase().contains(lowerSearch) ?? false))
        .toList();
  }

  RestaurantsState copyWith({
    RestaurantsStatus? status,
    RestaurantActionStatus? actionStatus,
    List<RestaurantModel>? restaurants,
    String? searchTerm,
    String? errorMessage,
    String? actionMessage,
    String? selectedType,
    String? activeFilter,
  }) {
    return RestaurantsState(
      status: status ?? this.status,
      actionStatus: actionStatus ?? this.actionStatus,
      restaurants: restaurants ?? this.restaurants,
      searchTerm: searchTerm ?? this.searchTerm,
      errorMessage: errorMessage ?? this.errorMessage,
      actionMessage: actionMessage,
      selectedType: selectedType ?? this.selectedType,
      activeFilter: activeFilter ?? this.activeFilter,
    );
  }
}
