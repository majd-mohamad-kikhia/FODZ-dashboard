
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodzdashbord/core/utils/appColors.dart';
import 'package:foodzdashbord/features/home_ads/data/models/home_ad_model.dart';
import 'package:foodzdashbord/features/home_ads/presentation/cubit/home_ads_cubit.dart';

void showDeleteConfirmation(BuildContext context, HomeAdModel ad) {
  showDialog(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('تأكيد الحذف'),
      content: Text('هل أنت متأكد من حذف إعلان "${ad.restaurant.name}"؟'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: () async {
            Navigator.pop(dialogContext);
            final success = await context.read<HomeAdsCubit>().deleteHomeAd(ad.id);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(success ? 'تم حذف الإعلان بنجاح' : 'فشل حذف الإعلان'),
                  backgroundColor: success ? Colors.green : Colors.red,
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
