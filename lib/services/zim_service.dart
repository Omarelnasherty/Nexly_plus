import 'package:zego_zimkit/zego_zimkit.dart';

class ZIMService {
  void initZego() {
    ZIMKit().init(
      appID: 713906771,
      appSign:
          "1012b1b3ab2af4815b46f314b90967fca85e666df9dd0e44272253229a943e62",
    );
  }

  Future<void> connect(String id, String name) async {
    await ZIMKit().connectUser(id: id.trim(), name: name.trim());
  }

  Future<void> disconnect() async {
    await ZIMKit().disconnectUser();
  }
}
