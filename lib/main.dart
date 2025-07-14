import 'package:chat/utils/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'services/zim_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ZIMService().initZego();

  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('userId');
  final userName = prefs.getString('userName');

  bool loggedIn = false;
  if (userId != null && userName != null && userId.trim().isNotEmpty) {
    try {
      await ZIMService().connect(userId, userName);
      loggedIn = true;
    } catch (_) {
      await StorageHelper.clearUser();
    }
  }

  runApp(const MyApp());
}
