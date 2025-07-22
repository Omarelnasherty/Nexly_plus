import 'package:flutter/material.dart';
import '../../pages/profile_page.dart';

AppBar buildChatAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 1,
    centerTitle: true,
    title: const Text(
      'Your Chats',
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 20,
        color: Color(0xFF2E1B4C),
      ),
    ),
    actions: [
      IconButton(
        icon: const Icon(Icons.person_outline, color: Color(0xFF674FA3)),
        tooltip: 'Profile',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfilePage()),
          );
        },
      ),
    ],
  );
}
