import 'package:chat/utils/storage_service.dart';
import 'package:flutter/material.dart';
import '../services/zim_service.dart';
import 'chat_list_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _login() async {
    final userId = _userIdController.text.trim();
    final userName = _userNameController.text.trim();

    if (userId.isEmpty || userName.isEmpty) {
      setState(() => _error = "من فضلك أدخل المعرف واسم المستخدم.");
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await ZIMService().connect(userId, userName);
      await StorageHelper.saveUser(userId, userName);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ChatListPage()),
      );
    } catch (e) {
      setState(() => _error = "فشل تسجيل الدخول: ${e.toString()}");
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تسجيل الدخول')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _userIdController,
              decoration: const InputDecoration(labelText: 'User ID'),
            ),
            TextField(
              controller: _userNameController,
              decoration: const InputDecoration(labelText: 'User Name'),
            ),
            const SizedBox(height: 16),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: _loading ? null : _login,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('دخول'),
            ),
          ],
        ),
      ),
    );
  }
}
