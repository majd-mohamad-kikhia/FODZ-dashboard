import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodzdashbord/core/utils/appColors.dart';
import 'package:foodzdashbord/features/orders/data/cubit/orders_cubit.dart';
import 'package:foodzdashbord/features/orders/data/models/order_model.dart';
import 'package:foodzdashbord/features/orders/presentation/widgets/badgs.dart';
import 'package:foodzdashbord/features/orders/presentation/widgets/order_details_diloge.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrdersCubit(),
      child: const _OrdersView(),
    );
  }

}
class _OrdersTableCell extends StatelessWidget {
  const _OrdersTableCell({required this.width, required this.child});

  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Center(child: child),
    );
  }
}

class _OrdersTableColumnWidths {
  factory _OrdersTableColumnWidths(double maxWidth) {
    final usable = maxWidth - (horizontalPadding * 2) - actionWidth;
    final baseWidth = usable > 0 ? usable : 0;

    return _OrdersTableColumnWidths._(
      restaurant: baseWidth * 0.16,
      customer: baseWidth * 0.17,
      phone: baseWidth * 0.16,
      totalPrice: baseWidth * 0.13,
      orderId: baseWidth * 0.10,
      status: baseWidth * 0.13,
      paymentStatus: baseWidth * 0.14,
    );
  }

  const _OrdersTableColumnWidths._({
    required this.restaurant,
    required this.customer,
    required this.phone,
    required this.totalPrice,
    required this.orderId,
    required this.status,
    required this.paymentStatus,
  });

  static const double horizontalPadding = 20;
  static const double actionWidth = 160;

  final double restaurant;
  final double customer;
  final double phone;
  final double totalPrice;
  final double orderId;
  final double status;
  final double paymentStatus;

  double get actions => actionWidth;
}

class _OrdersView extends StatelessWidget {
  const _OrdersView();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _SearchBar(),
        SizedBox(height: 24),
        Expanded(child: const _OrdersTable()),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OrdersCubit>();

    return BlocBuilder<OrdersCubit, OrdersState>(
      buildWhen: (previous, current) =>
          previous.searchTerm != current.searchTerm,
      builder: (context, state) {
        return TextField(
          controller: cubit.searchController,
          onChanged: cubit.updateSearch,
          textDirection: TextDirection.rtl,
          style: TextStyle(fontSize: 14, color: AppColors.textDark),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'ابحث عن طلب...',
            hintStyle: TextStyle(fontSize: 14, color: AppColors.grey400),
            prefixIcon: state.searchTerm.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      color: AppColors.grey600,
                      size: 20,
                    ),
                    onPressed: cubit.clearSearch,
                  )
                : null,
            suffixIcon: Icon(
              Icons.search_rounded,
              size: 20,
              color: AppColors.primaryRed,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.grey200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.grey200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primaryRed, width: 1.5),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        );
      },
    );
  }
}

class _OrdersTable extends StatelessWidget {
  const _OrdersTable();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersCubit, OrdersState>(
      builder: (context, state) {
        if (state.status == OrdersStatus.loading) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primaryRed),
          );
        }

        if (state.filteredOrders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long_rounded,
                  size: 48,
                  color: AppColors.grey400,
                ),
                SizedBox(height: 16),
                Text(
                  'لا توجد طلبات',
                  style: TextStyle(fontSize: 16, color: AppColors.grey600),
                ),
              ],
            ),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth = constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : MediaQuery.of(context).size.width;
            final widths = _OrdersTableColumnWidths(availableWidth);

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.grey200),
              ),
              child: Column(
                children: [
                  _TableHeader(widths: widths),
                  Divider(height: 1, color: AppColors.grey200),
                  Expanded(
                    child: ListView.separated(
                      itemCount: state.filteredOrders.length,
                      separatorBuilder: (_, __) =>
                          Divider(height: 1, color: AppColors.grey200),
                      itemBuilder: (context, index) {
                        final order = state.filteredOrders[index];
                        return _OrderRow(order: order, widths: widths);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader({required this.widths});

  final _OrdersTableColumnWidths widths;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _OrdersTableColumnWidths.horizontalPadding,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _HeaderCell(text: 'اسم المطعم', width: widths.restaurant),
          _HeaderCell(text: 'اسم العميل', width: widths.customer),
          _HeaderCell(text: 'رقم الهاتف', width: widths.phone),
          _HeaderCell(text: 'سعر الطلب الكامل', width: widths.totalPrice),
          _HeaderCell(text: 'ID الطلب', width: widths.orderId),
          _HeaderCell(text: 'حالة الطلب', width: widths.status),
          _HeaderCell(text: 'حالة الدفع', width: widths.paymentStatus),
          _OrdersTableCell(
            width: widths.actions,
            child: Text(
              'التفاصيل',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell({required this.text, required this.width});

  final String text;
  final double width;

  @override
  Widget build(BuildContext context) {
    return _OrdersTableCell(
      width: width,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.textDark,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _OrderRow extends StatelessWidget {
  const _OrderRow({required this.order, required this.widths});

  final OrderModel order;
  final _OrdersTableColumnWidths widths;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _OrdersTableColumnWidths.horizontalPadding,
        vertical: 12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _OrdersTableCell(
            width: widths.restaurant,
            child: Text(
              order.restaurant.name,
              style: TextStyle(fontSize: 13, color: AppColors.textDark),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _OrdersTableCell(
            width: widths.customer,
            child: Text(
              order.customer.name,
              style: TextStyle(fontSize: 13, color: AppColors.textDark),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _OrdersTableCell(
            width: widths.phone,
            child: Text(
              order.customer.phoneNumber,
              style: TextStyle(fontSize: 13, color: AppColors.textDark),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _OrdersTableCell(
            width: widths.totalPrice,
            child: Text(
              '${order.totalPrice.toStringAsFixed(2)} ج',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          _OrdersTableCell(
            width: widths.orderId,
            child: Text(
              '#${order.id}',
              style: TextStyle(fontSize: 13, color: AppColors.grey600),
              textAlign: TextAlign.center,
            ),
          ),
          _OrdersTableCell(
            width: widths.status,
            child: StatusBadge(status: order.statusArabic),
          ),
          _OrdersTableCell(
            width: widths.paymentStatus,
            child: PaymentStatusBadge(status: order.paymentStatusArabic),
          ),
          SizedBox(
            width: widths.actions,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.info_outline,
                    size: 20,
                    color: AppColors.infoBlue,
                  ),
                  onPressed: () => showDetailsDialog(context, order),
                  tooltip: 'التفاصيل',
                ),
              if (order.isCashPayment && !['shipped', 'denied', 'cancelled'].contains(order.status))
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8),
                    child: OutlinedButton(
                      onPressed: () => _showCancelConfirmation(context, order),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.secondaryRed,
                        side: BorderSide(color: AppColors.secondaryRed),
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        textStyle: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      child: const Text('إلغاء'),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCancelConfirmation(BuildContext context, OrderModel order) {
    final cubit = context.read<OrdersCubit>();
    final TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('تأكيد إلغاء الطلب'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('سيتم إلغاء الطلب رقم #${order.id} عند التأكيد.'),
              SizedBox(height: 16),
              TextField(
                controller: reasonController,
                decoration: InputDecoration(
                  labelText: 'سبب الإلغاء',
                  hintText: 'أدخل سبب إلغاء الطلب',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('رجوع'),
            ),
            ElevatedButton(
              onPressed: () {
                final reason = reasonController.text.trim();
                if (reason.isEmpty) {
                  // Show error if reason is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('يرجى إدخال سبب الإلغاء')),
                  );
                  return;
                }
                Navigator.of(ctx).pop();
                cubit.cancelOrder(order.id, reason);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryRed,
                foregroundColor: Colors.white,
              ),
              child: const Text('تأكيد'),
            ),
          ],
        ),
      ),
    );
  }
}