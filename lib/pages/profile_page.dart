import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  File? _avatarImage;
  bool _loading = false;
  String? _status;
  String? _userId;
  String? _phoneNumber;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      _userId = currentUser.uid;
      _phoneNumber = currentUser.phoneNumber;

      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        _nameController.text = data?['name'] ?? '';
      }

      setState(() {});
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() => _avatarImage = File(pickedFile.path));
    }
  }

  Future<void> _saveProfile() async {
    final newName = _nameController.text.trim();
    if (newName.isEmpty) {
      setState(() => _status = 'Name can’t be empty');
      return;
    }

    setState(() {
      _loading = true;
      _status = null;
    });

    try {
      await ZIMKit().updateUserInfo(name: newName);

      await FirebaseFirestore.instance.collection('users').doc(_userId).set({
        'name': newName,
        'id': _userId,
        'phone': _phoneNumber,
      }, SetOptions(merge: true));

      setState(() => _status = 'Profile updated ✅');
    } catch (e) {
      setState(() => _status = 'Update failed: ${e.toString()}');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text('Profile', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (_avatarImage != null)
                CircleAvatar(
                  radius: 50,
                  backgroundImage: FileImage(_avatarImage!),
                )
              else
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFF674FA3),
                  child: Icon(Icons.person, size: 40, color: Colors.white),
                ),
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.image, color: Color(0xFF674FA3)),
                label: const Text(
                  "Choose Image",
                  style: TextStyle(color: Color(0xFF674FA3)),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                initialValue: _phoneNumber ?? '',
                enabled: false,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              if (_status != null)
                Text(
                  _status!,
                  style: TextStyle(
                    color: _status!.contains('✅') ? Colors.green : Colors.red,
                  ),
                ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF674FA3),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _loading ? null : _saveProfile,
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Save Changes',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
