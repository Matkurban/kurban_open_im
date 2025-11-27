import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/constant/constants.dart';
import 'package:kurban_open_im/repository/friend_repository.dart';

class FriendSearchLogic extends GetxController {
  final keywordController = TextEditingController();
  final reasonController = TextEditingController();
  final _friendRepository = Get.find<FriendRepository>();

  final RxBool searching = false.obs;
  final RxBool sending = false.obs;
  final RxList<SearchFriendsInfo> results = <SearchFriendsInfo>[].obs;

  @override
  void onClose() {
    keywordController.dispose();
    reasonController.dispose();
    super.onClose();
  }

  Future<void> search() async {
    final keyword = keywordController.text.trim();
    if (keyword.isEmpty) {
      Get.snackbar("提示", "请输入关键词");
      return;
    }
    searching.value = true;
    try {
      final list = await _friendRepository.searchFriends(keyword);
      results.assignAll(list);
      if (list.isEmpty) {
        Get.snackbar("提示", "未查询到用户");
      }
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
      Get.snackbar("提示", "搜索失败");
    } finally {
      searching.value = false;
    }
  }

  bool isAlreadyFriend(SearchFriendsInfo info) => info.relationship == 1;

  bool isSelf(SearchFriendsInfo info) {
    final selfID = userInfo.value.userID;
    if (selfID == null) return false;
    return info.userID == selfID;
  }

  Future<void> sendRequest(SearchFriendsInfo info) async {
    if (info.userID == null) return;
    if (isAlreadyFriend(info)) {
      Get.snackbar("提示", "TA已经是你的好友");
      return;
    }
    if (isSelf(info)) {
      Get.snackbar("提示", "不能添加自己为好友");
      return;
    }
    final remark = reasonController.text.trim();
    sending.value = true;
    try {
      await _friendRepository.addFriend(
        userID: info.userID!,
        reason: remark.isEmpty ? null : remark,
      );
      Get.snackbar("提示", "好友申请已发送");
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
      Get.snackbar("提示", "发送失败");
    } finally {
      sending.value = false;
    }
  }
}
