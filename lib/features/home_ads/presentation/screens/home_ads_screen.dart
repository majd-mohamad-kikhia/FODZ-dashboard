import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodzdashbord/core/utils/appColors.dart';
import 'package:foodzdashbord/core/widgets/app_cached_image.dart';
import 'package:foodzdashbord/features/home_ads/data/models/home_ad_model.dart';
import 'package:foodzdashbord/features/home_ads/presentation/cubit/home_ads_cubit.dart';
import 'package:foodzdashbord/features/home_ads/presentation/screens/create_ad_screen.dart';

class HomeAdsScreen extends StatelessWidget {
  const HomeAdsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeAdsCubit(),
      child: const _HomeAdsView(),
    );
  }
}

class _HomeAdsView extends StatelessWidget {
  const _HomeAdsView();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        const SizedBox(height: 20),
        Expanded(child: const _HomeAdsGrid()),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'إعلانات الصفحة الرئيسية',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const CreateAdScreen(),
              ),
            ).then((created) {
              if (created == true) {
                context.read<HomeAdsCubit>().fetchHomeAds();
              }
            });
          },
          icon: Icon(Icons.add),
          label: Text('إضافة إعلان جديد'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryRed,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
        ),
      ],
    );
  }
}

class _HomeAdsGrid extends StatelessWidget {
  const _HomeAdsGrid();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeAdsCubit, HomeAdsState>(
      builder: (context, state) {
        if (state.status == HomeAdsStatus.loading) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primaryRed),
          );
        }

        if (state.status == HomeAdsStatus.error) {
          return _buildErrorState(context, state.errorMessage ?? 'حدث خطأ');
        }

        if (state.homeAds.isEmpty) {
          return _buildEmptyState();
        }

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.5,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemCount: state.homeAds.length,
          itemBuilder: (context, index) {
            final ad = state.homeAds[index];
            return _HomeAdCard(ad: ad);
          },
        );
      },
    );
  }

  Widget _buildErrorState(BuildContext context, String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppColors.primaryRed),
          SizedBox(height: 16),
          Text(
            errorMessage,
            style: TextStyle(fontSize: 16, color: AppColors.grey700),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<HomeAdsCubit>().retry();
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
          Icon(Icons.ad_units, size: 64, color: AppColors.grey400),
          SizedBox(height: 16),
          Text(
            'لا توجد إعلانات',
            style: TextStyle(fontSize: 16, color: AppColors.grey600),
          ),
        ],
      ),
    );
  }
}

class _HomeAdCard extends StatelessWidget {
  const _HomeAdCard({required this.ad});

  final HomeAdModel ad;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ad.photoUrl != null && ad.photoUrl!.isNotEmpty
                      ? AppCachedImage(
                          imageUrl: ad.photoUrl!,
                          fit: BoxFit.cover,
                          errorWidget: (context) => Container(
                            color: AppColors.grey200,
                            child: Icon(Icons.image, size: 40, color: AppColors.grey400),
                          ),
                        )
                      : Container(
                          color: AppColors.grey200,
                          child: Icon(Icons.image, size: 40, color: AppColors.grey400),
                        ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: Icon(Icons.delete, color: Colors.white),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.red.withOpacity(0.8),
                      ),
                      onPressed: () {
                        _showDeleteDialog(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ad.restaurant.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'ID: ${ad.id}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.grey600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('حذف الإعلان'),
        content: Text('هل أنت متأكد من حذف هذا الإعلان؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('إلغاء'),
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
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('حذف'),
          ),
        ],
      ),
    );
  }
}
