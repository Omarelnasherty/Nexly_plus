import 'package:chat/widgets/call_buttons/audio_call_button.dart';
import 'package:chat/widgets/call_buttons/video_call_button.dart';
import 'package:flutter/material.dart';
import 'package:zego_zimkit/zego_zimkit.dart';

import '../../constants/colors.dart';
import '../../services/user_info_service.dart';

class ChatWithCallPage extends StatefulWidget {
  final String conversationID;
  final ZIMKitConversationType conversationType;

  const ChatWithCallPage({
    super.key,
    required this.conversationID,
    required this.conversationType,
  });

  @override
  State<ChatWithCallPage> createState() => _ChatWithCallPageState();
}

class _ChatWithCallPageState extends State<ChatWithCallPage> {
  String userId = '';
  String userName = '';

  @override
  void initState() {
    super.initState();
    loadUserInfo().then((userInfo) {
      setState(() {
        userId = userInfo['userId'] ?? '';
        userName = userInfo['userName'] ?? '';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ZIMKitMessageListPage(
      showMoreButton: false,
      conversationID: widget.conversationID,
      conversationType: widget.conversationType,
      messageInputActions: const [],
      appBarBuilder: (context, defaultAppBar) {
        return AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_sharp,
              size: 20,
              color: primaryColor,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            widget.conversationID,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          actions: [
            AudioCallButton(userId: widget.conversationID),
            VideoCallButton(userId: widget.conversationID),
          ],
        );
      },
    );
  }
}
