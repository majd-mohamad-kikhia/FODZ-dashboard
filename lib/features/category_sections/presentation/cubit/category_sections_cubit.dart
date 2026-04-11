import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodzdashbord/features/category_sections/data/api/category_sections_client.dart';
import 'package:foodzdashbord/features/category_sections/data/models/category_section_response.dart';

class CategorySectionsCubit extends Cubit<CategorySectionsState> {
  final CategorySectionsClient _client;

  CategorySectionsCubit(this._client)
      : super(CategorySectionsState.initial());

  Future<void> fetchCategories({
    required CategorySectionType sectionType,
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

      final result = await _client.getCategorySection(
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
                errorMessage: error.message ?? 'حدث خطأ في تحميل الفئات',
              ));
            }
          } catch (_) {}
        },
        (response) {
          try {
            if (!isClosed) {
              final List<SectionCategory> updatedCategories = isLoadMore
                  ? [...state.categories, ...response.categories]
                  : response.categories;

              emit(state.copyWith(
                categories: updatedCategories,
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
            errorMessage: 'حدث خطأ في تحميل الفئات',
          ));
        }
      } catch (_) {}
    }
  }

  Future<void> loadMore(CategorySectionType sectionType) async {
    if (state.isLoadingMore || !state.hasMorePages) return;

    await fetchCategories(
      sectionType: sectionType,
      page: state.currentPage + 1,
      isLoadMore: true,
    );
  }

  Future<void> refresh(CategorySectionType sectionType) async {
    await fetchCategories(
      sectionType: sectionType,
      page: 1,
      isLoadMore: false,
    );
  }

  void clear() {
    try {
      if (!isClosed) {
        emit(CategorySectionsState.initial());
      }
    } catch (_) {}
  }
}

class CategorySectionsState {
  final List<SectionCategory> categories;
  final PaginationInfo? pagination;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final int currentPage;

  CategorySectionsState({
    required this.categories,
    this.pagination,
    required this.isLoading,
    required this.isLoadingMore,
    this.errorMessage,
    required this.currentPage,
  });

  factory CategorySectionsState.initial() {
    return CategorySectionsState(
      categories: [],
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

  CategorySectionsState copyWith({
    List<SectionCategory>? categories,
    PaginationInfo? pagination,
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
    int? currentPage,
  }) {
    return CategorySectionsState(
      categories: categories ?? this.categories,
      pagination: pagination ?? this.pagination,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}
