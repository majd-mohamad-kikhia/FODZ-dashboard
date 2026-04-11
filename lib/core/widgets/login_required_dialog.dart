// import 'package:foodzdashbord/core/utils/appColors.dart';
// import 'package:foodzdashbord/core/utils/constants.dart';
// import 'package:foodzdashbord/features/auth/presentation/screens/account_type_screen.dart';
// import 'package:flutter/material.dart';

// class LoginRequiredDialog extends StatelessWidget {
//   final String title;
//   final String message;

//   const LoginRequiredDialog({
//     super.key,
//     required this.title,
//     required this.message,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(24.rw),
//       ),
//       child: Directionality(
//         textDirection: TextDirection.rtl,
//         child: Padding(
//           padding: responsiveInsetsSymmetric(horizontal: 24, vertical: 32),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 80.rw,
//                 height: 80.rh,
//                 decoration: BoxDecoration(
//                   color: AppColors.primaryRed.withOpacity(0.1),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(
//                   Icons.lock_outline,
//                   size: 40.rf,
//                   color: AppColors.primaryRed,
//                 ),
//               ),
//               24.vSpace,
//               Text(
//                 title,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 18.rf,
//                   fontWeight: FontWeight.w700,
//                   color: AppColors.textDark,
//                 ),
//               ),
//               12.vSpace,
//               Text(
//                 message,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 14.rf,
//                   fontWeight: FontWeight.w500,
//                   color: AppColors.grey600,
//                   height: 1.5,
//                 ),
//               ),
//               32.vSpace,
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (_) => const AccountTypeScreen(),
//                       ),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primaryRed,
//                     foregroundColor: Colors.white,
//                     padding: responsiveInsetsSymmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16.rw),
//                     ),
//                   ),
//                   child: Text(
//                     'تسجيل الدخول',
//                     style: TextStyle(
//                       fontSize: 16.rf,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//               12.vSpace,
//               SizedBox(
//                 width: double.infinity,
//                 child: OutlinedButton(
//                   onPressed: () => Navigator.of(context).pop(),
//                   style: OutlinedButton.styleFrom(
//                     foregroundColor: AppColors.primaryRed,
//                     side: const BorderSide(color: AppColors.primaryRed, width: 1.5),
//                     padding: responsiveInsetsSymmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16.rw),
//                     ),
//                   ),
//                   child: Text(
//                     'إلغاء',
//                     style: TextStyle(
//                       fontSize: 16.rf,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
