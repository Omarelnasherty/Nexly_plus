import 'package:flutter/material.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

class ChatListView extends StatelessWidget {
  const ChatListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ZIMKitConversationListView(
      emptyBuilder: (context, _) => const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "No messages yet 📭\nWhy not break the silence?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.blueGrey,
                height: 1.5,
                letterSpacing: 0.3,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
