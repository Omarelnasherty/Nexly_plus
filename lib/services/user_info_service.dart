import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, String>> loadUserInfo() async {
  final prefs = await SharedPreferences.getInstance();
  return {
    'userId': prefs.getString('userId') ?? '',
    'userName': prefs.getString('userName') ?? '',
  };
}
