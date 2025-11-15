import 'package:get/get.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';

class BlacklistLogic extends GetxController {
  final RxList<Map<String, String>> list = <Map<String, String>>[].obs;

  Future<void> load() async {
    final blacks = await OpenIM.iMManager.friendshipManager.getBlacklist();
    list.assignAll(blacks.map((e) => {
          'userID': e.userID ?? '',
          'nickname': e.nickname ?? '',
        }));
  }

  Future<void> remove(String userID) async {
    await OpenIM.iMManager.friendshipManager.removeBlacklist(userID: userID);
    list.removeWhere((e) => e['userID'] == userID);
  }
}