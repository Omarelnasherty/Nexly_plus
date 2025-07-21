import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import 'zim_service.dart';
import '../utils/secrets.dart';

Future<void> initializeZego(GlobalKey<NavigatorState> navigatorKey) async {
  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);

  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    final userId = currentUser.uid;
    final userName = currentUser.phoneNumber ?? "User$userId";

    try {
      ZIMService().initZego();
      await ZIMService().connect(userId, userName);

      await ZegoUIKitPrebuiltCallInvitationService().init(
        appID: Secrets.appID,
        appSign: Secrets.appSign,
        userID: userId,
        userName: userName,
        plugins: [ZegoUIKitSignalingPlugin()],
      );
    } catch (e) {
      await FirebaseAuth.instance.signOut();
    }
  }
}
