
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodzdashbord/core/utils/appColors.dart';
import 'package:foodzdashbord/core/utils/constants.dart';
import 'package:foodzdashbord/features/home/cubit/home_nav_cubit.dart';
import 'package:foodzdashbord/features/home/presentation/widgets/content_type_card.dart';
import 'package:foodzdashbord/features/home/presentation/widgets/screen_card.dart';

class CreateSectionViewContent extends StatelessWidget {
  CreateSectionViewContent();

  final TextEditingController _sectionNameController = TextEditingController();
  final ValueNotifier<DashboardScreen> _selectedScreen = ValueNotifier(
    DashboardScreen.homeProducers,
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () =>
                      context.read<HomeNavCubit>().closeCreateSection(),
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
              Text(
                'إنشاء قسم جديد',
                style: TextStyle(
                  fontSize: 20.rf,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          SizedBox(height: 28.rh),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'اسم القسم',
                  style: TextStyle(
                    fontSize: 14.rf,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: 10.rh),
                TextField(
                  controller: _sectionNameController,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(fontSize: 14.rf, color: AppColors.textDark),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.surface,
                    hintText: 'أدخل اسم القسم...',
                    hintStyle: TextStyle(
                      fontSize: 14.rf,
                      color: AppColors.grey400,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: AppColors.grey200),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: AppColors.grey200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: AppColors.primaryRed,
                        width: 1.5,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 18.rw,
                      vertical: 14.rh,
                    ),
                  ),
                ),
                SizedBox(height: 28.rh),
                Text(
                  'اختر النوع',
                  style: TextStyle(
                    fontSize: 14.rf,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: 6.rh),
                Text(
                  'حدد نوع المحتوى الذي سيظهر في هذا القسم',
                  style: TextStyle(fontSize: 12.rf, color: AppColors.grey600),
                ),
                SizedBox(height: 14.rh),
                ValueListenableBuilder<DashboardScreen>(
                  valueListenable: _selectedScreen,
                  builder: (context, selectedType, _) {
                    final filteredScreens = DashboardScreen.values
                        .where((screen) => screen != DashboardScreen.neama)
                        .toList();
                    return Row(
                      children: filteredScreens.map((screen) {
                        final bool isActive = selectedType == screen;
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: screen == filteredScreens.last ? 0 : 12.rw,
                            ),
                            child: ScreenCard(
                              screen: screen,
                              isActive: isActive,
                              onTap: () => _selectedScreen.value = screen,
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
                SizedBox(height: 28.rh),
                Text(
                  'اختر المحتوى',
                  style: TextStyle(
                    fontSize: 14.rf,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: 6.rh),
                Text(
                  'اضغط على أحد الخيارات لفتح شاشة العرض',
                  style: TextStyle(fontSize: 12.rf, color: AppColors.grey600),
                ),
                SizedBox(height: 14.rh),
                ValueListenableBuilder<DashboardScreen>(
                  valueListenable: _selectedScreen,
                  builder: (context, selectedScreen, _) {
                    return Row(
                      children: DashboardContentType.values.map((contentType) {
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              left:
                                  contentType ==
                                      DashboardContentType.values.last
                                  ? 0
                                  : 12.rw,
                            ),
                            child: ContentTypeCard(
                              contentType: contentType,
                              onTap: () {
                                final sectionName = _sectionNameController.text
                                    .trim();
                                if (sectionName.isEmpty) {
                                  return;
                                }
                                context.read<HomeNavCubit>().openSectionListing(
                                  DashboardSectionConfig(
                                    sectionName: sectionName,
                                    screen: selectedScreen,
                                    contentType: contentType,
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
