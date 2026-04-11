import 'package:shared_preferences/shared_preferences.dart';

import 'app_strings.dart';

class UserSession {
  UserSession._();

  static Future<int?> getStoredUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(AppStrings.userId);
  }
}
