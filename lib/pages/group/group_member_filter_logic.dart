import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';

class GroupMemberFilterLogic extends GetxController {
  String? groupID;
  final RxList<GroupMembersInfo> members = <GroupMembersInfo>[].obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments ?? {};
    groupID = args['groupID'];
  }

  Future<void> load({required int startTime, required int endTime, int offset = 0, int count = 50}) async {
    if (groupID == null) return;
    try {
      final list = await OpenIM.iMManager.groupManager.getGroupMemberList(groupID: groupID!, filter: 0, offset: offset, count: count);
      members.assignAll(list);
    } catch (_) {}
  }
}