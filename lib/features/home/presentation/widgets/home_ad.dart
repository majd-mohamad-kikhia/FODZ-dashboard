
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodzdashbord/core/utils/appColors.dart';
import 'package:foodzdashbord/core/utils/constants.dart';
import 'package:foodzdashbord/core/utils/delete_confirmation.dart';
import 'package:foodzdashbord/core/widgets/app_cached_image.dart';
import 'package:foodzdashbord/core/widgets/buil_widgets.dart';
import 'package:foodzdashbord/features/home_ads/data/models/home_ad_model.dart';
import 'package:foodzdashbord/features/home_ads/presentation/cubit/home_ads_cubit.dart';
import 'package:foodzdashbord/features/home_ads/presentation/screens/create_ad_screen.dart';

class HomeAdCard extends StatelessWidget {
  const HomeAdCard({required this.ad});

  final HomeAdModel ad;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(22),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: ad.photoUrl != null && ad.photoUrl!.isNotEmpty
                      ? AppCachedImage(
                          imageUrl: ad.photoUrl!,
                          fit: BoxFit.cover,
                          errorWidget: (context) => Container(
                            color: AppColors.grey200,
                            child: Icon(Icons.image, size: 40.rf, color: AppColors.grey400),
                          ),
                        )
                      : Container(
                          color: AppColors.grey200,
                          child: Icon(Icons.image, size: 40.rf, color: AppColors.grey400),
                        ),
                ),
                Positioned(
                  top: 8.rh,
                  left: 8.rw,
                  child: IconButton(
                    icon: Icon(Icons.delete, color: Colors.white, size: 20.rf),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.red.withOpacity(0.8),
                      padding: EdgeInsets.all(8.rw),
                    ),
                    onPressed: () => showDeleteConfirmation(context, ad),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.rw),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ad.restaurant.name,
                  style: TextStyle(
                    fontSize: 14.rf,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.rh),
                Text(
                  'ID: ${ad.id}',
                  style: TextStyle(
                    fontSize: 12.rf,
                    color: AppColors.grey600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HomeAdsContent extends StatelessWidget {
  const HomeAdsContent();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeAdsCubit(),
      child: Padding(
        padding: EdgeInsets.all(24.rw),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            SizedBox(height: 24.rh),
            Expanded(child: const _HomeAdsGrid()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'إعلانات الرئيسية',
          style: TextStyle(
            fontSize: 24.rf,
            fontWeight: FontWeight.w700,
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
              if (created == true && context.mounted) {
                context.read<HomeAdsCubit>().fetchHomeAds();
              }
            });
          },
          icon: Icon(Icons.add, size: 20.rf),
          label: Text(
            'إضافة إعلان جديد',
            style: TextStyle(fontSize: 14.rf),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryRed,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: 16.rw,
              vertical: 12.rh,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
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
          return buildAdErrorState(context, state.errorMessage ?? 'حدث خطأ');
        }

        if (state.homeAds.isEmpty) {
          return buildAdEmptyState();
        }

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.rw,
            mainAxisSpacing: 16.rh,
            childAspectRatio: 1.5,
          ),
          itemCount: state.homeAds.length,
          itemBuilder: (context, index) {
            final ad = state.homeAds[index];
            return HomeAdCard(ad: ad);
          },
        );
      },
    );
  }
}