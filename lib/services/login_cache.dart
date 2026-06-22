import 'package:claymore/models/user.dart';
import 'package:claymore/state/app_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginCache {
  static const String _userIdKey = 'cached_user_id';

  static Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
  }
}