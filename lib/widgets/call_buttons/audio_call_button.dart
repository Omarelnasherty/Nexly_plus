import 'package:chat/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class AudioCallButton extends StatelessWidget {
  final String userId;

  const AudioCallButton({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: ZegoSendCallInvitationButton(
        isVideoCall: false,
        resourceID: "zegouikit_call",
        invitees: [ZegoUIKitUser(id: userId, name: userId)],
        icon: ButtonIcon(icon: Icon(Icons.call, size: 21, color: primaryColor)),
        buttonSize: const Size(40, 40),
        iconSize: const Size(24, 24),
      ),
    );
  }
}
