import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/constant/constants.dart';

class ContactLogic extends GetxController {
  ///好友列表
  final RxList<FriendInfo> friends = <FriendInfo>[].obs;

  ///群组列表
  final RxList<GroupInfo> groups = <GroupInfo>[].obs;

  @override
  void onReady() async {
    super.onReady();
    await loadFriends();
    await loadGroups();
  }

  ///加载好友列表
  Future<void> loadFriends() async {
    try {
      final list = await OpenIM.iMManager.friendshipManager.getFriendList();
      friends.assignAll(list);
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    }
  }

  Future<void> loadFriendsPage(int offset, int count) async {
    try {
      final list = await OpenIM.iMManager.friendshipManager.getFriendListPage(offset: offset, count: count);
      if (offset == 0) {
        friends.assignAll(list);
      } else {
        friends.addAll(list);
      }
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    }
  }

  ///加载已加入群列表
  Future<void> loadGroups() async {
    try {
      final list = await OpenIM.iMManager.groupManager.getJoinedGroupList();
      groups.assignAll(list);
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    }
  }

  Future<void> loadGroupsPage(int offset, int count) async {
    try {
      final list = await OpenIM.iMManager.groupManager.getJoinedGroupListPage(offset: offset, count: count);
      if (offset == 0) {
        groups.assignAll(list);
      } else {
        groups.addAll(list);
      }
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    }
  }
}
