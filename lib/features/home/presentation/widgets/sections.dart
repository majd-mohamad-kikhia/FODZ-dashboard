import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodzdashbord/core/api/network_service.dart';
import 'package:foodzdashbord/core/utils/appColors.dart';
import 'package:foodzdashbord/core/utils/constants.dart';
import 'package:foodzdashbord/core/widgets/buil_widgets.dart';
import 'package:foodzdashbord/features/category_sections/data/api/category_sections_client.dart';
import 'package:foodzdashbord/features/category_sections/presentation/cubit/category_sections_cubit.dart';
import 'package:foodzdashbord/features/home/cubit/home_nav_cubit.dart';
import 'package:foodzdashbord/features/home/presentation/widgets/section_listing_grid.dart';
import 'package:foodzdashbord/features/product_sections/data/api/product_sections_client.dart';
import 'package:foodzdashbord/features/product_sections/presentation/cubit/product_sections_cubit.dart';
import 'package:foodzdashbord/features/restaurant_sections/data/api/restaurant_sections_client.dart';
import 'package:foodzdashbord/features/restaurant_sections/presentation/cubit/restaurant_sections_cubit.dart';
import 'package:foodzdashbord/features/sections/data/api/sections_client.dart';
import 'package:foodzdashbord/features/sections/data/models/section_response.dart';
import 'package:foodzdashbord/features/sections/presentation/cubit/section_selection_cubit.dart';
import 'package:foodzdashbord/features/sections/presentation/cubit/sections_cubit.dart';

class SectionListingView extends StatefulWidget {
  const SectionListingView({required this.config});

  final DashboardSectionConfig config;

  @override
  State<SectionListingView> createState() => _SectionListingViewState();
}

class _SectionListingViewState extends State<SectionListingView> {
  late final TextEditingController _nameController;
  late final SectionSelectionCubit _selectionCubit;
  late final SectionsCubit _sectionsCubit;

  DashboardSectionConfig get config => widget.config;

  bool get _isEditMode => config.sectionId != null;

  String get _currentSectionName => _nameController.text.trim();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: config.sectionName)
      ..addListener(_onNameChanged);
    _selectionCubit = SectionSelectionCubit();
    if (config.existingIds != null && config.existingIds!.isNotEmpty) {
      _selectionCubit.selectAll(config.existingIds!);
    }
    _sectionsCubit = SectionsCubit(SectionsClient(NetworkServices()));

    // Trigger initial fetch based on content type
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      switch (config.contentType) {
        case DashboardContentType.restaurants:
          final restaurantSectionType =
              SectionTypeConverter.fromDashboardScreen(config.screen);
          context.read<RestaurantSectionsCubit>().fetchRestaurants(
            sectionType: restaurantSectionType,
          );
          break;
        case DashboardContentType.categories:
          final categorySectionType =
              CategorySectionTypeConverter.fromDashboardScreen(config.screen);
          context.read<CategorySectionsCubit>().fetchCategories(
            sectionType: categorySectionType,
          );
          break;
        case DashboardContentType.products:
          final productSectionType =
              ProductSectionTypeConverter.fromDashboardScreen(config.screen);
          context.read<ProductSectionsCubit>().fetchProducts(
            sectionType: productSectionType,
          );
          break;
      }
    });
  }

  void _onNameChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _nameController
      ..removeListener(_onNameChanged)
      ..dispose();
    _selectionCubit.close();
    _sectionsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _selectionCubit),
        BlocProvider.value(value: _sectionsCubit),
      ],
      child: BlocBuilder<SectionSelectionCubit, SectionSelectionState>(
        builder: (context, selectionState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () =>
                          context.read<HomeNavCubit>().closeSectionListing(),
                      child: Container(
                        width: 40.rw,
                        height: 40.rw,
                        decoration: BoxDecoration(
                          color: AppColors.grey200.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_rounded,
                          color: AppColors.textDark,
                          size: 18.rf,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 14.rw),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: 'اسم القسم',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: AppColors.grey200),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColors.primaryRed,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 4.rh),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.rw,
                                vertical: 4.rh,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryRed.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                config.screen.title,
                                style: TextStyle(
                                  fontSize: 11.rf,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryRed,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.rw),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.rw,
                                vertical: 4.rh,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.infoBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                config.contentType.title,
                                style: TextStyle(
                                  fontSize: 11.rf,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.infoBlue,
                                ),
                              ),
                            ),
                            if (selectionState.selectedIds.isNotEmpty) ...[
                              SizedBox(width: 8.rw),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.rw,
                                  vertical: 4.rh,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.successGreen.withOpacity(
                                    0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'محدد: ${selectionState.selectedIds.length}',
                                  style: TextStyle(
                                    fontSize: 11.rf,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.successGreen,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.rh),
              Container(
                width: double.infinity,
                padding: responsiveInsetsAll(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.grey200),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44.rw,
                      height: 44.rw,
                      decoration: BoxDecoration(
                        color: AppColors.primaryRed.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.primaryRed.withOpacity(0.15),
                        ),
                      ),
                      child: Icon(
                        config.contentType.icon,
                        color: AppColors.primaryRed,
                        size: 18.rf,
                      ),
                    ),
                    SizedBox(width: 14.rw),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'اختر ${config.contentType.title} لإضافتها للقسم',
                            style: TextStyle(
                              fontSize: 14.rf,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                          ),
                          SizedBox(height: 4.rh),
                          Text(
                            'اضغط على العناصر لتحديدها',
                            style: TextStyle(
                              fontSize: 11.rf,
                              color: AppColors.grey600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.rh),
              Expanded(child: SectionListingGrid(config: config)),
              if (selectionState.selectedIds.isNotEmpty)
                BlocConsumer<SectionsCubit, SectionsState>(
                  listener: (context, state) {
                    if (state.createErrorMessage != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.createErrorMessage!),
                          backgroundColor: AppColors.primaryRed,
                        ),
                      );
                    }
                  },
                  builder: (context, sectionsState) {
                    return Container(
                      padding: EdgeInsets.all(16.rw),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, -2),
                          ),
                        ],
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              sectionsState.isCreating ||
                                  sectionsState.isUpdating
                              ? null
                              : () => _isEditMode
                                    ? _updateSection(context)
                                    : _createSection(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryRed,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 14.rh),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child:
                              sectionsState.isCreating ||
                                  sectionsState.isUpdating
                              ? SizedBox(
                                  height: 20.rh,
                                  width: 20.rw,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  _isEditMode
                                      ? 'تحديث القسم (${selectionState.selectedIds.length})'
                                      : 'إنشاء القسم (${selectionState.selectedIds.length})',
                                  style: TextStyle(
                                    fontSize: 14.rf,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _createSection(BuildContext context) async {
    final selectionCubit = context.read<SectionSelectionCubit>();
    final sectionsCubit = context.read<SectionsCubit>();
    final homeNavCubit = context.read<HomeNavCubit>();

    String screenValue;
    switch (config.screen) {
      case DashboardScreen.restaurants:
        screenValue = 'res';
        break;
      case DashboardScreen.homeProducers:
        screenValue = 'fam';
        break;
      case DashboardScreen.neama:
        screenValue = 'pless';
        break;
    }

    String typeValue;
    switch (config.contentType) {
      case DashboardContentType.restaurants:
        typeValue = 'restaurant';
        break;
      case DashboardContentType.categories:
        typeValue = 'cat';
        break;
      case DashboardContentType.products:
        typeValue = 'product';
        break;
    }

    final success = await sectionsCubit.createSection(
      screen: screenValue,
      type: typeValue,
      name: _currentSectionName,
      ids: selectionCubit.state.selectedIds.toList(),
    );

    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم إنشاء القسم بنجاح'),
          backgroundColor: AppColors.successGreen,
        ),
      );
      homeNavCubit.closeSectionListing();
      homeNavCubit.closeCreateSection();
    }
  }

  Future<void> _updateSection(BuildContext context) async {
    final selectionCubit = context.read<SectionSelectionCubit>();
    final sectionsCubit = context.read<SectionsCubit>();
    final homeNavCubit = context.read<HomeNavCubit>();

    String screenValue;
    switch (config.screen) {
      case DashboardScreen.restaurants:
        screenValue = 'res';
        break;
      case DashboardScreen.homeProducers:
        screenValue = 'fam';
        break;
      case DashboardScreen.neama:
        screenValue = 'pless';
        break;
    }

    String typeValue;
    switch (config.contentType) {
      case DashboardContentType.restaurants:
        typeValue = 'restaurant';
        break;
      case DashboardContentType.categories:
        typeValue = 'cat';
        break;
      case DashboardContentType.products:
        typeValue = 'product';
        break;
    }

    final success = await sectionsCubit.updateSection(
      sectionId: config.sectionId!,
      screen: screenValue,
      type: typeValue,
      name: _currentSectionName,
      ids: selectionCubit.state.selectedIds.toList(),
    );

    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم تحديث القسم بنجاح'),
          backgroundColor: AppColors.successGreen,
        ),
      );

      // Refresh the appropriate section cubit based on content type
      switch (config.contentType) {
        case DashboardContentType.restaurants:
          final restaurantSectionType =
              SectionTypeConverter.fromDashboardScreen(config.screen);
          context.read<RestaurantSectionsCubit>().refresh(
            restaurantSectionType,
          );
          break;
        case DashboardContentType.categories:
          final categorySectionType =
              CategorySectionTypeConverter.fromDashboardScreen(config.screen);
          context.read<CategorySectionsCubit>().refresh(categorySectionType);
          break;
        case DashboardContentType.products:
          final productSectionType =
              ProductSectionTypeConverter.fromDashboardScreen(config.screen);
          context.read<ProductSectionsCubit>().refresh(productSectionType);
          break;
      }

      homeNavCubit.closeSectionListing();
      homeNavCubit.closeCreateSection();
    }
  }
}

class SectionsGrid extends StatelessWidget {
  const SectionsGrid();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          SectionsCubit(SectionsClient(NetworkServices()))..fetchSections(),
      child: BlocBuilder<SectionsCubit, SectionsState>(
        builder: (context, state) {
          if (state.isLoading && state.sections.isEmpty) {
            return buildShimmerLoadingSections();
          }

          if (state.errorMessage != null && state.sections.isEmpty) {
            return buildErrorStateSections(context, state.errorMessage!);
          }

          if (state.sections.isEmpty) {
            return buildEmptyStateSections();
          }

          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.grey200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'الأقسام',
                      style: TextStyle(
                        fontSize: 16.rf,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.rw,
                        vertical: 6.rh,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryRed.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${state.sections.length} قسم',
                        style: TextStyle(
                          fontSize: 12.rf,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryRed,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.rh),
                Text(
                  'إدارة الأقسام التي ستظهر في الصفحة الرئيسية. يمكن تعديل أو حذف كل قسم لاحقاً.',
                  style: TextStyle(
                    fontSize: 12.rf,
                    height: 1.6,
                    color: AppColors.grey600,
                  ),
                ),
                SizedBox(height: 20.rh),
                ...state.sections
                    .map((section) => _SectionCard(section: section))
                    .toList(),
              ],
            ),
          );
        },
      ),
    );
  }

}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.section});

  final Section section;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.rh),
      padding: EdgeInsets.all(16.rw),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        children: [
          Container(
            width: 48.rw,
            height: 48.rw,
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
            ),
            child: Icon(
              Icons.dashboard_customize_rounded,
              color: AppColors.primaryRed,
              size: 20.rf,
            ),
          ),
          SizedBox(width: 16.rw),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.name,
                  style: TextStyle(
                    fontSize: 14.rf,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: 4.rh),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _openEditSection(context, section),
            icon: Icon(Icons.edit_outlined, size: 20.rf),
            color: AppColors.infoBlue,
            tooltip: 'تعديل',
          ),
          IconButton(
            onPressed: () => _showDeleteConfirmation(context, section),
            icon: Icon(Icons.delete_outline, size: 20.rf),
            color: AppColors.primaryRed,
            tooltip: 'حذف',
          ),
        ],
      ),
    );
  }

  void _openEditSection(BuildContext context, Section section) {
    final homeNavCubit = context.read<HomeNavCubit>();

    DashboardScreen screen;
    switch (section.screen) {
      case 'res':
        screen = DashboardScreen.restaurants;
        break;
      case 'fam':
        screen = DashboardScreen.homeProducers;
        break;
      case 'pless':
        screen = DashboardScreen.neama;
        break;
      default:
        screen = DashboardScreen.restaurants;
    }

    DashboardContentType contentType;
    switch (section.type) {
      case 'restaurant':
        contentType = DashboardContentType.restaurants;
        break;
      case 'cat':
        contentType = DashboardContentType.categories;
        break;
      case 'product':
        contentType = DashboardContentType.products;
        break;
      default:
        contentType = DashboardContentType.restaurants;
    }

    final List<int> existingIds;
    switch (section.type) {
      case 'restaurant':
        existingIds = section.items
            .map((item) => item.restaurantId)
            .whereType<int>()
            .toList();
        break;
      case 'cat':
        existingIds = section.items
            .map((item) => item.categoryId)
            .whereType<int>()
            .toList();
        break;
      case 'product':
        existingIds = section.items
            .map((item) => item.productId)
            .whereType<int>()
            .toList();
        break;
      default:
        existingIds = [];
    }

    homeNavCubit.openSectionListing(
      DashboardSectionConfig(
        sectionName: section.name,
        screen: screen,
        contentType: contentType,
        sectionId: section.id,
        existingIds: existingIds,
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, dynamic section) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف القسم "${section.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              final success = await context.read<SectionsCubit>().deleteSection(
                sectionId: section.id,
              );
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم حذف القسم بنجاح'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (context.mounted) {
                final errorMessage = context
                    .read<SectionsCubit>()
                    .state
                    .deleteErrorMessage;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(errorMessage ?? 'فشل حذف القسم'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
            ),
            child: const Text('حذف', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

