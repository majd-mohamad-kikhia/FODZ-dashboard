import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodzdashbord/core/api/network_service.dart';
import 'package:foodzdashbord/features/category_sections/data/api/category_details_client.dart';
import 'package:foodzdashbord/features/category_sections/data/models/category_details_response.dart';

part 'category_details_state.dart';

class CategoryDetailsCubit extends Cubit<CategoryDetailsState> {
  CategoryDetailsCubit() : super(const CategoryDetailsState());

  final ICategoryDetailsClient _client = CategoryDetailsClientImpl(NetworkServices());

  Future<void> fetchProducts(int restaurantId, int categoryId) async {
    try {
      if (isClosed) return;
      emit(state.copyWith(status: CategoryDetailsStatus.loading));
    } catch (_) {}

    final result = await _client.fetchCategoryProducts(restaurantId, categoryId);

    result.fold(
      (error) {
        try {
          if (isClosed) return;
          emit(state.copyWith(
            status: CategoryDetailsStatus.error,
            errorMessage: error.message ?? 'فشل في تحميل المنتجات',
          ));
        } catch (_) {}
      },
      (products) {
        try {
          if (isClosed) return;
          emit(state.copyWith(
            status: CategoryDetailsStatus.success,
            products: products,
          ));
        } catch (_) {}
      },
    );
  }

  void clear() {
    try {
      if (isClosed) return;
      emit(const CategoryDetailsState());
    } catch (_) {}
  }
}
