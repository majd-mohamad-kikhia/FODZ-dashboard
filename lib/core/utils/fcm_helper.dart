import 'package:foodzdashbord/core/services/fcm_service.dart';
import 'package:flutter/foundation.dart';

/// Helper class to easily access FCM token and functionality
class FCMHelper {
  /// Get current FCM token
  static String? getToken() {
    final token = FCMService().fcmToken;
    if (kDebugMode) {
      print('🔑 Current FCM Token: $token');
    }
    return token;
  }

  /// Subscribe to a topic (e.g., 'customers', 'restaurants', 'all_users')
  static Future<void> subscribeToTopic(String topic) async {
    await FCMService().subscribeToTopic(topic);
  }

  /// Unsubscribe from a topic
  static Future<void> unsubscribeFromTopic(String topic) async {
    await FCMService().unsubscribeFromTopic(topic);
  }

  /// Delete FCM token (call on logout)
  static Future<void> deleteToken() async {
    await FCMService().deleteToken();
  }

  /// Print token to console (for testing)
  static void printToken() {
    final token = getToken();
    if (token != null) {
      if (kDebugMode) {
        print('═══════════════════════════════════════════════════════════');
        print('📱 FCM TOKEN FOR TESTING:');
        print(token);
        print('═══════════════════════════════════════════════════════════');
      }
    } else {
      if (kDebugMode) {
        print('⚠️ FCM Token not available yet');
      }
    }
  }
}
