import 'package:foodzdashbord/core/utils/appColors.dart';
import 'package:foodzdashbord/core/utils/constants.dart';
import 'package:foodzdashbord/core/utils/fcm_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Widget to display and copy FCM token (for testing/debugging)
/// Add this to your settings or profile screen in debug mode
class FCMTokenWidget extends StatelessWidget {
  const FCMTokenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final token = FCMHelper.getToken();

    return Container(
      margin: responsiveInsetsSymmetric(horizontal: 16, vertical: 8),
      padding: responsiveInsetsAll(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.rw),
        border: Border.all(color: AppColors.primaryRed.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                Icons.notifications_active,
                color: AppColors.primaryRed,
                size: 20.rf,
              ),
              SizedBox(width: 8.rw),
              Text(
                'رمز الإشعارات (FCM Token)',
                style: TextStyle(
                  fontSize: 16.rf,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.rh),
          Container(
            padding: responsiveInsetsAll(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8.rw),
            ),
            child: SelectableText(
              token ?? 'جاري تحميل الرمز...',
              style: TextStyle(
                fontSize: 11.rf,
                color: Colors.grey[700],
                fontFamily: 'monospace',
              ),
              maxLines: 3,
            ),
          ),
          SizedBox(height: 12.rh),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: token != null
                      ? () {
                          Clipboard.setData(ClipboardData(text: token));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('تم نسخ الرمز بنجاح'),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.rw),
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      : null,
                  icon: Icon(Icons.copy, size: 16.rf),
                  label: Text(
                    'نسخ',
                    style: TextStyle(fontSize: 14.rf),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    foregroundColor: Colors.white,
                    padding: responsiveInsetsSymmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.rw),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.rw),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    FCMHelper.printToken();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('تم طباعة الرمز في Console'),
                        backgroundColor: AppColors.primaryRed,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.rw),
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: Icon(Icons.print, size: 16.rf),
                  label: Text(
                    'طباعة',
                    style: TextStyle(fontSize: 14.rf),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryRed,
                    side: const BorderSide(color: AppColors.primaryRed),
                    padding: responsiveInsetsSymmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.rw),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.rh),
          Text(
            'استخدم هذا الرمز لاختبار الإشعارات من Firebase Console',
            style: TextStyle(
              fontSize: 11.rf,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Simple ListTile version for settings screen
class FCMTokenListTile extends StatelessWidget {
  const FCMTokenListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: responsiveInsetsAll(8),
        decoration: BoxDecoration(
          color: AppColors.primaryRed.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.rw),
        ),
        child: Icon(
          Icons.notifications_active,
          color: AppColors.primaryRed,
          size: 20.rf,
        ),
      ),
      title: Text(
        'رمز الإشعارات',
        style: TextStyle(
          fontSize: 15.rf,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        'عرض ونسخ رمز FCM للاختبار',
        style: TextStyle(
          fontSize: 12.rf,
          color: Colors.grey[600],
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16.rf,
        color: Colors.grey[400],
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.rw),
            ),
            child: Padding(
              padding: responsiveInsetsAll(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'رمز الإشعارات',
                        style: TextStyle(
                          fontSize: 18.rf,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.rh),
                  const FCMTokenWidget(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
