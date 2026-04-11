// import 'package:foodzdashbord/core/widgets/login_required_dialog.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:foodzdashbord/core/utils/app_strings.dart';

// Future<bool> isUserLoggedIn() async {
//   final prefs = await SharedPreferences.getInstance();
//   final token = prefs.getString(AppStrings.token) ?? '';
//   return token.isNotEmpty;
// }

// Future<void> showLoginRequiredDialog(
//   BuildContext context, {
//   required String title,
//   required String message,
// }) {
//   return showDialog(
//     context: context,
//     builder: (context) => LoginRequiredDialog(
//       title: title,
//       message: message,
//     ),
//   );
// }
