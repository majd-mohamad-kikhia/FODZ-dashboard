import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import 'package:foodzdashbord/core/utils/appColors.dart';
import 'package:foodzdashbord/core/utils/constants.dart';
import 'package:foodzdashbord/features/home/cubit/home_nav_cubit.dart';
import 'package:foodzdashbord/features/category_sections/data/api/category_sections_client.dart';
import 'package:foodzdashbord/features/category_sections/presentation/cubit/category_sections_cubit.dart';
import 'package:foodzdashbord/features/sections/presentation/cubit/section_selection_cubit.dart';

class CategoriesListingGrid extends StatelessWidget {
  const CategoriesListingGrid({super.key, required this.config});

  final DashboardSectionConfig config;

  @override
  Widget build(BuildContext context) {
    final sectionType = CategorySectionTypeConverter.fromDashboardScreen(
      config.screen,
    );

    return BlocBuilder<CategorySectionsCubit, CategorySectionsState>(
      builder: (context, state) {
        if (state.isLoading && state.categories.isEmpty) {
          return _buildShimmerLoading();
        }

        if (state.errorMessage != null && state.categories.isEmpty) {
          return _buildErrorState(context, state.errorMessage!, sectionType);
        }

        if (state.categories.isEmpty) {
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
                  context.read<CategorySectionsCubit>().loadMore(sectionType);
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
                    state.categories.length + (state.isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == state.categories.length) {
                    return _buildLoadingMoreCard();
                  }

                  final category = state.categories[index];
                  final isSelected = selectionState.selectedIds.contains(
                    category.id,
                  );
                  return _CategoryCard(
                    category: category,
                    index: index,
                    isSelected: isSelected,
                    onTap: () {
                      context.read<SectionSelectionCubit>().toggleSelection(
                        category.id,
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
    CategorySectionType sectionType,
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
              context.read<CategorySectionsCubit>().refresh(sectionType);
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
          Icon(Icons.category_rounded, size: 64.rw, color: AppColors.grey400),
          SizedBox(height: 16.rh),
          Text(
            'لا توجد فئات',
            style: TextStyle(fontSize: 16.rf, color: AppColors.grey600),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.index,
    required this.isSelected,
    required this.onTap,
  });

  final dynamic category;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
                          AppColors.infoBlue.withOpacity(0.14),
                          AppColors.infoBlue.withOpacity(0.08),
                        ],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.infoBlue.withOpacity(0.14),
                      ),
                    ),
                    child: Icon(
                      Icons.category_rounded,
                      color: AppColors.infoBlue,
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
                  else
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.rw,
                        vertical: 4.rh,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.infoBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${category.products.length} منتج',
                        style: TextStyle(
                          fontSize: 10.rf,
                          fontWeight: FontWeight.w600,
                          color: AppColors.infoBlue,
                        ),
                      ),
                    ),
                ],
              ),
              const Spacer(),
              Text(
                category.name,
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
                category.description,
                style: TextStyle(fontSize: 11.rf, color: AppColors.grey600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
