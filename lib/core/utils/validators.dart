import 'package:flutter/services.dart';

class AppValidators {
  AppValidators._();

  static final RegExp _phoneRegExp = RegExp(r'^\d+$');
  static final RegExp _fullNameRegExp = RegExp(r'^[A-Za-z\u0621-\u064A\s]+$');

  static String? validatePhone(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'الرجاء إدخال رقم الموبايل';
    }
    if (!_phoneRegExp.hasMatch(trimmed)) {
      return 'رقم الموبايل يجب أن يحتوي على أرقام فقط';
    }
    return null;
  }

  static String? validateFullName(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'الرجاء إدخال الاسم الكامل';
    }
    final withoutSpaces = trimmed.replaceAll(RegExp(r'\s+'), '');
    if (withoutSpaces.length < 5) {
      return 'الاسم الكامل يجب أن يكون 5 أحرف على الأقل';
    }
    if (!_fullNameRegExp.hasMatch(trimmed)) {
      return 'الاسم يجب أن يحتوي على أحرف عربية أو إنجليزية ومسافات فقط';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    final password = value ?? '';
    if (password.isEmpty) {
      return 'الرجاء إدخال كلمة السر';
    }
    return null;
  }

  static List<TextInputFormatter> get phoneInputFormatters => [
        FilteringTextInputFormatter.digitsOnly,
      ];

  static List<TextInputFormatter> get fullNameInputFormatters => [
        FilteringTextInputFormatter.allow(
          RegExp(r'[A-Za-z\u0621-\u064A\s]'),
        ),
      ];
}
