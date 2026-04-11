

import 'package:flutter/material.dart';
import 'package:foodzdashbord/core/utils/appColors.dart';

class PaymentStatusBadge extends StatelessWidget {
  const PaymentStatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case 'مدفوع':
        color = Colors.green;
        break;
      case 'غير مدفوع':
        color = AppColors.secondaryRed;
        break;
      case 'بالانتظار':
        color = AppColors.accentOrange;
        break;
      default:
        color = AppColors.grey500;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  const StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    String display;
    Color color;
    switch (status) {
      case 'unpaid':
        display = 'لم يتم الدفع';
        color = AppColors.secondaryRed;
        break;
      case 'pending':
        display = 'في الإنتظار';
        color = AppColors.accentOrange;
        break;
      case 'accepted':
        display = 'تم القبول';
        color = AppColors.infoBlue;
        break;
      case 'completed':
        display = 'بانتظار المندوب';
        color = AppColors.infoBlue;
        break;
      case 'shipping':
        display = 'قيد التوصيل';
        color = AppColors.accentOrange;
        break;
      case 'shipped':
        display = 'مكتملة';
        color = Colors.green;
        break;
      case 'denied':
        display = 'تم الرفض';
        color = AppColors.secondaryRed;
        break;
      case 'cancelled':
        display = 'تم الإلغاء';
        color = AppColors.secondaryRed;
        break;
      default:
        display = status;
        color = AppColors.grey500;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        display,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

