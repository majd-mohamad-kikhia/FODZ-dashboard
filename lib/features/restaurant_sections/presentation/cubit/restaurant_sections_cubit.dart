import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodzdashbord/features/restaurant_sections/data/api/restaurant_sections_client.dart';
import 'package:foodzdashbord/features/restaurant_sections/data/models/restaurant_section_response.dart';

class RestaurantSectionsCubit extends Cubit<RestaurantSectionsState> {
  final RestaurantSectionsClient _client;

  RestaurantSectionsCubit(this._client)
      : super(RestaurantSectionsState.initial());

  Future<void> fetchRestaurants({
    required SectionType sectionType,
    int page = 1,
    bool isLoadMore = false,
  }) async {
    if (state.isLoading) return;

    try {
      if (!isClosed) {
        if (isLoadMore) {
          emit(state.copyWith(isLoadingMore: true));
        } else {
          emit(state.copyWith(isLoading: true, errorMessage: null));
        }
      }

      final result = await _client.getRestaurantSection(
        sectionType: sectionType,
        page: page,
      );

      result.fold(
        (error) {
          try {
            if (!isClosed) {
              emit(state.copyWith(
                isLoading: false,
                isLoadingMore: false,
                errorMessage: error.message ?? 'حدث خطأ في تحميل المطاعم',
              ));
            }
          } catch (_) {}
        },
        (response) {
          try {
            if (!isClosed) {
              final List<SectionRestaurant> updatedRestaurants = isLoadMore
                  ? [...state.restaurants, ...response.restaurants]
                  : response.restaurants;

              emit(state.copyWith(
                restaurants: updatedRestaurants,
                pagination: response.pagination,
                isLoading: false,
                isLoadingMore: false,
                errorMessage: null,
                currentPage: page,
              ));
            }
          } catch (_) {}
        },
      );
    } catch (e) {
      try {
        if (!isClosed) {
          emit(state.copyWith(
            isLoading: false,
            isLoadingMore: false,
            errorMessage: 'حدث خطأ في تحميل المطاعم',
          ));
        }
      } catch (_) {}
    }
  }

  Future<void> loadMore(SectionType sectionType) async {
    if (state.isLoadingMore || !state.hasMorePages) return;

    await fetchRestaurants(
      sectionType: sectionType,
      page: state.currentPage + 1,
      isLoadMore: true,
    );
  }

  Future<void> refresh(SectionType sectionType) async {
    await fetchRestaurants(
      sectionType: sectionType,
      page: 1,
      isLoadMore: false,
    );
  }

  void clear() {
    try {
      if (!isClosed) {
        emit(RestaurantSectionsState.initial());
      }
    } catch (_) {}
  }
}

class RestaurantSectionsState {
  final List<SectionRestaurant> restaurants;
  final PaginationInfo? pagination;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final int currentPage;

  RestaurantSectionsState({
    required this.restaurants,
    this.pagination,
    required this.isLoading,
    required this.isLoadingMore,
    this.errorMessage,
    required this.currentPage,
  });

  factory RestaurantSectionsState.initial() {
    return RestaurantSectionsState(
      restaurants: [],
      pagination: null,
      isLoading: false,
      isLoadingMore: false,
      errorMessage: null,
      currentPage: 0,
    );
  }

  bool get hasMorePages {
    if (pagination == null) return false;
    return currentPage < pagination!.totalPages;
  }

  RestaurantSectionsState copyWith({
    List<SectionRestaurant>? restaurants,
    PaginationInfo? pagination,
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
    int? currentPage,
  }) {
    return RestaurantSectionsState(
      restaurants: restaurants ?? this.restaurants,
      pagination: pagination ?? this.pagination,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}
