import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodzdashbord/core/utils/appColors.dart';
import 'package:foodzdashbord/core/utils/constants.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final bool readOnly;
  final VoidCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
    this.readOnly = false,
    this.onTap,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      readOnly: readOnly,
      onTap: onTap,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontFamily: 'Cairo',
          color: const Color.fromRGBO(131, 145, 161, 1),
          fontWeight: FontWeight.w500,
          fontSize: 14.rf,
        ),
        filled: true,
        fillColor: const Color.fromRGBO(247, 248, 249, 1),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.rw),
          borderSide: const BorderSide(color: Color.fromRGBO(232, 236, 244, 1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.rw),
          borderSide: BorderSide(color: AppColors.primaryRed, width: 1.5.rw),
        ),
        contentPadding: responsiveInsetsSymmetric(horizontal: 20, vertical: 16),
      ),
    );
  }
}
