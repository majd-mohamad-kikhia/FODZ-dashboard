import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodzdashbord/core/api/network_service.dart';
import 'package:foodzdashbord/core/utils/appColors.dart';
import 'package:foodzdashbord/core/utils/constants.dart';
import 'package:foodzdashbord/features/home/cubit/home_nav_cubit.dart';
import 'package:foodzdashbord/features/home/presentation/widgets/category_product_content.dart';
import 'package:foodzdashbord/features/home/presentation/widgets/create_section_view_content.dart';
import 'package:foodzdashbord/features/home/presentation/widgets/home_ad.dart';
import 'package:foodzdashbord/features/home/presentation/widgets/sections.dart';
import 'package:foodzdashbord/features/restaurants/presentation/screens/restaurants_screen.dart';
import 'package:foodzdashbord/features/restaurants/presentation/cubit/restaurants_cubit.dart';
import 'package:foodzdashbord/features/orders/presentation/screens/orders_screen.dart';
import 'package:foodzdashbord/features/couriers/presentation/screens/couriers_screen.dart';
import 'package:foodzdashbord/features/blacklist/presentation/screens/blacklist_screen.dart';
import 'package:foodzdashbord/features/restaurant_details/presentation/screens/restaurant_details_screen.dart';
import 'package:foodzdashbord/features/money_management/presentation/money_management_screen.dart';
import 'package:foodzdashbord/features/money_management/data/cubit/config_cubit.dart';
import 'package:foodzdashbord/features/category_sections/presentation/cubit/category_sections_cubit.dart';
import 'package:foodzdashbord/features/category_sections/data/api/category_sections_client.dart';
import 'package:foodzdashbord/features/restaurant_sections/presentation/cubit/restaurant_sections_cubit.dart';
import 'package:foodzdashbord/features/restaurant_sections/data/api/restaurant_sections_client.dart';
import 'package:foodzdashbord/features/product_sections/presentation/cubit/product_sections_cubit.dart';
import 'package:foodzdashbord/features/product_sections/data/api/product_sections_client.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ConfigCubit()..fetchConfig()),
          BlocProvider(
            create: (context) =>
                HomeNavCubit(configCubit: context.read<ConfigCubit>()),
          ),
          BlocProvider(create: (_) => RestaurantsCubit()),
          BlocProvider(
            create: (_) => CategorySectionsCubit(
              CategorySectionsClient(NetworkServices()),
            ),
          ),
          BlocProvider(
            create: (_) => RestaurantSectionsCubit(
              RestaurantSectionsClient(NetworkServices()),
            ),
          ),
          BlocProvider(
            create: (_) =>
                ProductSectionsCubit(ProductSectionsClient(NetworkServices())),
          ),
        ],
        child: const _HomeView(),
      ),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConfigCubit, ConfigState>(
      listener: (context, configState) {
        if (configState.status == ConfigStatus.loaded ||
            configState.status == ConfigStatus.saved) {
          context.read<HomeNavCubit>().syncWithConfig(configState);
        }
        if (configState.status == ConfigStatus.error &&
            configState.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(configState.errorMessage!),
              backgroundColor: AppColors.primaryRed,
            ),
          );
        }
      },
      child: BlocBuilder<HomeNavCubit, HomeNavState>(
        buildWhen: (previous, current) =>
            previous.selectedSection != current.selectedSection ||
            previous.selectedRestaurant != current.selectedRestaurant,
        builder: (context, state) {
          return BlocBuilder<ConfigCubit, ConfigState>(
            builder: (context, configState) {
              final isLoading = configState.status == ConfigStatus.saving;

              return Stack(
                children: [
                  Scaffold(
                    backgroundColor: AppColors.background,
                    body: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _SideNavigation(),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 24,
                            ),
                            child: const _ContentArea(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isLoading)
                    Container(
                      color: Colors.black.withOpacity(0.3),
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.all(24.rw),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primaryRed,
                                ),
                              ),
                              SizedBox(height: 16.rh),
                              Text(
                                'جاري التحديث...',
                                style: TextStyle(
                                  fontSize: 16.rf,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _SideNavigation extends StatelessWidget {
  const _SideNavigation();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400.rw,
      height: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 211, 211).withOpacity(0.2),
        border: Border(left: BorderSide(color: AppColors.grey200, width: 1)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 50.rw, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            50.vSpace,
            BlocBuilder<HomeNavCubit, HomeNavState>(
              builder: (context, state) {
                final sections = HomeSection.values;
                return Column(
                  children: [
                    for (int index = 0; index < sections.length; index++) ...[
                      if (index != 0) SizedBox(height: 50.rh),
                      _SideNavButton(
                        section: sections[index],
                        isActive: state.selectedSection == sections[index],
                        onTap: () =>
                            context.read<HomeNavCubit>().selectSection(sections[index]),
                      ),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SideNavButton extends StatelessWidget {
  const _SideNavButton({
    required this.section,
    required this.isActive,
    required this.onTap,
  });

  final HomeSection section;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primaryRed.withOpacity(0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              section.icon,
              color: isActive ? AppColors.primaryRed : AppColors.grey500,
              size: 18.rf,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                section.title,
                style: TextStyle(
                  fontSize: 13.rf,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive ? AppColors.textDark : AppColors.grey600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContentArea extends StatelessWidget {
  const _ContentArea();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeNavCubit, HomeNavState>(
      buildWhen: (previous, current) =>
          previous.selectedSection != current.selectedSection ||
          previous.selectedRestaurant != current.selectedRestaurant ||
          previous.selectedCategoryId != current.selectedCategoryId ||
          previous.isCreatingSection != current.isCreatingSection ||
          previous.sectionConfig != current.sectionConfig,
      builder: (context, state) {
        switch (state.selectedSection) {
          case HomeSection.dashboardHome:
            if (state.sectionConfig != null) {
              return SectionListingView(config: state.sectionConfig!);
            }
            if (state.isCreatingSection) {
              return const _CreateSectionView();
            }
            return const _DashboardHomeContent();
          case HomeSection.restaurants:
            if (state.selectedCategoryId != null &&
                state.selectedRestaurantId != null) {
              return CategoryProductsContent(
                restaurantId: state.selectedRestaurantId!,
                categoryId: state.selectedCategoryId!,
                categoryName: state.selectedCategoryName ?? 'المنتجات',
              );
            }
            if (state.selectedRestaurant != null) {
              return RestaurantDetailsScreen(
                restaurant: state.selectedRestaurant!,
              );
            }
            return const _RestaurantsContent();
          case HomeSection.orders:
            return const _OrdersContent();
          case HomeSection.couriers:
            return const _CouriersContent();
          case HomeSection.finance:
            return const _FinanceContent();
          case HomeSection.blacklist:
            return const _BlacklistContent();
          case HomeSection.homeAds:
            return const HomeAdsContent();
        }
      },
    );
  }
}

class _RestaurantsContent extends StatelessWidget {
  const _RestaurantsContent();

  @override
  Widget build(BuildContext context) {
    return const RestaurantsScreen();
  }
}

class _OrdersContent extends StatelessWidget {
  const _OrdersContent();

  @override
  Widget build(BuildContext context) {
    return const OrdersScreen();
  }
}

class _CouriersContent extends StatelessWidget {
  const _CouriersContent();

  @override
  Widget build(BuildContext context) {
    return const CouriersScreen();
  }
}

class _FinanceContent extends StatelessWidget {
  const _FinanceContent();

  @override
  Widget build(BuildContext context) {
    return const MoneyManagementScreen();
  }
}

class _DashboardHomeContent extends StatelessWidget {
  const _DashboardHomeContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الصفحة الرئيسية',
            style: TextStyle(
              fontSize: 20.rf,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          SizedBox(height: 24.rh),
          const _ToggleButtonsWidget(),
          SizedBox(height: 24.rh),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.grey200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 80.rw,
                  height: 80.rw,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryRed.withOpacity(0.15),
                        AppColors.secondaryRed.withOpacity(0.08),
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primaryRed.withOpacity(0.15),
                    ),
                  ),
                  child: Icon(
                    Icons.dashboard_customize_rounded,
                    color: AppColors.primaryRed,
                    size: 24.rf,
                  ),
                ),
                SizedBox(height: 20.rh),
                Text(
                  'إدارة أقسام الصفحة الرئيسية',
                  style: TextStyle(
                    fontSize: 18.rf,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: 10.rh),
                Text(
                  'قم بإنشاء أقسام مخصصة واختر المحتوى الذي سيظهر في كل قسم\n(مطاعم، فئات، أو منتجات)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.rf,
                    height: 1.6,
                    color: AppColors.grey600,
                  ),
                ),
                SizedBox(height: 24.rh),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () =>
                        context.read<HomeNavCubit>().openCreateSection(),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 32.rw,
                        vertical: 14.rh,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primaryRed,
                            AppColors.secondaryRed,
                          ],
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryRed.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add_rounded,
                            color: Colors.white,
                            size: 22.rf,
                          ),
                          SizedBox(width: 10.rw),
                          Text(
                            'إنشاء قسم جديد',
                            style: TextStyle(
                              fontSize: 14.rf,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.rh),
          const SectionsGrid(),
        ],
      ),
    );
  }
}

class _ToggleButtonsWidget extends StatelessWidget {
  const _ToggleButtonsWidget();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeNavCubit, HomeNavState>(
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: _SwitchButton(
                label: 'المطاعم',
                isEnabled: state.isRestaurantsEnabled,
                onChanged: (value) => _showConfirmationDialog(
                  context,
                  'المطاعم',
                  value,
                  () => context.read<HomeNavCubit>().toggleRestaurants(),
                ),
              ),
            ),
            SizedBox(width: 16.rw),
            Expanded(
              child: _SwitchButton(
                label: 'الاسر المنتجة',
                isEnabled: state.isHomeProducersEnabled,
                onChanged: (value) => _showConfirmationDialog(
                  context,
                  'الاسر المنتجة',
                  value,
                  () => context.read<HomeNavCubit>().toggleHomeProducers(),
                ),
              ),
            ),
            SizedBox(width: 16.rw),
            Expanded(
              child: _SwitchButton(
                label: 'النعمة',
                isEnabled: state.isNeamaEnabled,
                onChanged: (value) => _showConfirmationDialog(
                  context,
                  'النعمة',
                  value,
                  () => context.read<HomeNavCubit>().toggleNeama(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationDialog(
    BuildContext context,
    String sectionName,
    bool newValue,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          'تأكيد التغيير',
          style: TextStyle(
            fontSize: 18.rf,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        content: Text(
          'هل أنت متأكد من ${newValue ? 'تفعيل' : 'إلغاء تفعيل'} قسم $sectionName؟',
          style: TextStyle(fontSize: 14.rf, color: AppColors.grey600),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'إلغاء',
              style: TextStyle(fontSize: 14.rf, color: AppColors.grey600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'تأكيد',
              style: TextStyle(fontSize: 14.rf, fontWeight: FontWeight.w600),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
      ),
    );
  }
}

class _SwitchButton extends StatelessWidget {
  const _SwitchButton({
    required this.label,
    required this.isEnabled,
    required this.onChanged,
  });

  final String label;
  final bool isEnabled;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.rw, vertical: 12.rh),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.rf,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: onChanged,
            activeColor: AppColors.primaryRed,
            activeTrackColor: AppColors.primaryRed.withOpacity(0.3),
          ),
        ],
      ),
    );
  }
}
class _BlacklistContent extends StatelessWidget {
  const _BlacklistContent();

  @override
  Widget build(BuildContext context) {
    return const BlacklistScreen();
  }
}

class _CreateSectionView extends StatelessWidget {
  const _CreateSectionView();

  @override
  Widget build(BuildContext context) {
    return CreateSectionViewContent();
  }
}