import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import 'package:foodzdashbord/core/utils/appColors.dart';
import 'package:foodzdashbord/core/utils/constants.dart';
import 'package:foodzdashbord/features/home/cubit/home_nav_cubit.dart';
import 'package:foodzdashbord/features/product_sections/data/api/product_sections_client.dart';
import 'package:foodzdashbord/features/product_sections/presentation/cubit/product_sections_cubit.dart';
import 'package:foodzdashbord/features/sections/presentation/cubit/section_selection_cubit.dart';

class ProductsListingGrid extends StatelessWidget {
  const ProductsListingGrid({super.key, required this.config});

  final DashboardSectionConfig config;

  @override
  Widget build(BuildContext context) {
    final sectionType = ProductSectionTypeConverter.fromDashboardScreen(
      config.screen,
    );

    return BlocBuilder<ProductSectionsCubit, ProductSectionsState>(
      builder: (context, state) {
        if (state.isLoading && state.products.isEmpty) {
          return _buildShimmerLoading();
        }

        if (state.errorMessage != null && state.products.isEmpty) {
          return _buildErrorState(context, state.errorMessage!, sectionType);
        }

        if (state.products.isEmpty) {
          return _buildEmptyState();
        }

        return BlocBuilder<SectionSelectionCubit, SectionSelectionState>(
          builder: (context, selectionState) {
            return NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                if (scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent &&
                    !state.isLoadingMore &&
                    state.hasMorePages) {
                  context.read<ProductSectionsCubit>().loadMore(sectionType);
                }
                return false;
              },
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount:
                    state.products.length + (state.isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == state.products.length) {
                    return _buildLoadingMoreCard();
                  }

                  final product = state.products[index];
                  final isSelected = selectionState.selectedIds.contains(
                    product.id,
                  );
                  return _ProductCard(
                    product: product,
                    index: index,
                    isSelected: isSelected,
                    onTap: () {
                      context.read<SectionSelectionCubit>().toggleSelection(
                        product.id,
                      );
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildShimmerLoading() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppColors.grey200,
          highlightColor: Colors.grey.shade50,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingMoreCard() {
    return Container(
      padding: responsiveInsetsAll(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Center(
        child: CircularProgressIndicator(
          color: AppColors.primaryRed,
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    String errorMessage,
    ProductSectionType sectionType,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64.rw, color: AppColors.primaryRed),
          SizedBox(height: 16.rh),
          Text(
            errorMessage,
            style: TextStyle(fontSize: 16.rf, color: AppColors.grey700),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.rh),
          ElevatedButton(
            onPressed: () {
              context.read<ProductSectionsCubit>().refresh(sectionType);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              foregroundColor: Colors.white,
            ),
            child: Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 64.rw,
            color: AppColors.grey400,
          ),
          SizedBox(height: 16.rh),
          Text(
            'لا توجد منتجات',
            style: TextStyle(fontSize: 16.rf, color: AppColors.grey600),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    required this.index,
    required this.isSelected,
    required this.onTap,
  });

  final dynamic product;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool hasOffer = product.hasOffer;
    final String displayPrice = product.displayPrice;
    final String originalPrice = product.salePrice;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: responsiveInsetsAll(16),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryRed.withOpacity(0.05)
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.primaryRed : AppColors.grey200,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40.rw,
                    height: 40.rw,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryRed.withOpacity(0.14),
                          AppColors.secondaryRed.withOpacity(0.08),
                        ],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primaryRed.withOpacity(0.14),
                      ),
                    ),
                    child: Icon(
                      Icons.shopping_bag_rounded,
                      color: AppColors.primaryRed,
                      size: 15.rf,
                    ),
                  ),
                  const Spacer(),
                  if (isSelected)
                    Container(
                      padding: EdgeInsets.all(4.rw),
                      decoration: BoxDecoration(
                        color: AppColors.primaryRed,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check,
                        size: 14.rf,
                        color: Colors.white,
                      ),
                    )
                  else if (hasOffer)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.rw,
                        vertical: 4.rh,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.successGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.local_offer,
                            size: 12.rf,
                            color: AppColors.successGreen,
                          ),
                          SizedBox(width: 4.rw),
                          Text(
                            'نعمة',
                            style: TextStyle(
                              fontSize: 10.rf,
                              fontWeight: FontWeight.w600,
                              color: AppColors.successGreen,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const Spacer(),
              Text(
                product.name,
                style: TextStyle(
                  fontSize: 14.rf,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4.rh),
              Text(
                product.description,
                style: TextStyle(fontSize: 11.rf, color: AppColors.grey600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8.rh),
              Row(
                children: [
                  if (hasOffer) ...[
                    Text(
                      '${_formatPrice(originalPrice)} ج',
                      style: TextStyle(
                        fontSize: 10.rf,
                        color: AppColors.grey500,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    SizedBox(width: 6.rw),
                  ],
                  Text(
                    '${_formatPrice(displayPrice)} ج',
                    style: TextStyle(
                      fontSize: 12.rf,
                      fontWeight: FontWeight.w700,
                      color: hasOffer
                          ? AppColors.successGreen
                          : AppColors.primaryRed,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatPrice(String price) {
    try {
      final double value = double.parse(price);
      return value
          .toStringAsFixed(0)
          .replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},',
          );
    } catch (e) {
      return price;
    }
  }
}
