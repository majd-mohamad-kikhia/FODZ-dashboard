part of 'category_details_cubit.dart';

enum CategoryDetailsStatus { initial, loading, success, error }

class CategoryDetailsState {
  const CategoryDetailsState({
    this.status = CategoryDetailsStatus.initial,
    this.products = const [],
    this.errorMessage = '',
  });

  final CategoryDetailsStatus status;
  final List<CategoryProduct> products;
  final String errorMessage;

  CategoryDetailsState copyWith({
    CategoryDetailsStatus? status,
    List<CategoryProduct>? products,
    String? errorMessage,
  }) {
    return CategoryDetailsState(
      status: status ?? this.status,
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
