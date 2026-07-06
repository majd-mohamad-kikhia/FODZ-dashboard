import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodzdashbord/core/utils/appColors.dart';
import 'package:foodzdashbord/core/utils/constants.dart';
import 'package:foodzdashbord/features/money_management/data/cubit/config_cubit.dart';

class MoneyManagementScreen extends StatelessWidget {
  const MoneyManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ConfigCubit()..fetchConfig(),
      child: const _MoneyManagementView(),
    );
  }
}

class _MoneyManagementView extends StatelessWidget {
  const _MoneyManagementView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConfigCubit, ConfigState>(
      listener: (context, state) {
        if (state.status == ConfigStatus.saved) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage ?? 'تم حفظ التعديلات بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state.status == ConfigStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'حدث خطأ'),
              backgroundColor: AppColors.primaryRed,
            ),
          );
        }
      },
      child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              SizedBox(width: 16.rw),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'القسم المالي',
                      style: TextStyle(
                        fontSize: 16.rf,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: 6.rh),
                    Text(
                      'حدّث القيم الافتراضية لتسعير المسافات وتكلفة الكيلو الإضافي بسهولة من هنا.',
                      style: TextStyle(
                        fontSize: 12.rf,
                        color: AppColors.grey600,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 28.rh),
          BlocBuilder<ConfigCubit, ConfigState>(
            builder: (context, state) {
              if (state.status == ConfigStatus.loading) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.rh),
                    child: CircularProgressIndicator(color: AppColors.primaryRed),
                  ),
                );
              }

              final cubit = context.read<ConfigCubit>();
              return LayoutBuilder(
                builder: (context, constraints) {
                  final fieldWidth = constraints.maxWidth >= 900.rw ? (constraints.maxWidth - 36.rw) / 3 : constraints.maxWidth;
                  return Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 18.rw,
                    runSpacing: 18.rh,
                    children: [
                      _PricingField(
                        label: 'المسافة الافتراضية',
                        hint: 'مثال: 5 كم',
                        width: fieldWidth,
                        controller: cubit.baseKmController,
                      ),
                      _PricingField(
                        label: 'السعر للمسافة الافتراضية',
                        hint: 'مثال: 3000 ج',
                        width: fieldWidth,
                        controller: cubit.basePriceController,
                      ),
                      _PricingField(
                        label: 'السعر بعد المسافة الافتراضية',
                        hint: 'مثال: 500 ج لكل كم إضافي',
                        width: fieldWidth,
                        controller: cubit.afterBasePriceController,
                      ),
                      _PricingField(
                        label: 'رسوم ادارية',
                        hint: 'مثال: 1500 ج',
                        width: fieldWidth,
                        controller: cubit.systemFeesController,
                      ),
                      _PricingField(
                        label: 'نسبة رجل التوصيل',
                        hint: 'مثال: 15% من قيمة التوصيل',
                        width: fieldWidth,
                        controller: cubit.dManPercentageController,
                      ),
                      _PricingField(
                        label: 'رقم الحساب البنكي',
                        hint: 'مثال: 1234567890',
                        width: fieldWidth,
                        controller: cubit.bankNumberController,
                        keyboardType: TextInputType.text,
                      ),
                    ],
                  );
                },
              );
            },
          ),
          SizedBox(height: 24.rh),
          Container(
            padding: EdgeInsets.all(18.rw),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.rw),
              border: Border.all(color: AppColors.grey400),
            ),
            child: Text(
              'نصيحة: تأكد من استخدام نفس وحدة القياس لجميع القيم (كم) للحفاظ على دقة نظام التسعير لديك.',
              style: TextStyle(
                fontSize: 12.rf,
                color: AppColors.grey600,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          BlocBuilder<ConfigCubit, ConfigState>(
            builder: (context, state) {
              if (!state.hasChanges) return const SizedBox.shrink();
              final isLoading = state.status == ConfigStatus.saving;
              return Padding(
                padding: EdgeInsets.only(top: 24.rh),
                child: Center(
                  child: ElevatedButton.icon(
                    onPressed: isLoading ? null : () => context.read<ConfigCubit>().saveConfig(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryRed,
                      padding: EdgeInsets.symmetric(horizontal: 24.rw, vertical: 14.rh),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.rw)),
                    ),
                    icon: isLoading
                        ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.save_rounded, size: 18),
                    label: Text(
                      isLoading ? 'جاري الحفظ...' : 'حفظ التعديلات',
                      style: TextStyle(fontSize: 13.rf, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    )
    );
  }
}

class _PricingField extends StatelessWidget {
  const _PricingField({
    required this.label,
    required this.hint,
    required this.width,
    this.controller,
    this.keyboardType,
  });

  final String label;
  final String hint;
  final double width;
  final TextEditingController? controller;
  final TextInputType? keyboardType;

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14.rw),
      borderSide: BorderSide(color: color, width: 1.1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Container(
        padding: EdgeInsets.all(16.rw),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.rw),
          border: Border.all(color: AppColors.grey200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13.rf,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            SizedBox(height: 10.rh),
            TextField(
              controller: controller,
              textDirection: TextDirection.rtl,
              keyboardType: keyboardType ?? TextInputType.number,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(fontSize: 12.rf, color: AppColors.grey500),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(horizontal: 14.rw, vertical: 12.rh),
                border: _border(AppColors.grey200),
                enabledBorder: _border(AppColors.grey400),
                focusedBorder: _border(AppColors.primaryRed),
              ),
            ),
          ],
        ),
      ),
    );
  }
}