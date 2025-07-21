import 'package:chat/utils/secrets.dart';
import 'package:zego_zimkit/zego_zimkit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class ZIMService {
  void initZego() {
    ZIMKit().init(appID: Secrets.appID, appSign: Secrets.appSign);
  }

  Future<void> connect(String id, String name) async {
    await ZIMKit().connectUser(id: id.trim(), name: name.trim());
    await initCallInvitationService(id, name);
  }

  Future<void> disconnect() async {
    await ZIMKit().disconnectUser();
  }

  Future<void> initCallInvitationService(String id, String name) async {
    await ZegoUIKitPrebuiltCallInvitationService().init(
      appID: Secrets.appID,
      appSign: Secrets.appSign,
      userID: id,
      userName: name,
      plugins: [ZegoUIKitSignalingPlugin()],
    );
  }
}
