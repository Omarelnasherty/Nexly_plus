import 'package:flutter/material.dart';
import 'package:zego_zimkit/zego_zimkit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit/zego_uikit.dart';

const Color primaryColor = Color(0xFF674FA3);

// اللون الأساسي الموحد

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
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId') ?? '';
      userName = prefs.getString('userName') ?? '';
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
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            widget.conversationID,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: ZegoSendCallInvitationButton(
                isVideoCall: false,
                resourceID: "zegouikit_call",
                invitees: [
                  ZegoUIKitUser(
                    id: widget.conversationID,
                    name: widget.conversationID,
                  ),
                ],
                icon: ButtonIcon(
                  icon: Icon(Icons.call, size: 21, color: primaryColor),
                ),
                buttonSize: const Size(40, 40),
                iconSize: const Size(24, 24),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: ZegoSendCallInvitationButton(
                isVideoCall: true,
                resourceID: "zegouikit_call",
                invitees: [
                  ZegoUIKitUser(
                    id: widget.conversationID,
                    name: widget.conversationID,
                  ),
                ],
                icon: ButtonIcon(
                  icon: Icon(Icons.videocam, size: 22, color: primaryColor),
                ),
                buttonSize: const Size(40, 40),
                iconSize: const Size(24, 24),
              ),
            ),
          ],
        );
      },
    );
  }
}
