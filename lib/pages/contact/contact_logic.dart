import 'dart:async';

import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/constant/constants.dart';
import 'package:kurban_open_im/repository/friend_repository.dart';
import 'package:kurban_open_im/services/app_global_event.dart';

class ContactLogic extends GetxController {
  final _friendRepo = Get.find<FriendRepository>();
  final List<StreamSubscription<dynamic>> _subscriptions = [];

  ///好友列表
  final RxList<FriendInfo> friends = <FriendInfo>[].obs;

  ///群组列表
  final RxList<GroupInfo> groups = <GroupInfo>[].obs;

  @override
  void onInit() {
    super.onInit();
    _subscriptions.addAll([
      AppGlobalEvent.onFriendAdded.listen((_) => loadFriends()),
      AppGlobalEvent.onFriendDeleted.listen((_) => loadFriends()),
      AppGlobalEvent.onFriendInfoChanged.listen(_onFriendInfoChanged),
      AppGlobalEvent.onBlacklistAdded.listen((_) => loadFriends()),
      AppGlobalEvent.onBlacklistDeleted.listen((_) => loadFriends()),
    ]);
  }

  @override
  void onReady() async {
    super.onReady();
    await loadFriends();
    await loadGroups();
  }

  @override
  void onClose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    super.onClose();
  }

  void _onFriendInfoChanged(FriendInfo info) {
    final index = friends.indexWhere(
      (element) => element.userID == info.userID,
    );
    if (index == -1) return;
    friends[index] = info;
  }

  ///加载好友列表
  Future<void> loadFriends() async {
    try {
      final list = await _friendRepo.getFriendList();
      friends.assignAll(list);
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    }
  }

  Future<void> loadFriendsPage(int offset, int count) async {
    try {
      final list = await _friendRepo.getFriendListPage(
        offset: offset,
        count: count,
      );
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
      final list = await OpenIM.iMManager.groupManager.getJoinedGroupListPage(
        offset: offset,
        count: count,
      );
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
