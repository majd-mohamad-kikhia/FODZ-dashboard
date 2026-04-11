import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodzdashbord/core/utils/appColors.dart';
import 'package:foodzdashbord/core/utils/constants.dart';
import 'package:foodzdashbord/core/widgets/buil_widgets.dart';
import 'package:foodzdashbord/features/category_sections/presentation/cubit/category_details_cubit.dart';
import 'package:foodzdashbord/features/home/cubit/home_nav_cubit.dart';
import 'package:foodzdashbord/features/home/presentation/widgets/product_card_item.dart';

class CategoryProductsContent extends StatelessWidget {
  const CategoryProductsContent({
    required this.restaurantId,
    required this.categoryId,
    required this.categoryName,
  });

  final int restaurantId;
  final int categoryId;
  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CategoryDetailsCubit()..fetchProducts(restaurantId, categoryId),
      child: BlocBuilder<CategoryDetailsCubit, CategoryDetailsState>(
        builder: (context, state) {
          if (state.status == CategoryDetailsStatus.loading) {
            return buildShimmerLoading(categoryName);
          }

          if (state.status == CategoryDetailsStatus.error) {
             return buildErrorState(context, state.errorMessage, () => context.read<CategoryDetailsCubit>().fetchProducts(restaurantId, categoryId));
          }

          if (state.products.isEmpty) {
            return buildEmptyState();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16.rw),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: AppColors.textDark),
                      onPressed: () {
                        context.read<HomeNavCubit>().closeCategoryProducts();
                      },
                    ),
                    12.hSpace,
                    Text(
                      categoryName,
                      style: TextStyle(
                        fontSize: 18.rf,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(16.rw),
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    final product = state.products[index];
                    return ProductCardItem(product: product);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}