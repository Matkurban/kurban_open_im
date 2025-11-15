import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';

class FriendApplicationsLogic extends GetxController {
  final RxList<FriendApplicationInfo> received = <FriendApplicationInfo>[].obs;
  final RxList<FriendApplicationInfo> sent = <FriendApplicationInfo>[].obs;

  @override
  void onReady() async {
    super.onReady();
    await load();
  }

  Future<void> load() async {
    try {
      final r = await OpenIM.iMManager.friendshipManager.getFriendApplicationListAsRecipient();
      final s = await OpenIM.iMManager.friendshipManager.getFriendApplicationListAsApplicant();
      received.assignAll(r);
      sent.assignAll(s);
    } catch (_) {}
  }

  Future<void> accept(String userID) async {
    try {
      await OpenIM.iMManager.friendshipManager.acceptFriendApplication(userID: userID);
      await load();
    } catch (_) {}
  }

  Future<void> refuse(String userID) async {
    try {
      await OpenIM.iMManager.friendshipManager.refuseFriendApplication(userID: userID);
      await load();
    } catch (_) {}
  }
}