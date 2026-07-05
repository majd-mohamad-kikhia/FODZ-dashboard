import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foodzdashbord/core/utils/appColors.dart';
import 'package:foodzdashbord/core/utils/constants.dart';
import 'package:foodzdashbord/features/cities/data/models/city_model.dart';
import 'package:foodzdashbord/features/cities/presentation/cubit/cities_cubit.dart';

class CitiesScreen extends StatelessWidget {
  const CitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CitiesCubit(),
      child: const _CitiesView(),
    );
  }
}

class _CitiesView extends StatelessWidget {
  const _CitiesView();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CitiesHeader(),
        SizedBox(height: 24.rh),
        Expanded(child: _CitiesBody()),
      ],
    );
  }
}

class _CitiesHeader extends StatelessWidget {
  const _CitiesHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'المدن',
          style: TextStyle(
            fontSize: 20.rf,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        _AddCityButton(),
      ],
    );
  }
}

class _AddCityButton extends StatelessWidget {
  const _AddCityButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CitiesCubit, CitiesState>(
      builder: (context, state) {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => _showAddCityDialog(context),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20.rw,
                vertical: 12.rh,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryRed, AppColors.secondaryRed],
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryRed.withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_rounded, color: Colors.white, size: 20.rf),
                  SizedBox(width: 8.rw),
                  Text(
                    'إضافة مدينة',
                    style: TextStyle(
                      fontSize: 13.rf,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAddCityDialog(BuildContext context) {
    final cubit = context.read<CitiesCubit>();
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: const _AddCityDialog(),
      ),
    );
  }
}

class _AddCityDialog extends StatefulWidget {
  const _AddCityDialog();

  @override
  State<_AddCityDialog> createState() => _AddCityDialogState();
}

class _AddCityDialogState extends State<_AddCityDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nameArController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _nameArController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.location_city_rounded,
                  color: AppColors.primaryRed, size: 20.rf),
            ),
            SizedBox(width: 12.rw),
            Text(
              'إضافة مدينة جديدة',
              style: TextStyle(
                fontSize: 16.rf,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 400.rw,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _DialogTextField(
                controller: _nameArController,
                label: 'الاسم بالعربية',
                hint: 'مثال: الرياض',
              ),
              SizedBox(height: 16.rh),
              _DialogTextField(
                controller: _nameController,
                label: 'الاسم بالإنجليزية',
                hint: 'مثال: Riyadh',
                textDirection: TextDirection.ltr,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: TextStyle(color: AppColors.grey600, fontSize: 13.rf),
            ),
          ),
          _isLoading
              ? SizedBox(
                  width: 80.rw,
                  child: Center(
                    child: SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primaryRed),
                      ),
                    ),
                  ),
                )
              : ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.rw, vertical: 10),
                  ),
                  child: Text(
                    'إضافة',
                    style: TextStyle(
                        fontSize: 13.rf, fontWeight: FontWeight.w700),
                  ),
                ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    final nameAr = _nameArController.text.trim();
    if (name.isEmpty || nameAr.isEmpty) return;

    setState(() => _isLoading = true);
    final cubit = context.read<CitiesCubit>();
    final error = await cubit.createCity(name: name, nameAr: nameAr);
    if (!mounted) return;
    setState(() => _isLoading = false);
    Navigator.pop(context);
    if (error != null) {
      showErrorSnackBar(context, error);
    } else {
      showSuccessSnackBar(context, 'تمت إضافة المدينة بنجاح');
    }
  }
}

class _DialogTextField extends StatelessWidget {
  const _DialogTextField({
    required this.controller,
    required this.label,
    required this.hint,
    this.textDirection = TextDirection.rtl,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final TextDirection textDirection;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12.rf,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        SizedBox(height: 6.rh),
        TextField(
          controller: controller,
          textDirection: textDirection,
          style: TextStyle(fontSize: 13.rf, color: AppColors.textDark),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(fontSize: 12.rf, color: AppColors.grey400),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.grey200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.grey200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  BorderSide(color: AppColors.primaryRed, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class _CitiesBody extends StatelessWidget {
  const _CitiesBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CitiesCubit, CitiesState>(
      builder: (context, state) {
        if (state.status == CitiesStatus.loading) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primaryRed),
          );
        }

        if (state.status == CitiesStatus.error) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline_rounded,
                    size: 48, color: AppColors.primaryRed),
                SizedBox(height: 12.rh),
                Text(
                  state.errorMessage ?? 'حدث خطأ ما',
                  style: TextStyle(fontSize: 14.rf, color: AppColors.grey600),
                ),
                SizedBox(height: 16.rh),
                TextButton.icon(
                  onPressed: () => context.read<CitiesCubit>().fetchCities(),
                  icon: Icon(Icons.refresh_rounded,
                      color: AppColors.primaryRed),
                  label: Text(
                    'إعادة المحاولة',
                    style: TextStyle(color: AppColors.primaryRed),
                  ),
                ),
              ],
            ),
          );
        }

        if (state.cities.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_city_rounded,
                    size: 52, color: AppColors.grey300),
                SizedBox(height: 14.rh),
                Text(
                  'لا توجد مدن مضافة بعد',
                  style: TextStyle(
                      fontSize: 15.rf, color: AppColors.grey600),
                ),
              ],
            ),
          );
        }

        return _CitiesGrid(cities: state.cities);
      },
    );
  }
}

class _CitiesGrid extends StatelessWidget {
  const _CitiesGrid({required this.cities});

  final List<CityModel> cities;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 320.rw,
        mainAxisExtent: 110.rh,
        crossAxisSpacing: 16.rw,
        mainAxisSpacing: 16.rh,
      ),
      itemCount: cities.length,
      itemBuilder: (context, index) => _CityCard(city: cities[index]),
    );
  }
}

class _CityCard extends StatelessWidget {
  const _CityCard({required this.city});

  final CityModel city;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.rw, vertical: 10.rh),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44.rw,
            height: 44.rw,
            decoration: BoxDecoration(
              color: AppColors.primaryRed.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.location_city_rounded,
              color: AppColors.primaryRed,
              size: 18.rf,
            ),
          ),
          SizedBox(width: 14.rw),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  city.nameAr,
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
                  city.name,
                  style: TextStyle(
                    fontSize: 12.rf,
                    color: AppColors.grey600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          _DeleteCityButton(city: city),
        ],
      ),
    );
  }
}

class _DeleteCityButton extends StatelessWidget {
  const _DeleteCityButton({required this.city});

  final CityModel city;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CitiesCubit, CitiesState>(
      builder: (context, state) {
        return IconButton(
          icon: Icon(
            Icons.delete_outline_rounded,
            color: AppColors.primaryRed,
            size: 18.rf,
          ),
          tooltip: 'حذف',
          onPressed: state.isDeleting
              ? null
              : () => _showDeleteDialog(context),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context) {
    final cubit = context.read<CitiesCubit>();
    showDialog(
      context: context,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: Colors.white,
          title: Text(
            'حذف المدينة',
            style: TextStyle(
              fontSize: 16.rf,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
          content: Text(
            'هل أنت متأكد من حذف مدينة "${city.nameAr}"؟\nلا يمكن التراجع عن هذه العملية.',
            style:
                TextStyle(fontSize: 13.rf, color: AppColors.grey600, height: 1.6),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'إلغاء',
                style:
                    TextStyle(color: AppColors.grey600, fontSize: 13.rf),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                final error = await cubit.deleteCity(city.id);
                if (error != null) {
                  showErrorSnackBar(context, error);
                } else {
                  showSuccessSnackBar(context, 'تم حذف المدينة بنجاح');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(
                'حذف',
                style: TextStyle(
                    fontSize: 13.rf, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
