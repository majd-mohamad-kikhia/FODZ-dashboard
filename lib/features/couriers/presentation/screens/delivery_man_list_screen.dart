import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodzdashbord/core/utils/appColors.dart';
import 'package:foodzdashbord/features/couriers/presentation/cubit/delivery_man_cubit.dart';
import 'package:foodzdashbord/features/couriers/data/models/delivery_man_model.dart';
import 'dart:html' as html;

class DeliveryManListScreen extends StatelessWidget {
  const DeliveryManListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DeliveryManCubit()..initialize(),
      child: const _DeliveryManListView(),
    );
  }
}

class _DeliveryManListView extends StatelessWidget {
  const _DeliveryManListView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<DeliveryManCubit, DeliveryManState>(
      listenWhen: (previous, current) =>
          previous.actionMessage != current.actionMessage,
      listener: (context, state) {
        if (state.actionMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.actionMessage!),
              backgroundColor: state.actionStatus == DeliveryManActionStatus.success
                  ? Colors.green
                  : AppColors.primaryRed,
            ),
          );
        }
      },
      child: Column(
        children: [
          const _FilterTabs(),
          const SizedBox(height: 24),
          Expanded(child: const _DeliveryManList()),
        ],
      ),
    );
  }
}

class _FilterTabs extends StatelessWidget {
  const _FilterTabs();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeliveryManCubit, DeliveryManState>(
      buildWhen: (previous, current) =>
          previous.currentFilter != current.currentFilter,
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.grey200),
          ),
          child: Row(
            children: [
              Expanded(
                child: _FilterButton(
                  label: 'الكل',
                  isSelected: state.currentFilter == DeliveryManFilter.all,
                  onTap: () => context
                      .read<DeliveryManCubit>()
                      .changeFilter(DeliveryManFilter.all),
                ),
              ),
              Container(width: 1, height: 40, color: AppColors.grey200),
              Expanded(
                child: _FilterButton(
                  label: 'النشطين',
                  isSelected: state.currentFilter == DeliveryManFilter.active,
                  onTap: () => context
                      .read<DeliveryManCubit>()
                      .changeFilter(DeliveryManFilter.active),
                ),
              ),
              Container(width: 1, height: 40, color: AppColors.grey200),
              Expanded(
                child: _FilterButton(
                  label: 'المحظورين',
                  isSelected: state.currentFilter == DeliveryManFilter.banned,
                  onTap: () => context
                      .read<DeliveryManCubit>()
                      .changeFilter(DeliveryManFilter.banned),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryRed.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            color: isSelected ? AppColors.primaryRed : AppColors.grey600,
          ),
        ),
      ),
    );
  }
}

class _DeliveryManList extends StatelessWidget {
  const _DeliveryManList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DeliveryManCubit, DeliveryManState>(
      builder: (context, state) {
        if (state.status == DeliveryManStatus.loading && state.deliveryMen.isEmpty) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primaryRed),
          );
        }

        if (state.status == DeliveryManStatus.error && state.deliveryMen.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 48, color: AppColors.primaryRed),
                const SizedBox(height: 16),
                Text(
                  state.errorMessage ?? 'حدث خطأ',
                  style: TextStyle(fontSize: 16, color: AppColors.grey600),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<DeliveryManCubit>().fetchDeliveryMen(refresh: true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                  ),
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }

        if (state.filteredDeliveryMen.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.delivery_dining, size: 48, color: AppColors.grey400),
                const SizedBox(height: 16),
                Text(
                  'لا يوجد مندوبين',
                  style: TextStyle(fontSize: 16, color: AppColors.grey600),
                ),
              ],
            ),
          );
        }

        final cubit = context.read<DeliveryManCubit>();
        return RefreshIndicator(
          onRefresh: () => cubit.fetchDeliveryMen(refresh: true),
          color: AppColors.primaryRed,
          child: GridView.builder(
            controller: cubit.scrollController,
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.85,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemCount: state.filteredDeliveryMen.length + (state.isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == state.filteredDeliveryMen.length) {
                return Center(
                  child: CircularProgressIndicator(color: AppColors.primaryRed),
                );
              }
              final deliveryMan = state.filteredDeliveryMen[index];
              return _DeliveryManCard(deliveryMan: deliveryMan);
            },
          ),
        );
      },
    );
  }
}

class _DeliveryManCard extends StatelessWidget {
  const _DeliveryManCard({required this.deliveryMan});

  final DeliveryMan deliveryMan;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: deliveryMan.isActive ? AppColors.grey200 : AppColors.primaryRed.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: deliveryMan.isActive
                      ? AppColors.accentOrange.withOpacity(0.1)
                      : AppColors.grey300,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  size: 35,
                  color: deliveryMan.isActive ? AppColors.accentOrange : AppColors.grey600,
                ),
              ),
              if (!deliveryMan.isActive)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryRed,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.block,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            deliveryMan.name,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            deliveryMan.phoneNumber,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.grey600,
            ),
          ),
          if (deliveryMan.emailAddress != null) ...[
            const SizedBox(height: 4),
            Text(
              deliveryMan.emailAddress!,
              style: TextStyle(
                fontSize: 11,
                color: AppColors.grey500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 8),
          // PDF Links
          if ((deliveryMan.pdf1Url?.isNotEmpty ?? false) ||
              (deliveryMan.pdf2Url?.isNotEmpty ?? false) ||
              (deliveryMan.pdf3Url?.isNotEmpty ?? false))
            Column(
              children: [
                if (deliveryMan.pdf1Url?.isNotEmpty ?? false)
                  _buildPdfLink(context, 'PDF 1', deliveryMan.pdf1Url!),
                if (deliveryMan.pdf2Url?.isNotEmpty ?? false)
                  _buildPdfLink(context, 'PDF 2', deliveryMan.pdf2Url!),
                if (deliveryMan.pdf3Url?.isNotEmpty ?? false)
                  _buildPdfLink(context, 'PDF 3', deliveryMan.pdf3Url!),
              ],
            ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: deliveryMan.isActive
                  ? Colors.green.withOpacity(0.1)
                  : AppColors.primaryRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: deliveryMan.isActive
                    ? Colors.green.withOpacity(0.3)
                    : AppColors.primaryRed.withOpacity(0.3),
              ),
            ),
            child: Text(
              deliveryMan.isActive ? 'نشط' : 'محظور',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: deliveryMan.isActive ? Colors.green : AppColors.primaryRed,
              ),
            ),
          ),
          const SizedBox(height: 12),
          BlocBuilder<DeliveryManCubit, DeliveryManState>(
            builder: (context, state) {
              final isLoading = state.actionStatus == DeliveryManActionStatus.loading;
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isLoading
                      ? null
                      : () {
                          if (deliveryMan.isActive) {
                            context.read<DeliveryManCubit>().banDeliveryMan(deliveryMan.id);
                          } else {
                            context.read<DeliveryManCubit>().unbanDeliveryMan(deliveryMan.id);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: deliveryMan.isActive
                        ? AppColors.primaryRed
                        : Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Icon(
                          deliveryMan.isActive ? Icons.block : Icons.check_circle,
                          size: 16,
                          color: Colors.white,
                        ),
                  label: Text(
                    deliveryMan.isActive ? 'حظر' : 'إلغاء الحظر',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          BlocBuilder<DeliveryManCubit, DeliveryManState>(
            builder: (context, state) {
              final isLoading = state.actionStatus == DeliveryManActionStatus.loading;
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isLoading
                      ? null
                      : () => _showWarningDialog(context, deliveryMan.id, context.read<DeliveryManCubit>()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(
                          Icons.warning,
                          size: 16,
                          color: Colors.white,
                        ),
                  label: const Text(
                    'تحذير',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPdfLink(BuildContext context, String label, String pdfUrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => _openPdf(context, pdfUrl),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.blue, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.picture_as_pdf, size: 12, color: Colors.blue),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openPdf(BuildContext context, String pdfUrl) {
    // Open PDF in new tab for web applications
    try {
      html.window.open(pdfUrl, '_blank');
    } catch (e) {
      // Fallback: show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('فشل في فتح PDF'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showWarningDialog(BuildContext context, int deliveryManId, DeliveryManCubit cubit) {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('إرسال تحذير'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'العنوان'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: bodyController,
                    decoration: const InputDecoration(labelText: 'المحتوى'),
                    maxLines: 3,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('إلغاء'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final title = titleController.text.trim();
                    final body = bodyController.text.trim();
                    if (title.isEmpty || body.isEmpty) {
                      // Optionally show a snackbar for validation
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        const SnackBar(
                          content: Text('يرجى ملء جميع الحقول'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    // Call cubit
                    cubit.giveWarning(deliveryManId, title, body);
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('إرسال'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
