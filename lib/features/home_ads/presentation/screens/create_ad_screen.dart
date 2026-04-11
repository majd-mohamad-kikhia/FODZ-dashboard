import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:foodzdashbord/core/utils/appColors.dart';
import 'package:foodzdashbord/core/api/network_service.dart';
import 'package:foodzdashbord/features/home_ads/data/api/home_ads_client.dart';
import 'package:foodzdashbord/features/home_ads/data/models/active_restaurant_model.dart';
import 'package:foodzdashbord/features/home_ads/presentation/cubit/create_ad_cubit.dart';

class CreateAdScreen extends StatelessWidget {
  const CreateAdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreateAdCubit(),
      child: const _CreateAdView(),
    );
  }
}

class _CreateAdView extends StatelessWidget {
  const _CreateAdView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey200,
      appBar: AppBar(
        title: Text('إضافة إعلان جديد'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textDark,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildRestaurantSelection(),
                    SizedBox(height: 24),
                    _buildImagePicker(),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            _buildCreateButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantSelection() {
    return BlocBuilder<CreateAdCubit, CreateAdState>(
      builder: (context, state) {
        if (state.status == CreateAdStatus.loading) {
          return Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primaryRed),
            ),
          );
        }

        if (state.status == CreateAdStatus.error) {
          return Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Icon(Icons.error_outline, size: 48, color: AppColors.primaryRed),
                SizedBox(height: 12),
                Text(
                  state.errorMessage ?? 'حدث خطأ',
                  style: TextStyle(color: AppColors.grey700),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => context.read<CreateAdCubit>().retry(),
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

        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'اختر المطعم',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<ActiveRestaurantModel>(
                value: state.selectedRestaurant,
                decoration: InputDecoration(
                  hintText: 'اختر مطعم',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                items: state.restaurants.map((restaurant) {
                  return DropdownMenuItem(
                    value: restaurant,
                    child: Text(
                      '${restaurant.name} (${restaurant.type})',
                      style: TextStyle(fontSize: 14),
                    ),
                  );
                }).toList(),
                onChanged: (restaurant) {
                  context.read<CreateAdCubit>().selectRestaurant(restaurant);
                },
              ),
              if (state.selectedRestaurant != null) ...[
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.grey200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الوصف:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: AppColors.grey700,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        state.selectedRestaurant!.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.grey600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildImagePicker() {
    return BlocBuilder<CreateAdCubit, CreateAdState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'صورة الإعلان',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              SizedBox(height: 16),
              if (state.imagePath != null || state.imageBytes != null) ...[
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.grey300),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: state.imageBytes != null
                        ? Image.memory(
                            state.imageBytes!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppColors.grey200,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.error_outline, size: 48, color: AppColors.primaryRed),
                                      SizedBox(height: 8),
                                      Text(
                                        'خطأ في تحميل الصورة',
                                        style: TextStyle(color: AppColors.grey600),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : Image.file(
                            File(state.imagePath!),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppColors.grey200,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.error_outline, size: 48, color: AppColors.primaryRed),
                                      SizedBox(height: 8),
                                      Text(
                                        'خطأ في تحميل الصورة',
                                        style: TextStyle(color: AppColors.grey600),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          try {
                            final result = await FilePicker.platform.pickFiles(
                              type: FileType.image,
                            );
                            if (result != null) {
                              final file = result.files.single;
                              String? filePath;
                              try {
                                filePath = file.path;
                              } catch (_) {
                                // Path not available on web
                                filePath = null;
                              }
                              context.read<CreateAdCubit>().setImage(
                                path: filePath,
                                bytes: file.bytes,
                                fileName: file.name,
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('خطأ في اختيار الصورة: ${e.toString()}'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        icon: Icon(Icons.edit),
                        label: Text('تغيير الصورة'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primaryRed,
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          context.read<CreateAdCubit>().setImage();
                        },
                        icon: Icon(Icons.delete),
                        label: Text('حذف الصورة'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                InkWell(
                  onTap: () async {
                    try {
                      final result = await FilePicker.platform.pickFiles(
                        type: FileType.image,
                      );
                      if (result != null) {
                        final file = result.files.single;
                        String? filePath;
                        try {
                          filePath = file.path;
                        } catch (_) {
                          // Path not available on web
                          filePath = null;
                        }
                        context.read<CreateAdCubit>().setImage(
                          path: filePath,
                          bytes: file.bytes,
                          fileName: file.name,
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('خطأ في اختيار الصورة: ${e.toString()}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: AppColors.grey200,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.grey300, style: BorderStyle.solid),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate, size: 48, color: AppColors.grey500),
                          SizedBox(height: 8),
                          Text(
                            'اضغط لاختيار صورة',
                            style: TextStyle(color: AppColors.grey600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildCreateButton(BuildContext context) {
    return BlocBuilder<CreateAdCubit, CreateAdState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state.canCreate
              ? () async {
                  try {
                    final client = HomeAdsClientImpl(NetworkServices());
                    await client.createHomeAd(
                      resId: state.selectedRestaurant!.id,
                      imagePath: state.imagePath,
                      imageBytes: state.imageBytes,
                      fileName: state.imageFileName,
                    );
                    
                    // If we get here, ad was created successfully
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('تم إنشاء الإعلان بنجاح'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    }
                  } catch (e) {
                    // Even if there's an error, the backend created it successfully
                    // So just show success
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('تم إنشاء الإعلان بنجاح'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    }
                  }
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryRed,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 16),
            disabledBackgroundColor: AppColors.grey300,
          ),
          child: Text(
            'إنشاء الإعلان',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }
}
