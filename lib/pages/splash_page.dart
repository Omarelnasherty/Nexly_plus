import 'package:chat/utils/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import '../services/zim_service.dart';
import 'chat_list_page.dart';
import 'login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    ZIMService().initZego();

    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('userId');
    final name = prefs.getString('userName');

    if (id != null && name != null && id.trim().isNotEmpty) {
      try {
        await ZIMService().connect(id, name);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ChatListPage()),
        );
      } catch (e) {
        await StorageHelper.clearUser();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
