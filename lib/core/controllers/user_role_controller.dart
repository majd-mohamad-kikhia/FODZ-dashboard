import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:foodzdashbord/core/utils/appColors.dart';
import 'package:foodzdashbord/core/utils/app_strings.dart';

class UserRoleController extends GetxController {
  static const String _adminRole = 'admin';

  final RxString _role = ''.obs;

  String get role => _role.value;

  bool get isAdmin => _normalize(role) == _adminRole;

  @override
  void onInit() {
    super.onInit();
    _loadRoleFromStorage();
  }

  Future<void> refreshRole() async {
    await _loadRoleFromStorage();
  }

  Future<void> _loadRoleFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final storedRole = prefs.getString(AppStrings.userRole) ?? '';
    _role.value = storedRole;
  }

  void setRole(String? value) {
    _role.value = value ?? '';
  }

  bool ensureAdmin({String? message}) {
    if (isAdmin) return true;
    showAdminRestrictionMessage(message: message);
    return false;
  }

  void showAdminRestrictionMessage({String? message}) {
    Get.snackbar(
      'تنبيه',
      message ?? 'هذا الإجراء متاح للمسؤول فقط',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.primaryRed,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  static String _normalize(String value) => value.trim().toLowerCase();
}
