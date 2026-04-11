import 'package:shared_preferences/shared_preferences.dart';
import 'package:foodzdashbord/features/auth/data/models/admin_model.dart';

class AuthService {
  static const String _tokenKey = 'token';
  static const String _adminIdKey = 'admin_id';
  static const String _adminNameKey = 'admin_name';
  static const String _adminEmailKey = 'admin_email';
  static const String _adminPhoneKey = 'admin_phone';

  Future<void> saveAuthData({
    required String token,
    required AdminModel admin,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setInt(_adminIdKey, admin.id);
    await prefs.setString(_adminNameKey, admin.name);
    await prefs.setString(_adminEmailKey, admin.email);
    await prefs.setString(_adminPhoneKey, admin.phoneNumber);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<AdminModel?> getAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt(_adminIdKey);
    final name = prefs.getString(_adminNameKey);
    final email = prefs.getString(_adminEmailKey);
    final phone = prefs.getString(_adminPhoneKey);

    if (id == null || name == null || email == null || phone == null) {
      return null;
    }

    return AdminModel(
      id: id,
      name: name,
      email: email,
      phoneNumber: phone,
    );
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_adminIdKey);
    await prefs.remove(_adminNameKey);
    await prefs.remove(_adminEmailKey);
    await prefs.remove(_adminPhoneKey);
  }
}
