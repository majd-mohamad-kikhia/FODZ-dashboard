import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodzdashbord/features/product_sections/data/api/product_sections_client.dart';
import 'package:foodzdashbord/features/product_sections/data/models/product_section_response.dart';

class ProductSectionsCubit extends Cubit<ProductSectionsState> {
  final ProductSectionsClient _client;

  ProductSectionsCubit(this._client)
      : super(ProductSectionsState.initial());

  Future<void> fetchProducts({
    required ProductSectionType sectionType,
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

      final result = await _client.getProductSection(
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
                errorMessage: error.message ?? 'حدث خطأ في تحميل المنتجات',
              ));
            }
          } catch (_) {}
        },
        (response) {
          try {
            if (!isClosed) {
              final List<SectionProduct> updatedProducts = isLoadMore
                  ? [...state.products, ...response.products]
                  : response.products;

              emit(state.copyWith(
                products: updatedProducts,
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
            errorMessage: 'حدث خطأ في تحميل المنتجات',
          ));
        }
      } catch (_) {}
    }
  }

  Future<void> loadMore(ProductSectionType sectionType) async {
    if (state.isLoadingMore || !state.hasMorePages) return;

    await fetchProducts(
      sectionType: sectionType,
      page: state.currentPage + 1,
      isLoadMore: true,
    );
  }

  Future<void> refresh(ProductSectionType sectionType) async {
    await fetchProducts(
      sectionType: sectionType,
      page: 1,
      isLoadMore: false,
    );
  }

  void clear() {
    try {
      if (!isClosed) {
        emit(ProductSectionsState.initial());
      }
    } catch (_) {}
  }
}

class ProductSectionsState {
  final List<SectionProduct> products;
  final PaginationInfo? pagination;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final int currentPage;

  ProductSectionsState({
    required this.products,
    this.pagination,
    required this.isLoading,
    required this.isLoadingMore,
    this.errorMessage,
    required this.currentPage,
  });

  factory ProductSectionsState.initial() {
    return ProductSectionsState(
      products: [],
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

  ProductSectionsState copyWith({
    List<SectionProduct>? products,
    PaginationInfo? pagination,
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
    int? currentPage,
  }) {
    return ProductSectionsState(
      products: products ?? this.products,
      pagination: pagination ?? this.pagination,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}
