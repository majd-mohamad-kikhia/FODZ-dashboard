import 'package:flutter/material.dart';

class Restaurant {
  const Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.rating,
    required this.reviewsCount,
    required this.deliveryTimeRange,
    required this.distanceKm,
    required this.priceLevel,
    required this.deliveryFee,
    required this.specialOffer,
    required this.coverImageUrl,
    required this.logoImageUrl,
    required this.tags,
    required this.categories,
    required this.isSponsored,
    this.plusBadgeColor,
  });

  final String id;
  final String name;
  final String description;
  final double rating;
  final int reviewsCount;
  final String deliveryTimeRange;
  final double distanceKm;
  final String priceLevel;
  final String deliveryFee;
  final String specialOffer;
  final String coverImageUrl;
  final String logoImageUrl;
  final List<String> tags;
  final List<RestaurantCategoryRef> categories;
  final bool isSponsored;
  final Color? plusBadgeColor;
}

class RestaurantCategoryRef {
  const RestaurantCategoryRef({required this.id, required this.name});

  final int id;
  final String name;
}
