import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodzdashbord/core/utils/appColors.dart';
import 'package:foodzdashbord/core/utils/constants.dart';
import 'package:foodzdashbord/features/blacklist/data/models/get_all_users_model.dart';
import 'package:foodzdashbord/features/blacklist/presentation/cubit/blacklist_cubit.dart';

class BlacklistScreen extends StatelessWidget {
  const BlacklistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BlacklistCubit(),
      child: const _BlacklistView(),
    );
  }
}

class _BlacklistTableCell extends StatelessWidget {
  const _BlacklistTableCell({required this.width, required this.child});

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

class _BlacklistTableColumnWidths {
  factory _BlacklistTableColumnWidths(double maxWidth, {required BlacklistTab tab}) {
    final usable = maxWidth - (horizontalPadding * 2) - actionsWidth;
    final baseWidth = usable > 0 ? usable : 0;

    if (tab == BlacklistTab.blocked) {
      // Blocked users: name, id, reason, actions
      return _BlacklistTableColumnWidths._(
        name: baseWidth * 0.31,
        id: baseWidth * 0.22,
        reason: baseWidth * 0.46,
        city: 0, // Not used
      );
    } else {
      // All users: name, id, city, actions
      return _BlacklistTableColumnWidths._(
        name: baseWidth * 0.31,
        id: baseWidth * 0.22,
        city: baseWidth * 0.46,
        reason: 0, // Not used
      );
    }
  }

  const _BlacklistTableColumnWidths._({
    required this.name,
    required this.id,
    required this.reason,
    required this.city,
  });

  static const double horizontalPadding = 20;
  static const double actionsWidth = 180;

  final double name;
  final double id;
  final double reason;
  final double city;

  double get actions => actionsWidth;
}

class _BlacklistView extends StatelessWidget {
  const _BlacklistView();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const _SearchBar(),
          SizedBox(height: 16),
          const _TabBar(),
          SizedBox(height: 8),
          Expanded(child: const _TabBarView()),
        ],
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BlacklistCubit>();

    return Container(
      color: Colors.white,
      child: TabBar(
        onTap: (index) {
          final tab = index == 0 ? BlacklistTab.blocked : BlacklistTab.users;
          cubit.changeTab(tab);
        },
        tabs: [
          Tab(text: 'المستخدمين المحظورين'),
          Tab(text: 'المستخدمين'),
        ],
        labelColor: AppColors.primaryRed,
        unselectedLabelColor: AppColors.grey600,
        indicatorColor: AppColors.primaryRed,
        labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 14),
      ),
    );
  }
}

class _TabBarView extends StatelessWidget {
  const _TabBarView();

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        const _BlacklistTable(tab: BlacklistTab.blocked),
        const _BlacklistTable(tab: BlacklistTab.users),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BlacklistCubit>();

    return BlocBuilder<BlacklistCubit, BlacklistState>(
      buildWhen: (previous, current) => previous.searchTerm != current.searchTerm,
      builder: (context, state) {
        return TextField(
          controller: cubit.searchController,
          onChanged: cubit.updateSearch,
          textDirection: TextDirection.rtl,
          style: TextStyle(fontSize: 14, color: AppColors.textDark),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'ابحث عن مستخدم محظور...',
            hintStyle: TextStyle(fontSize: 14, color: AppColors.grey400),
            prefixIcon: state.searchTerm.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.close_rounded, color: AppColors.grey600, size: 20),
                    onPressed: cubit.clearSearch,
                  )
                : null,
            suffixIcon: Icon(Icons.search_rounded, size: 20, color: AppColors.primaryRed),
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

class _BlacklistTable extends StatelessWidget {
  const _BlacklistTable({required this.tab});

  final BlacklistTab tab;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlacklistCubit, BlacklistState>(
      builder: (context, state) {
        if (state.status == BlacklistStatus.loading) {
          return Center(child: CircularProgressIndicator(color: AppColors.primaryRed));
        }

        final isBlockedTab = tab == BlacklistTab.blocked;
        final data = isBlockedTab ? state.filteredUsers : state.filteredAllUsers;

        if (data.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isBlockedTab ? Icons.block_rounded : Icons.people_rounded,
                  size: 38,
                  color: AppColors.grey400,
                ),
                SizedBox(height: 16),
                Text(
                  isBlockedTab
                      ? 'لا يوجد مستخدمين محظورين'
                      : 'لا يوجد مستخدمين',
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
            final widths = _BlacklistTableColumnWidths(availableWidth, tab: tab);

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.grey200),
              ),
              child: Column(
                children: [
                  _TableHeader(widths: widths, tab: tab),
                  Divider(height: 1, color: AppColors.grey200),
                  Expanded(
                    child: ListView.separated(
                      itemCount: data.length,
                      separatorBuilder: (_, __) =>
                          Divider(height: 1, color: AppColors.grey200),
                      itemBuilder: (context, index) {
                        return isBlockedTab
                            ? _BlockedUserRow(user: data[index] as BlacklistedUserModel, widths: widths)
                            : _UserRow(user: data[index] as UserModel, widths: widths);
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
  const _TableHeader({required this.widths, required this.tab});

  final _BlacklistTableColumnWidths widths;
  final BlacklistTab tab;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _BlacklistTableColumnWidths.horizontalPadding,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        children: [
          _HeaderCell(text: 'اسم المستخدم', width: widths.name),
          _HeaderCell(text: 'ID المستخدم', width: widths.id),
          if (tab == BlacklistTab.blocked)
            _HeaderCell(text: 'سبب الحظر', width: widths.reason)
          else
            _HeaderCell(text: 'المدينة', width: widths.city),
          _BlacklistTableCell(
            width: widths.actions,
            child: Text(
              'الإجراءات',
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
    return _BlacklistTableCell(
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

class _BlockedUserRow extends StatelessWidget {
  const _BlockedUserRow({required this.user, required this.widths});

  final BlacklistedUserModel user;
  final _BlacklistTableColumnWidths widths;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BlacklistCubit>();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _BlacklistTableColumnWidths.horizontalPadding,
        vertical: 14,
      ),
      child: Row(
        children: [
          _BlacklistTableCell(
            width: widths.name,
            child: Text(
              user.name,
              style: TextStyle(fontSize: 13, color: AppColors.textDark),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _BlacklistTableCell(
            width: widths.id,
            child: Text(
              user.id.toString(),
              style: TextStyle(fontSize: 13, color: AppColors.grey600),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _BlacklistTableCell(
            width: widths.reason,
            child: Text(
              user.banReason,
              style: TextStyle(fontSize: 13, color: AppColors.textDark),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _BlacklistTableCell(
            width: widths.actions,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.info_outline, size: 20, color: AppColors.infoBlue),
                  onPressed: () => _showDetailsDialog(context, user),
                  tooltip: 'التفاصيل',
                ),
                SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => _showUnbanDialog(context, user, cubit),
                  icon: Icon(Icons.check_circle_outline, size: 16),
                  label: Text('رفع الحظر'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDetailsDialog(BuildContext context, BlacklistedUserModel user) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text('تفاصيل المستخدم المحظور'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('الاسم: ${user.name}'),
              SizedBox(height: 8),
              Text('ID: ${user.id}'),
              SizedBox(height: 8),
              Text('سبب الحظر: ${user.banReason}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('إغلاق'),
            ),
          ],
        ),
      ),
    );
  }

  void _showUnbanDialog(BuildContext context, BlacklistedUserModel user, BlacklistCubit cubit) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: StatefulBuilder(
          builder: (context, setState) {
            bool isLoading = false;
            return AlertDialog(
              
              title: Text('رفع الحظر',style: TextStyle(fontSize: 18.rf)),
             content: Text(
                'هل أنت متأكد من رفع الحظر عن ${user.name}؟',
                style: TextStyle(fontSize: 15.rf),
              ),
              actions: [
                TextButton(
                  onPressed: isLoading ? null : () => Navigator.pop(context),
                  child: Text('إلغاء',style: TextStyle(color: Colors.green,fontSize: 13.rf)),
                ),
                ElevatedButton(
                  onPressed: isLoading ? null : () async {
                    setState(() => isLoading = true);
                    final result = await cubit.unbanUser(user.id);
                    setState(() => isLoading = false);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(result == null ? 'تم رفع الحظر عن ${user.name}' : result),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text('تأكيد',style: TextStyle(color: Colors.white,fontSize: 13.rf)),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _UserRow extends StatelessWidget {
  const _UserRow({required this.user, required this.widths});

  final UserModel user;
  final _BlacklistTableColumnWidths widths;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BlacklistCubit>();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _BlacklistTableColumnWidths.horizontalPadding,
        vertical: 14,
      ),
      child: Row(
        children: [
          _BlacklistTableCell(
            width: widths.name,
            child: Text(
              user.name,
              style: TextStyle(fontSize: 13, color: AppColors.textDark),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _BlacklistTableCell(
            width: widths.id,
            child: Text(
              user.id.toString(),
              style: TextStyle(fontSize: 13, color: AppColors.grey600),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _BlacklistTableCell(
            width: widths.city,
            child: Text(
              user.city ?? 'غير محدد',
              style: TextStyle(fontSize: 13, color: AppColors.textDark),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _BlacklistTableCell(
            width: widths.actions,
            child: Center(
              child: ElevatedButton.icon(
                onPressed: () => _showBlockDialog(context, user, cubit),
                icon: Icon(Icons.block, size: 16),
                label: Text('حظر'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBlockDialog(BuildContext context, UserModel user, BlacklistCubit cubit) {
    final TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: StatefulBuilder(
          builder: (context, setState) {
            bool isLoading = false;
            return AlertDialog(
              title: Text('حظر المستخدم', style: TextStyle(fontSize: 16.rf)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('سبب الحظر للمستخدم ${user.name}:', style: TextStyle(fontSize: 12.rf)),
                  SizedBox(height: 16),
                  TextField(
                    controller: reasonController,
                    textDirection: TextDirection.rtl,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'أدخل سبب الحظر...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: EdgeInsets.all(12),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isLoading ? null : () => Navigator.pop(context),
                  child: Text('إلغاء', style: TextStyle(color: Colors.grey, fontSize: 14.rf)),
                ),
                ElevatedButton(
                  onPressed: isLoading ? null : () async {
                    final reason = reasonController.text.trim();
                    if (reason.isNotEmpty) {
                      setState(() => isLoading = true);
                      final result = await cubit.blockUser(user.id, reason);
                      setState(() => isLoading = false);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(result == null ? 'تم حظر المستخدم ${user.name}' : result),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: isLoading
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text('حظر', style: TextStyle(color: Colors.white, fontSize: 14.rf)),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
