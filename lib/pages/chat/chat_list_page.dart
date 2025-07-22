import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import '../../widgets/chat/chat_app_bar.dart';
import '../../widgets/chat/chat_list_view.dart';
import '../../widgets/chat/start_chat_button.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserID = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F2FA),
      appBar: buildChatAppBar(context),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: ChatListView(),
        ),
      ),
      floatingActionButton: StartChatButton(currentUserID: currentUserID),
    );
  }
}
