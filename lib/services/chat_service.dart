import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

class ChatService {
  static Future<void> startNewChat(
    BuildContext context,
    String currentUserID,
  ) async {
    String? enteredPhoneNumber;

    await showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Start New Chat'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              hintText: 'مثال: 00123456789',
              prefixIcon: Icon(Icons.phone),
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF674FA3),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                enteredPhoneNumber = controller.text.trim();
                Navigator.of(context).pop();
              },
              child: const Text('Start'),
            ),
          ],
        );
      },
    );

    if (enteredPhoneNumber == null || enteredPhoneNumber!.isEmpty) return;

    if (!enteredPhoneNumber!.startsWith("+")) {
      enteredPhoneNumber = "+20${enteredPhoneNumber!}";
    }

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('phone', isEqualTo: enteredPhoneNumber)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        _showSnackBar(context, "🙈 No user found with this number!");
        return;
      }

      final userData = querySnapshot.docs.first;
      final targetUserID = userData['uid'];
      final targetUserName = userData['name'];

      if (targetUserID == currentUserID) {
        _showSnackBar(context, "🫢 You can't chat with yourself!");
        return;
      }

      _openChat(
        context,
        targetUserID,
        targetUserName,
        ZIMKitConversationType.peer,
      );
    } catch (e) {
      _showSnackBar(context, "💥 Error: ${e.toString()}");
    }
  }

  static void _openChat(
    BuildContext context,
    String id,
    String name,
    ZIMKitConversationType type,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ZIMKitMessageListPage(
          conversationID: id,
          conversationType: type,
          appBarBuilder: (context, _) => AppBar(
            title: Text(name),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
        ),
      ),
    );
  }

  static void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message, style: const TextStyle(fontSize: 16)),
      backgroundColor: Colors.deepPurple.shade400,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      duration: const Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
