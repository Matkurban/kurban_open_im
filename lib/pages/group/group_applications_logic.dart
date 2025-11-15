import 'package:get/get.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';

class GroupApplicationsLogic extends GetxController {
  final RxList<dynamic> received = <dynamic>[].obs;
  final RxList<dynamic> sent = <dynamic>[].obs;

  Future<void> load() async {
    final r = await OpenIM.iMManager.groupManager.getGroupApplicationListAsRecipient();
    final s = await OpenIM.iMManager.groupManager.getGroupApplicationListAsApplicant();
    received.assignAll(r);
    sent.assignAll(s);
  }

  Future<void> accept(String groupID, String userID) async {
    await OpenIM.iMManager.groupManager.acceptGroupApplication(groupID: groupID, userID: userID, handleMsg: 'agree');
    await load();
  }

  Future<void> refuse(String groupID, String userID) async {
    await OpenIM.iMManager.groupManager.refuseGroupApplication(groupID: groupID, userID: userID, handleMsg: 'refuse');
    await load();
  }
}