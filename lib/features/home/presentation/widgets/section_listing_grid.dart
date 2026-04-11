import 'package:flutter/material.dart';
import 'package:foodzdashbord/features/home/cubit/home_nav_cubit.dart';
import 'package:foodzdashbord/features/home/presentation/screens/_categories_listing_grid.dart';
import 'package:foodzdashbord/features/home/presentation/screens/_products_listing_grid.dart';
import 'package:foodzdashbord/features/home/presentation/screens/_restaurants_listing_grid.dart';

class SectionListingGrid extends StatelessWidget {
  const SectionListingGrid({required this.config});

  final DashboardSectionConfig config;

  @override
  Widget build(BuildContext context) {
    switch (config.contentType) {
      case DashboardContentType.restaurants:
        return RestaurantsListingGrid(config: config);
      case DashboardContentType.categories:
        return CategoriesListingGrid(config: config);
      case DashboardContentType.products:
        return ProductsListingGrid(config: config);
    }
  }
}