import 'package:flutter/material.dart';
import 'package:foodzdashbord/core/utils/appColors.dart';
import 'package:foodzdashbord/core/utils/constants.dart';
import 'package:foodzdashbord/core/utils/format_price.dart';
import 'package:foodzdashbord/features/category_sections/data/models/category_details_response.dart';

class ProductCardItem extends StatelessWidget {
  const ProductCardItem({required this.product});

  final CategoryProduct product;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.rh),
      padding: EdgeInsets.all(16.rw),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          if (product.photoURL != null)
            Container(
              width: 60.rw,
              height: 60.rw,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(product.photoURL!),
                  fit: BoxFit.cover,
                ),
              ),
            )
          else
            Container(
              width: 60.rw,
              height: 60.rw,
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
                border: Border.all(
                  color: AppColors.primaryRed.withOpacity(0.14),
                ),
              ),
              child: Icon(
                Icons.shopping_bag_rounded,
                color: AppColors.primaryRed,
                size: 20.rf,
              ),
            ),
          SizedBox(width: 12.rw),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                    fontSize: 14.rf,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.rh),
                Text(
                  'ID: ${product.id}',
                  style: TextStyle(
                    fontSize: 10.rf,
                    color: AppColors.grey500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2.rh),
                Text(
                  product.description,
                  style: TextStyle(fontSize: 12.rf, color: AppColors.grey600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 12.rw),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.rw, vertical: 8.rh),
            decoration: BoxDecoration(
              color: AppColors.primaryRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '${formatPrice(product.salePrice)} ج',
              style: TextStyle(
                fontSize: 13.rf,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryRed,
              ),
            ),
          ),
        ],
      ),
    );
  }
  }
