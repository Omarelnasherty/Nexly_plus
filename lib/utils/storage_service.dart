import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static Future<void> saveUser(String id, String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', id);
    await prefs.setString('userName', name);
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('userName');
  }
}
