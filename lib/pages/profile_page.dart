/// lib/pages/profile_page.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _userId;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _avatarUrlController = TextEditingController();
  bool _loading = false;
  String? _status;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('userId');
      _nameController.text = prefs.getString('userName') ?? '';
      // لو كنت بتخزن رابط الصورة في SharedPreferences
      _avatarUrlController.text = prefs.getString('avatarUrl') ?? '';
    });
  }

  Future<void> _saveProfile() async {
    final newName = _nameController.text.trim();
    final newAvatar = _avatarUrlController.text.trim();

    if (newName.isEmpty) {
      setState(() => _status = 'الاسم لا يمكن أن يكون فارغاً');
      return;
    }

    setState(() {
      _loading = true;
      _status = null;
    });

    try {
      await ZIMKit().updateUserInfo(name: newName, avatarUrl: newAvatar);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', newName);
      await prefs.setString('avatarUrl', newAvatar);
      setState(() => _status = 'تم تحديث البيانات بنجاح ✅');
    } catch (e) {
      setState(() => _status = 'فشل التحديث: ${e.toString()}');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الملف الشخصي')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              initialValue: _userId,
              enabled: false,
              decoration: const InputDecoration(labelText: 'معرف المستخدم'),
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'اسم المستخدم'),
            ),
            TextField(
              controller: _avatarUrlController,
              decoration: const InputDecoration(
                labelText: 'رابط الصورة (اختياري)',
              ),
            ),
            const SizedBox(height: 16),
            if (_status != null)
              Text(
                _status!,
                style: TextStyle(
                  color: _status!.contains('✅') ? Colors.green : Colors.red,
                ),
              ),
            ElevatedButton(
              onPressed: _loading ? null : _saveProfile,
              child: _loading
                  ? const CircularProgressIndicator()
                  : const Text('حفظ التغييرات'),
            ),
          ],
        ),
      ),
    );
  }
}
