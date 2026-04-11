
// Restaurant Section
import 'package:flutter/material.dart';
import 'package:foodzdashbord/core/utils/appColors.dart';
import 'package:foodzdashbord/core/utils/constants.dart';
import 'package:foodzdashbord/features/orders/data/models/order_customer_model.dart';
import 'package:foodzdashbord/features/orders/data/models/order_model.dart';
import 'package:foodzdashbord/features/orders/data/models/order_restaurant_model.dart';
import 'package:foodzdashbord/features/orders/presentation/widgets/badgs.dart';
class ModernDetailSection extends StatelessWidget {
  const ModernDetailSection({
    required this.title,
    required this.icon,
    required this.order,
  });

  final String title;
  final IconData icon;
  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.primaryRed, size: 20),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.rf,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.grey200,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.grey200),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: GridField(
                      label: 'رقم الطلب',
                      value: '#${order.id}',
                    ),
                  ),
                  SizedBox(width: 32),
                  Expanded(
                    child: GridField(
                      label: 'حالة الطلب',
                      valueWidget: StatusBadge(status: order.statusArabic),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: GridField(
                      label: 'حالة الدفع',
                      valueWidget: PaymentStatusBadge(status: order.paymentStatusArabic),
                    ),
                  ),
                  SizedBox(width: 32),
                  Expanded(
                    child: GridField(
                      label: 'المبلغ الإجمالي',
                      value: '${order.totalPrice.toStringAsFixed(2)} ج',
                      valueColor: AppColors.primaryRed,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class RestaurantSection extends StatelessWidget {
  const RestaurantSection({required this.restaurant});

  final OrderRestaurantModel restaurant;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.storefront_rounded, color: AppColors.primaryRed, size: 20),
            SizedBox(width: 8),
            Text(
              'معلومات المطعم',
              style: TextStyle(
                fontSize: 16.rf,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.grey200,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.grey200),
          ),
          child: Row(
            children: [
              Expanded(
                child: GridField(
                  label: 'اسم المطعم',
                  valueWidget: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: AppColors.accentOrange.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.lunch_dining_rounded,
                          size: 16,
                          color: AppColors.accentOrange,
                        ),
                      ),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          restaurant.name,
                          style: TextStyle(
                            fontSize: 14.rf,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 32),
              Expanded(
                child: GridField(
                  label: 'رقم المطعم',
                  value: '#${restaurant.id}',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Customer Section
class CustomerSection extends StatelessWidget {
  const CustomerSection({required this.customer});

  final OrderCustomerModel customer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.person_outline_rounded, color: AppColors.primaryRed, size: 20),
            SizedBox(width: 8),
            Text(
              'معلومات العميل',
              style: TextStyle(
                fontSize: 16.rf,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
        SizedBox(height: 16), 
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.grey200),
          ),
          child: Column(
            children: [
              _CustomerRow(
                label: 'اسم العميل',
                value: customer.name,
              ),
              Divider(height: 24, color: AppColors.grey200),
              _CustomerRow(
                label: 'رقم الهاتف',
                value: customer.phoneNumber,
              ),
              Divider(height: 24, color: AppColors.grey200),
              _CustomerRow(
                label: 'رقم العميل',
                value: '#${customer.id}',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Grid Field Widget
class GridField extends StatelessWidget {
  const GridField({
    required this.label,
    this.value,
    this.valueWidget,
    this.valueColor,
  });

  final String label;
  final String? value;
  final Widget? valueWidget;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.rf,
            fontWeight: FontWeight.w500,
            color: AppColors.grey500,
          ),
        ),
        SizedBox(height: 6),
        valueWidget ??
            Text(
              value ?? '',
              style: TextStyle(
                fontSize: 14.rf,
                fontWeight: FontWeight.w700,
                color: valueColor ?? AppColors.textDark,
              ),
              textDirection: TextDirection.ltr,
            ),
      ],
    );
  }
}

// Customer Row Widget
class _CustomerRow extends StatelessWidget {
  const _CustomerRow({
    required this.label,
    this.value,
  });

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.rf,
            fontWeight: FontWeight.w500,
            color: AppColors.grey500,
          ),
        ),
        Text(
          value ?? '',
          style: TextStyle(
            fontSize: 14.rf,
            fontWeight: FontWeight.w500,
            color: AppColors.textDark,
          ),
          textDirection: TextDirection.ltr,
        ),
      ],
    );
  }
}


  void showDetailsDialog(BuildContext context, OrderModel order) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            width: 650.rw,
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(bottom: BorderSide(color: AppColors.grey200)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primaryRed.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.receipt_long_rounded,
                          color: AppColors.primaryRed,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'تفاصيل الطلب ',
                                  style: TextStyle(
                                    fontSize: 20.rf,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textDark,
                                  ),
                                ),
                                SizedBox(
                                  width: 120,
                                  child: Text(
                                    '#${order.id}',
                                    style: TextStyle(
                                      fontSize: 16.rf,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryRed,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ), 
                              ],
                            ),
                            SizedBox(height: 2),
                            Text(
                              'عرض تفاصيل الطلب الكاملة',
                              style: TextStyle(
                                fontSize: 13.rf,
                                color: AppColors.grey500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close_rounded, color: AppColors.grey600),
                        onPressed: () => Navigator.pop(context),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                ),
                // Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ModernDetailSection(
                          title: 'معلومات الطلب',
                          icon: Icons.info_outline_rounded,
                          order: order,
                        ),
                        SizedBox(height: 32),
                        RestaurantSection(restaurant: order.restaurant),
                        SizedBox(height: 32),
                        CustomerSection(customer: order.customer),
                      ],
                    ),
                  ),
                ),
                // Footer
                Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    border: Border(top: BorderSide(color: AppColors.grey200)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryRed,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          elevation: 2,
                          shadowColor: AppColors.primaryRed.withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'إغلاق',
                          style: TextStyle(
                            fontSize: 14.rf,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
