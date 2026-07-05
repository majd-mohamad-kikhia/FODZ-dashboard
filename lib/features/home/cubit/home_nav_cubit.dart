import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:foodzdashbord/features/restaurants/data/models/restaurant_model.dart';
import 'package:foodzdashbord/features/money_management/data/cubit/config_cubit.dart';

enum DashboardScreen {
  homeProducers,
  restaurants,
  neama,
}

extension DashboardScreenDescriptor on DashboardScreen {
  String get title {
    switch (this) {
      case DashboardScreen.homeProducers:
        return 'أسر منتجة';
      case DashboardScreen.restaurants:
        return 'مطاعم';
      case DashboardScreen.neama:
        return 'نعمة';
    }
  }

  IconData get icon {
    switch (this) {
      case DashboardScreen.homeProducers:
        return Icons.home_work_rounded;
      case DashboardScreen.restaurants:
        return Icons.store_mall_directory_rounded;
      case DashboardScreen.neama:
        return Icons.volunteer_activism_rounded;
    }
  }
}

enum DashboardContentType {
  restaurants,
  categories,
  products,
}

extension DashboardContentTypeDescriptor on DashboardContentType {
  String get title {
    switch (this) {
      case DashboardContentType.restaurants:
        return 'مطاعم';
      case DashboardContentType.categories:
        return 'فئات';
      case DashboardContentType.products:
        return 'منتجات';
    }
  }

  IconData get icon {
    switch (this) {
      case DashboardContentType.restaurants:
        return Icons.restaurant_rounded;
      case DashboardContentType.categories:
        return Icons.category_rounded;
      case DashboardContentType.products:
        return Icons.shopping_bag_rounded;
    }
  }
}

class DashboardSectionConfig {
  const DashboardSectionConfig({
    required this.sectionName,
    required this.screen,
    required this.contentType,
    this.sectionId,
    this.existingIds,
  });

  final String sectionName;
  final DashboardScreen screen;
  final DashboardContentType contentType;
  final int? sectionId;
  final List<int>? existingIds;
}

enum HomeSection {
  dashboardHome,
  restaurants,
  orders,
  couriers,
  finance,
  blacklist,
  homeAds,
  cities,
}

extension HomeSectionDescriptor on HomeSection {
  String get title {
    switch (this) {
      case HomeSection.dashboardHome:
        return 'الصفحة الرئيسية';
      case HomeSection.restaurants:
        return 'المطاعم';
      case HomeSection.orders:
        return 'الطلبات';
      case HomeSection.couriers:
        return 'رجال التوصيل';
      case HomeSection.finance:
        return 'القسم المالي';
      case HomeSection.blacklist:
        return 'قائمة الحظر';
      case HomeSection.homeAds:
        return 'إعلانات الرئيسية';
      case HomeSection.cities:
        return 'المدن';
    }
  }

  IconData get icon {
    switch (this) {
      case HomeSection.dashboardHome:
        return Icons.home_rounded;
      case HomeSection.restaurants:
        return Icons.store_mall_directory_rounded;
      case HomeSection.orders:
        return Icons.receipt_long_rounded;
      case HomeSection.couriers:
        return Icons.delivery_dining;
      case HomeSection.finance:
        return Icons.account_balance_wallet_rounded;
      case HomeSection.blacklist:
        return Icons.block_rounded;
      case HomeSection.homeAds:
        return Icons.ad_units_rounded;
      case HomeSection.cities:
        return Icons.location_city_rounded;
    }
  }
}

class HomeNavState extends Equatable {
  const HomeNavState({
    required this.selectedSection,
    this.selectedRestaurant,
    this.selectedCategoryId,
    this.selectedCategoryName,
    this.selectedRestaurantId,
    this.isCreatingSection = false,
    this.sectionConfig,
    this.isOn = true,
    this.isRestaurantsEnabled = true,
    this.isHomeProducersEnabled = true,
    this.isNeamaEnabled = true,
  });

  final HomeSection selectedSection;
  final RestaurantModel? selectedRestaurant;
  final int? selectedCategoryId;
  final String? selectedCategoryName;
  final int? selectedRestaurantId;
  final bool isCreatingSection;
  final DashboardSectionConfig? sectionConfig;
  final bool isOn;
  final bool isRestaurantsEnabled;
  final bool isHomeProducersEnabled;
  final bool isNeamaEnabled;

  HomeNavState copyWith({
    HomeSection? selectedSection,
    RestaurantModel? selectedRestaurant,
    bool resetSelectedRestaurant = false,
    int? selectedCategoryId,
    String? selectedCategoryName,
    int? selectedRestaurantId,
    bool resetSelectedCategory = false,
    bool? isCreatingSection,
    DashboardSectionConfig? sectionConfig,
    bool resetSectionConfig = false,
    bool? isOn,
    bool? isRestaurantsEnabled,
    bool? isHomeProducersEnabled,
    bool? isNeamaEnabled,
  }) {
    return HomeNavState(
      selectedSection: selectedSection ?? this.selectedSection,
      selectedRestaurant: resetSelectedRestaurant
          ? null
          : selectedRestaurant ?? this.selectedRestaurant,
      selectedCategoryId: resetSelectedCategory
          ? null
          : selectedCategoryId ?? this.selectedCategoryId,
      selectedCategoryName: resetSelectedCategory
          ? null
          : selectedCategoryName ?? this.selectedCategoryName,
      selectedRestaurantId: resetSelectedCategory
          ? null
          : selectedRestaurantId ?? this.selectedRestaurantId,
      isCreatingSection: isCreatingSection ?? this.isCreatingSection,
      sectionConfig: resetSectionConfig ? null : sectionConfig ?? this.sectionConfig,
      isOn: isOn ?? this.isOn,
      isRestaurantsEnabled: isRestaurantsEnabled ?? this.isRestaurantsEnabled,
      isHomeProducersEnabled: isHomeProducersEnabled ?? this.isHomeProducersEnabled,
      isNeamaEnabled: isNeamaEnabled ?? this.isNeamaEnabled,
    );
  }

  @override
  List<Object?> get props => [
    selectedSection,
    selectedRestaurant,
    selectedCategoryId,
    selectedCategoryName,
    selectedRestaurantId,
    isCreatingSection,
    sectionConfig,
    isOn,
    isRestaurantsEnabled,
    isHomeProducersEnabled,
    isNeamaEnabled,
  ];
}

class HomeNavCubit extends Cubit<HomeNavState> {
  final ConfigCubit? configCubit;

  HomeNavCubit({this.configCubit})
      : super(const HomeNavState(selectedSection: HomeSection.restaurants)) {
    _initializeFromConfig();
  }

  void _initializeFromConfig() {
    if (configCubit != null) {
      final configState = configCubit!.state;
      if (configState.status == ConfigStatus.loaded) {
        _syncWithConfig(configState);
      }
    }
  }

  void syncWithConfig(ConfigState configState) {
    _syncWithConfig(configState);
  }

  void _syncWithConfig(ConfigState configState) {
    _emitSafely(state.copyWith(
      isRestaurantsEnabled: configState.restaurantKillSwitch,
      isHomeProducersEnabled: configState.homeKillSwitch,
      isNeamaEnabled: configState.plessingKillSwitch,
    ));
  }

  void selectSection(HomeSection section) {
    if (state.selectedSection == section) {
      if (section == HomeSection.restaurants && (state.selectedRestaurant != null || state.selectedCategoryId != null)) {
        _emitSafely(state.copyWith(resetSelectedRestaurant: true, resetSelectedCategory: true));
      }
      if (section == HomeSection.dashboardHome && (state.isCreatingSection || state.sectionConfig != null)) {
        _emitSafely(state.copyWith(isCreatingSection: false, resetSectionConfig: true));
      }
      return;
    }

    _emitSafely(
      state.copyWith(
        selectedSection: section,
        resetSelectedRestaurant: true,
        resetSelectedCategory: true,
        isCreatingSection: false,
        resetSectionConfig: true,
      ),
    );
  }

  void openRestaurantDetails(RestaurantModel restaurant) {
    if (state.selectedSection != HomeSection.restaurants) {
      _emitSafely(
        state.copyWith(
          selectedSection: HomeSection.restaurants,
          selectedRestaurant: restaurant,
        ),
      );
      return;
    }

    _emitSafely(
      state.copyWith(selectedRestaurant: restaurant),
    );
  }

  void openRestaurantDetailsById(int restaurantId) {
    // For now, we'll need to fetch the restaurant details
    // This is a placeholder - you might want to implement a method to fetch restaurant by ID
    // or navigate differently
    // For now, we'll just navigate to the restaurants section
    _emitSafely(
      state.copyWith(
        selectedSection: HomeSection.restaurants,
        // selectedRestaurant: fetchedRestaurant, // TODO: fetch restaurant by ID
      ),
    );
  }

  void openCategoryProductsById({
    required int restaurantId,
    required int categoryId,
    required String categoryName,
  }) {
    _emitSafely(
      state.copyWith(
        selectedCategoryId: categoryId,
        selectedCategoryName: categoryName,
        selectedRestaurantId: restaurantId,
      ),
    );
  }

  void closeCategoryProducts() {
    _emitSafely(
      state.copyWith(resetSelectedCategory: true),
    );
  }

  void openCreateSection() {
    _emitSafely(
      state.copyWith(
        isCreatingSection: true,
        resetSectionConfig: true,
      ),
    );
  }

  void closeCreateSection() {
    _emitSafely(
      state.copyWith(
        isCreatingSection: false,
        resetSectionConfig: true,
      ),
    );
  }

  void openSectionListing(DashboardSectionConfig config) {
    _emitSafely(
      state.copyWith(
        isCreatingSection: false,
        sectionConfig: config,
      ),
    );
  }

  void closeSectionListing() {
    _emitSafely(
      state.copyWith(
        isCreatingSection: true,
        resetSectionConfig: true,
      ),
    );
  }

  void toggleOn() {
    _emitSafely(state.copyWith(isOn: !state.isOn));
  }

  void toggleRestaurants() async {
    final newValue = !state.isRestaurantsEnabled;
    _emitSafely(state.copyWith(isRestaurantsEnabled: newValue));
    
    if (configCubit != null) {
      await configCubit!.toggleKillSwitch('restaurantKillSwitch', newValue);
    }
  }

  void toggleHomeProducers() async {
    final newValue = !state.isHomeProducersEnabled;
    _emitSafely(state.copyWith(isHomeProducersEnabled: newValue));
    
    if (configCubit != null) {
      await configCubit!.toggleKillSwitch('homeKillSwitch', newValue);
    }
  }

  void toggleNeama() async {
    final newValue = !state.isNeamaEnabled;
    _emitSafely(state.copyWith(isNeamaEnabled: newValue));
    
    if (configCubit != null) {
      await configCubit!.toggleKillSwitch('plessingKillSwitch', newValue);
    }
  }

  void _emitSafely(HomeNavState newState) {
    try {
      if (isClosed) {
        return;
      }
      emit(newState);
    } catch (_) {}
  }
}
