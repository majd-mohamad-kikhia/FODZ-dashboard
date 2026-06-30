import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodzdashbord/core/utils/appColors.dart';
import 'package:foodzdashbord/core/widgets/app_cached_image.dart';
import 'package:foodzdashbord/features/restaurants/presentation/cubit/pending_restaurants_cubit.dart';
import 'package:foodzdashbord/features/restaurants/data/models/pending_restaurant_model.dart';
import 'dart:html' as html;

class PendingRestaurantsGrid extends StatelessWidget {
  const PendingRestaurantsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PendingRestaurantsCubit, PendingRestaurantsState>(
      builder: (context, state) {
        if (state.status == PendingRestaurantsStatus.loading) {
          return Center(child: CircularProgressIndicator(color: AppColors.primaryRed));
        }

        if (state.status == PendingRestaurantsStatus.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: AppColors.primaryRed),
                SizedBox(height: 16),
                Text(
                  state.errorMessage,
                  style: TextStyle(fontSize: 16, color: AppColors.grey600),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<PendingRestaurantsCubit>().refresh();
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

        if (state.restaurants.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.pending_rounded, size: 48, color: AppColors.grey400),
                SizedBox(height: 16),
                Text(
                  'لا توجد مطاعم في الإنتظار',
                  style: TextStyle(fontSize: 16, color: AppColors.grey600),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.85,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemCount: state.restaurants.length,
          itemBuilder: (context, index) {
            final restaurant = state.restaurants[index];
            return _PendingRestaurantCard(restaurant: restaurant);
          },
        );
      },
    );
  }
}

class _PendingRestaurantCard extends StatefulWidget {
  const _PendingRestaurantCard({required this.restaurant});

  final PendingRestaurantModel restaurant;

  @override
  State<_PendingRestaurantCard> createState() => _PendingRestaurantCardState();
}

class _PendingRestaurantCardState extends State<_PendingRestaurantCard> {
  bool _isAccepting = false;
  bool _isDeclining = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
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
                    AppCachedImage(
                      imageUrl: widget.restaurant.displayCover,
                      fit: BoxFit.cover,
                      errorWidget: (context) => Container(
                        color: AppColors.grey200,
                        child: Icon(Icons.restaurant, size: 40, color: AppColors.grey400),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.accentOrange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'في الإنتظار',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        AppCachedImage(
                          imageUrl: widget.restaurant.displayPhoto,
                          width: 32,
                          height: 32,
                          fit: BoxFit.cover,
                          borderRadius: BorderRadius.circular(8),
                          errorWidget: (context) => Container(
                            width: 32,
                            height: 32,
                            color: AppColors.grey200,
                            child: Icon(Icons.restaurant, size: 16, color: AppColors.grey400),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.restaurant.name,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textDark,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 2),
                              Text(
                                '${widget.restaurant.type} • ${widget.restaurant.city ?? 'غير محدد'}${widget.restaurant.country != null ? ', ${widget.restaurant.country}' : ''}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.grey600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    if (widget.restaurant.pdfUrl != null && widget.restaurant.pdfUrl!.isNotEmpty ||
                        widget.restaurant.paymentReceiptUrl != null && widget.restaurant.paymentReceiptUrl!.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            if (widget.restaurant.pdfUrl != null && widget.restaurant.pdfUrl!.isNotEmpty)
                              Expanded(
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: () => _openUrl(widget.restaurant.pdfUrl!),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: Colors.blue, width: 1),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.picture_as_pdf, size: 14, color: Colors.blue),
                                          SizedBox(width: 4),
                                          Text(
                                            'عرض الملف',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            if (widget.restaurant.pdfUrl != null && widget.restaurant.pdfUrl!.isNotEmpty &&
                                widget.restaurant.paymentReceiptUrl != null && widget.restaurant.paymentReceiptUrl!.isNotEmpty)
                              SizedBox(width: 6),
                            if (widget.restaurant.paymentReceiptUrl != null && widget.restaurant.paymentReceiptUrl!.isNotEmpty)
                              Expanded(
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: () => _openUrl(widget.restaurant.paymentReceiptUrl!),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: Colors.green, width: 1),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            _isPdf(widget.restaurant.paymentReceiptUrl!)
                                                ? Icons.receipt_long
                                                : Icons.image_outlined,
                                            size: 14,
                                            color: Colors.green,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            'إيصال الدفع',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _isAccepting ? null : _acceptRestaurant,
                            icon: _isAccepting
                                ? SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Icon(Icons.check, size: 16),
                            label: Text(
                              _isAccepting ? 'جاري...' : 'قبول',
                              style: TextStyle(fontSize: 12),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryRed,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _isDeclining ? null : _declineRestaurant,
                            icon: _isDeclining
                                ? SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Icon(Icons.close, size: 16),
                            label: Text(
                              _isDeclining ? 'جاري...' : 'رفض',
                              style: TextStyle(fontSize: 12),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.grey500,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _acceptRestaurant() async {
    setState(() {
      _isAccepting = true;
    });

    try {
      final cubit = context.read<PendingRestaurantsCubit>();
      final success = await cubit.acceptRestaurant(widget.restaurant.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                ? 'تم قبول المطعم بنجاح'
                : 'فشل في قبول المطعم',
            ),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAccepting = false;
        });
      }
    }
  }

  Future<void> _declineRestaurant() async {
    setState(() {
      _isDeclining = true;
    });

    try {
      final cubit = context.read<PendingRestaurantsCubit>();
      final success = await cubit.declineRestaurant(widget.restaurant.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                ? 'تم رفض المطعم بنجاح'
                : 'فشل في رفض المطعم',
            ),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDeclining = false;
        });
      }
    }
  }

  bool _isPdf(String url) {
    final lower = url.toLowerCase();
    return lower.endsWith('.pdf') || lower.contains('.pdf?');
  }

  void _openUrl(String url) {
    try {
      html.window.open(url, '_blank');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('فشل في فتح الملف'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
