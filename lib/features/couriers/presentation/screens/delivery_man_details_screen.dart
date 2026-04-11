import 'package:flutter/material.dart';
import 'package:foodzdashbord/core/utils/appColors.dart';
import 'package:foodzdashbord/core/utils/constants.dart';
import 'package:foodzdashbord/features/couriers/presentation/cubit/couriers_cubit.dart';

class DeliveryManDetailsScreen extends StatelessWidget {
  const DeliveryManDetailsScreen({super.key, required this.courier, this.onBack});

  final CourierModel courier;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 32.rh),
        child: Padding(
          padding: responsiveInsetsSymmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.rw),
                    decoration: BoxDecoration(
                      color: AppColors.primaryRed.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16.rw),
                    ),
                    child: Icon(Icons.delivery_dining, color: AppColors.primaryRed, size: 24.rf),
                  ),
                  12.hSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'تفاصيل المندوب',
                          style: TextStyle(
                            fontSize: 20.rf,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                          ),
                        ),
                        4.vSpace,
                        Text(
                          courier.name,
                          style: TextStyle(
                            fontSize: 14.rf,
                            color: AppColors.grey500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (onBack != null)
                    IconButton(
                      onPressed: onBack,
                      icon: const Icon(Icons.close_rounded, color: AppColors.grey500),
                    ),
                ],
              ),
              24.vSpace,
              _HeroPanel(courier: courier),
              24.vSpace,
              _InfoDetailsCard(courier: courier),
              24.vSpace,
              const _TransactionsSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({required this.courier});

  final CourierModel courier;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.rw, vertical: 24.rh),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25.rw),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10.rw,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: _QuickFactsRow(courier: courier),
    );
  }
}

class _QuickFactsRow extends StatelessWidget {
  const _QuickFactsRow({required this.courier});

  final CourierModel courier;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12.rw,
          runSpacing: 12.rh,
          children: [
            _StatusChip(
              label: courier.isWorking ? 'متصل' : 'غير متصل',
              color: courier.isWorking ? Colors.green : AppColors.grey400,
            ),
            _StatusChip(
              label: 'المعرف #${courier.id}',
              color: AppColors.infoBlue,
            ),
          ],
        ),
        16.vSpace,
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoItem(label: 'اسم المندوب', value: courier.name),
                  12.vSpace,
                  _InfoItem(label: 'رقم الهاتف', value: courier.phoneNumber),
                  12.vSpace,
                  _InfoItem(label: 'البريد الإلكتروني', value: courier.email ?? 'غير متوفر'),
                ],
              ),
            ),
            12.hSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoItem(label: 'تاريخ الانضمام', value: courier.joinedDate ?? 'غير محدد'),
                  12.vSpace,
                  _InfoItem(label: 'عدد الطلبات المكتملة', value: '${courier.completedOrders} طلب'),
                  12.vSpace,
                  _InfoItem(label: 'المدينة', value: courier.city ?? 'غير محدد'),
                ],
              ),
            ),
            12.hSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoItem(label: 'نوع المركبة', value: courier.vehicleType ?? 'غير محدد'),
                  12.vSpace,
                  _InfoItem(
                    label: 'حالة العمل',
                    value: courier.isWorking ? 'يعمل حاليًا' : 'غير متاح',
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoDetailsCard extends StatelessWidget {
  const _InfoDetailsCard({required this.courier});

  final CourierModel courier;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.rw),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.rw),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'تفاصيل إضافية',
            style: TextStyle(
              fontSize: 16.rf,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          16.vSpace,
          Row(
            children: [
              Expanded(
                child: _DetailTile(
                  icon: Icons.calendar_month,
                  label: 'تاريخ الانضمام',
                  value: courier.joinedDate ?? 'غير محدد',
                ),
              ),
              16.hSpace,
              Expanded(
                child: _DetailTile(
                  icon: Icons.check_circle_outline,
                  label: 'الطلبات المكتملة',
                  value: '${courier.completedOrders}',
                ),
              ),
              16.hSpace,
              Expanded(
                child: _DetailTile(
                  icon: Icons.motorcycle,
                  label: 'نوع المركبة',
                  value: courier.vehicleType ?? 'غير محدد',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailTile extends StatelessWidget {
  const _DetailTile({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.rw),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.rw),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        children: [
          Container(
            width: 36.rw,
            height: 36.rh,
            decoration: BoxDecoration(
              color: AppColors.primaryRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.rw),
            ),
            child: Icon(icon, color: AppColors.primaryRed, size: 18.rf),
          ),
          12.hSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.rf,
                    color: AppColors.grey500,
                  ),
                ),
                4.vSpace,
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.rf,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
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


class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.rw, vertical: 8.rh),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          8.hSpace,
          Text(
            label,
            style: TextStyle(
              fontSize: 12.rf,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({required this.label, required this.value});

  final String label;
  final String value;

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
        6.vSpace,
        Text(
          value,
          style: TextStyle(
            fontSize: 14.rf,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }
}

class _TransactionsSection extends StatelessWidget {
  const _TransactionsSection();

  static const _mockData = [
    _TransactionRowModel('#9845', '125,000 ج', 'طلب #32', '2024-08-18', 'مدفوع'),
    _TransactionRowModel('#9844', '75,000 ج', 'طلب #31', '2024-08-17', 'معلّق'),
    _TransactionRowModel('#9843', '210,000 ج', 'طلب #30', '2024-08-16', 'مدفوع'),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final widths = _TransactionColumns(constraints.maxWidth);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.account_balance_wallet_outlined, color: AppColors.primaryRed),
                8.hSpace,
                Text(
                  'سجل المعاملات',
                  style: TextStyle(
                    fontSize: 18.rf,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
            16.vSpace,
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.grey200),
              ),
              child: Column(
                children: [
                  _TransactionsHeader(widths: widths),
                  Divider(height: 1, color: AppColors.grey200),
                  ..._mockData.map(
                    (row) => _TransactionRow(model: row, widths: widths),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _TransactionColumns {
  factory _TransactionColumns(double maxWidth) {
    final usable = maxWidth - 40;
    final width = usable > 0 ? usable : maxWidth;
    return _TransactionColumns._(
      id: width * 0.15,
      amount: width * 0.2,
      order: width * 0.2,
      date: width * 0.2,
      status: width * 0.15,
    );
  }

  const _TransactionColumns._({
    required this.id,
    required this.amount,
    required this.order,
    required this.date,
    required this.status,
  });

  final double id;
  final double amount;
  final double order;
  final double date;
  final double status;
}

class _TransactionsHeader extends StatelessWidget {
  const _TransactionsHeader({required this.widths});

  final _TransactionColumns widths;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        children: [
          _TransactionsHeaderCell(text: 'رقم العملية', width: widths.id),
          _TransactionsHeaderCell(text: 'المبلغ', width: widths.amount),
          _TransactionsHeaderCell(text: 'الطلب', width: widths.order),
          _TransactionsHeaderCell(text: 'التاريخ', width: widths.date),
          _TransactionsHeaderCell(text: 'الحالة', width: widths.status),
        ],
      ),
    );
  }
}

class _TransactionsHeaderCell extends StatelessWidget {
  const _TransactionsHeaderCell({required this.text, required this.width});

  final String text;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 13.rf,
          fontWeight: FontWeight.w700,
          color: AppColors.textDark,
        ),
      ),
    );
  }
}

class _TransactionsBodyCell extends StatelessWidget {
  const _TransactionsBodyCell({required this.width, required this.child});

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

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({required this.model, required this.widths});

  final _TransactionRowModel model;
  final _TransactionColumns widths;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          _TransactionsBodyCell(
            width: widths.id,
            child: Text(
              model.id,
              style: TextStyle(fontSize: 13.rf, fontWeight: FontWeight.w600, color: AppColors.grey700),
            ),
          ),
          _TransactionsBodyCell(
            width: widths.amount,
            child: Text(
              model.amount,
              style: TextStyle(fontSize: 13.rf, fontWeight: FontWeight.w600, color: AppColors.textDark),
            ),
          ),
          _TransactionsBodyCell(
            width: widths.order,
            child: Text(
              model.orderId,
              style: TextStyle(fontSize: 13.rf, color: AppColors.textDark),
            ),
          ),
          _TransactionsBodyCell(
            width: widths.date,
            child: Text(
              model.date,
              style: TextStyle(fontSize: 13.rf, color: AppColors.grey600),
            ),
          ),
          SizedBox(
            width: widths.status,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: model.status == 'مدفوع'
                      ? Colors.green.withOpacity(0.1)
                      : AppColors.accentOrange.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  model.status,
                  style: TextStyle(
                    fontSize: 12.rf,
                    fontWeight: FontWeight.w700,
                    color: model.status == 'مدفوع' ? Colors.green : AppColors.accentOrange,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionRowModel {
  const _TransactionRowModel(this.id, this.amount, this.orderId, this.date, this.status);

  final String id;
  final String amount;
  final String orderId;
  final String date;
  final String status;
}
