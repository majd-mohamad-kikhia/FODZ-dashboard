import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodzdashbord/core/utils/appColors.dart';
import 'package:foodzdashbord/features/couriers/presentation/cubit/couriers_cubit.dart';
import 'package:foodzdashbord/features/couriers/presentation/cubit/pending_delivery_man_cubit.dart';
import 'package:foodzdashbord/features/couriers/data/models/pending_delivery_man_model.dart';
import 'package:foodzdashbord/features/couriers/presentation/screens/delivery_man_details_screen.dart';
import 'package:foodzdashbord/features/couriers/presentation/screens/delivery_man_list_screen.dart';
import 'dart:html' as html;

class CouriersScreen extends StatelessWidget {
  const CouriersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CouriersCubit()),
        BlocProvider(create: (_) => PendingDeliveryManCubit()..fetchPendingDeliveryMen()),
      ],
      child: const _CouriersView(),
    );
  }
}

class _CouriersView extends StatelessWidget {
  const _CouriersView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CouriersCubit, CouriersState>(
      buildWhen: (previous, current) => previous.selectedCourier != current.selectedCourier,
      builder: (context, state) {
        if (state.selectedCourier != null) {
          return DeliveryManDetailsScreen(
            courier: state.selectedCourier!,
            onBack: () => context.read<CouriersCubit>().clearSelectedCourier(),
          );
        }
        return const _CouriersTabsView();
      },
    );
  }
}

class _CouriersTabsView extends StatelessWidget {
  const _CouriersTabsView();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.grey200),
            ),
            child: TabBar(
              labelColor: AppColors.primaryRed,
              unselectedLabelColor: AppColors.grey600,
              indicatorColor: AppColors.primaryRed,
              indicatorWeight: 3,
              labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              unselectedLabelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              tabs: const [
                Tab(text: 'المندوبين النشطين'),
                Tab(text: 'طلبات الانضمام'),
              ],
            ),
          ),
          SizedBox(height: 24),
          Expanded(
            child: TabBarView(
              children: [
                const _ActiveCouriersTab(),
                const _PendingCouriersTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveCouriersTab extends StatelessWidget {
  const _ActiveCouriersTab();

  @override
  Widget build(BuildContext context) {
    return const DeliveryManListScreen();
  }
}

class _PendingCouriersTab extends StatelessWidget {
  const _PendingCouriersTab();

  @override
  Widget build(BuildContext context) {
    return BlocListener<PendingDeliveryManCubit, PendingDeliveryManState>(
      listener: (context, state) {
        if (state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.successMessage!),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: AppColors.primaryRed,
            ),
          );
        }
      },
      child: BlocBuilder<PendingDeliveryManCubit, PendingDeliveryManState>(
        builder: (context, state) {
          if (state.status == PendingDeliveryManStatus.loading) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primaryRed),
            );
          }

          if (state.deliveryMen.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.pending_actions, size: 48, color: AppColors.grey400),
                  SizedBox(height: 16),
                  Text(
                    'لا توجد طلبات انضمام',
                    style: TextStyle(fontSize: 16, color: AppColors.grey600),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.1,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
            ),
            itemCount: state.deliveryMen.length,
            itemBuilder: (context, index) {
              final deliveryMan = state.deliveryMen[index];
              return _PendingDeliveryManCard(deliveryMan: deliveryMan);
            },
          );
        },
      ),
    );
  }
}

class _PendingDeliveryManCard extends StatelessWidget {
  const _PendingDeliveryManCard({required this.deliveryMan});

  final PendingDeliveryMan deliveryMan;

  void _openPdf(BuildContext context, String pdfUrl) {
    try {
      html.window.open(pdfUrl, '_blank');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('فشل في فتح PDF'),
          backgroundColor: Colors.red,
        ),
      );
    }
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.accentOrange.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person,
              size: 35,
              color: AppColors.accentOrange,
            ),
          ),
          SizedBox(height: 12),
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
          SizedBox(height: 4),
          Text(
            deliveryMan.phoneNumber,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.grey600,
            ),
          ),
          SizedBox(height: 4),
          Text(
            deliveryMan.emailAddress,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.grey500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 12),
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
          SizedBox(height: 8),
          BlocBuilder<PendingDeliveryManCubit, PendingDeliveryManState>(
            builder: (context, state) {
              final isApproving = state.status == PendingDeliveryManStatus.approving;
              return ElevatedButton(
                onPressed: isApproving
                    ? null
                    : () => context.read<PendingDeliveryManCubit>().approveDeliveryMan(deliveryMan.id),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: isApproving
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        'قبول الطلب',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
              );
            },
          ),
        ],
      ),
    );
  }
}
