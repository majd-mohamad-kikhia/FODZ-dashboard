// ============================================================================
// FCM TOKEN USAGE EXAMPLES
// ============================================================================
// This file contains examples of how to use FCM in your app.
// You can copy these snippets to your actual implementation.
// ============================================================================

import 'package:foodzdashbord/core/utils/fcm_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Example: Display FCM Token Screen (for testing/debugging)
class FCMTokenScreen extends StatelessWidget {
  const FCMTokenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final token = FCMHelper.getToken();

    return Scaffold(
      appBar: AppBar(
        title: const Text('FCM Token'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'رمز الإشعارات (FCM Token)',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: SelectableText(
                token ?? 'جاري تحميل الرمز...',
                style: const TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: token != null
                  ? () {
                      Clipboard.setData(ClipboardData(text: token));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('تم نسخ الرمز'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  : null,
              icon: const Icon(Icons.copy),
              label: const Text('نسخ الرمز'),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {
                FCMHelper.printToken();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم طباعة الرمز في Console'),
                  ),
                );
              },
              icon: const Icon(Icons.print),
              label: const Text('طباعة في Console'),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// EXAMPLE 1: Send FCM Token to Backend After Login
// ============================================================================
/*
class LoginCubit extends Cubit<LoginState> {
  Future<void> login(String email, String password) async {
    // ... your login logic ...
    
    // After successful login, send FCM token to backend
    final fcmToken = FCMHelper.getToken();
    if (fcmToken != null) {
      await _sendFCMTokenToBackend(fcmToken);
    }
  }
  
  Future<void> _sendFCMTokenToBackend(String token) async {
    try {
      final response = await NetworkServices().coustomPost(
        endPoint: 'api/user/fcm-token',
        data: {
          'fcmToken': token,
          'userId': UserSession.getStoredUserId(),
          'userType': UserSession.getStoredUserType(),
        },
      );
      
      response.fold(
        (error) => print('❌ Error sending FCM token: ${error.message}'),
        (data) => print('✅ FCM token sent successfully'),
      );
    } catch (e) {
      print('❌ Error: $e');
    }
  }
}
*/

// ============================================================================
// EXAMPLE 2: Subscribe to Topics Based on User Type
// ============================================================================
/*
class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // After checking user authentication
    final userType = UserSession.getStoredUserType();
    
    if (userType == 'customer') {
      FCMHelper.subscribeToTopic('customers');
      FCMHelper.subscribeToTopic('all_users');
    } else if (userType == 'restaurant') {
      FCMHelper.subscribeToTopic('restaurants');
      FCMHelper.subscribeToTopic('all_users');
    } else if (userType == 'home') {
      FCMHelper.subscribeToTopic('home_producers');
      FCMHelper.subscribeToTopic('all_users');
    }
    
    // ... rest of your splash screen logic ...
  }
}
*/

// ============================================================================
// EXAMPLE 3: Delete Token on Logout
// ============================================================================
/*
class ProfileScreen extends StatelessWidget {
  Future<void> _logout(BuildContext context) async {
    // Unsubscribe from all topics
    await FCMHelper.unsubscribeFromTopic('customers');
    await FCMHelper.unsubscribeFromTopic('restaurants');
    await FCMHelper.unsubscribeFromTopic('home_producers');
    await FCMHelper.unsubscribeFromTopic('all_users');
    
    // Delete FCM token
    await FCMHelper.deleteToken();
    
    // Clear user session
    await UserSession.clearSession();
    
    // Navigate to login
    Get.offAllNamed('/login');
  }
}
*/

// ============================================================================
// EXAMPLE 4: Display Token in Settings (for debugging)
// ============================================================================
/*
class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LocalAppBar(title: 'الإعدادات'),
      body: ListView(
        children: [
          // ... other settings ...
          
          if (kDebugMode) // Only show in debug mode
            ListTile(
              leading: Icon(Icons.notifications_active),
              title: Text('رمز الإشعارات (FCM Token)'),
              subtitle: Text('للاختبار فقط'),
              trailing: Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FCMTokenScreen(),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
*/

// ============================================================================
// EXAMPLE 5: Handle Notification Tap Navigation
// ============================================================================
/*
// In fcm_service.dart, update the _handleNotificationTap method:

void _handleNotificationTap(RemoteMessage message) {
  if (kDebugMode) {
    print('🔔 Notification Tapped: ${message.messageId}');
    print('📱 Data: ${message.data}');
  }

  final String? type = message.data['type'];
  final String? orderId = message.data['orderId'];
  
  switch (type) {
    case 'new_order':
      if (orderId != null) {
        // Navigate to pending orders screen
        Get.toNamed('/requests-received-orders');
      }
      break;
      
    case 'order_status':
      if (orderId != null) {
        // Navigate to order details
        Get.toNamed('/order-details', arguments: orderId);
      }
      break;
      
    case 'order_accepted':
      // Navigate to accepted orders
      Get.toNamed('/restaurant-orders-tabs', arguments: 1); // Tab index
      break;
      
    case 'order_shipped':
      // Navigate to customer orders
      Get.toNamed('/my-orders');
      break;
      
    default:
      // Navigate to home or show dialog
      Get.toNamed('/home');
  }
}
*/

// ============================================================================
// EXAMPLE 6: Backend API Endpoint Structure
// ============================================================================
/*
// Your backend should have these endpoints:

// 1. Save/Update FCM Token
POST /api/user/fcm-token
Body: {
  "fcmToken": "string",
  "userId": "string",
  "userType": "customer|restaurant|home"
}

// 2. Send Notification to User
POST /api/notifications/send
Body: {
  "userId": "string",
  "title": "string",
  "body": "string",
  "data": {
    "type": "new_order",
    "orderId": "12345"
  }
}

// 3. Send Notification to Topic
POST /api/notifications/send-topic
Body: {
  "topic": "customers",
  "title": "string",
  "body": "string",
  "data": {}
}

// 4. Delete FCM Token (on logout)
DELETE /api/user/fcm-token
Body: {
  "userId": "string"
}
*/
