import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/constant/constants.dart';
import 'package:kurban_open_im/repository/friend_repository.dart';
import 'package:kurban_open_im/router/router_name.dart';

class FriendDetailLogic extends GetxController {
  FriendDetailLogic({required this.friend});

  final FriendInfo friend;
  final _friendRepository = Get.find<FriendRepository>();

  final Rxn<FriendInfo> info = Rxn<FriendInfo>();
  final RxBool loading = false.obs;
  final RxBool operating = false.obs;

  @override
  void onInit() {
    super.onInit();
    info.value = friend;
  }

  Future<void> refreshInfo() async {
    final userID = info.value?.userID;
    if (userID == null) return;
    loading.value = true;
    try {
      final detail = await _friendRepository.getFriendInfo(userID);
      info.value = detail ?? info.value;
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    } finally {
      loading.value = false;
    }
  }

  Future<void> updateRemark(String remark) async {
    final userID = info.value?.userID;
    if (userID == null) return;
    if (remark.trim().isEmpty) {
      Get.snackbar("提示", "备注不能为空");
      return;
    }
    operating.value = true;
    try {
      await _friendRepository.updateFriendRemark(
        userID: userID,
        remark: remark.trim(),
      );
      await refreshInfo();
      Get.snackbar("提示", "备注已更新");
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
      Get.snackbar("提示", "更新失败");
    } finally {
      operating.value = false;
    }
  }

  bool get hasUser => info.value?.userID != null;
  bool get isBlacklisted => info.value?.ex == 'black';

  Future<bool?> confirmAction({required String message}) {
    return Get.dialog<bool>(
      AlertDialog(
        title: const Text("提示"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text("取消"),
          ),
          FilledButton(
            onPressed: () => Get.back(result: true),
            child: const Text("确认"),
          ),
        ],
      ),
    );
  }

  Future<void> deleteFriend() async {
    final userID = info.value?.userID;
    if (userID == null) return;
    final confirm = await confirmAction(message: "确定删除该好友吗？");
    if (confirm != true) return;
    operating.value = true;
    try {
      await _friendRepository.deleteFriend(userID: userID);
      Get.back();
      Get.snackbar("提示", "已删除好友");
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
      Get.snackbar("提示", "删除失败");
    } finally {
      operating.value = false;
    }
  }

  Future<void> addBlacklist() async {
    final userID = info.value?.userID;
    if (userID == null) return;
    final confirm = await confirmAction(message: "确定将该好友加入黑名单？");
    if (confirm != true) return;
    operating.value = true;
    try {
      await _friendRepository.addBlacklist(userID: userID);
      Get.back();
      Get.snackbar("提示", "已加入黑名单");
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
      Get.snackbar("提示", "操作失败");
    } finally {
      operating.value = false;
    }
  }

  Future<void> removeFromBlacklist() async {
    final userID = info.value?.userID;
    if (userID == null) return;
    operating.value = true;
    try {
      await _friendRepository.removeBlacklist(userID: userID);
      await refreshInfo();
      Get.snackbar("提示", "已移出黑名单");
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
      Get.snackbar("提示", "操作失败");
    } finally {
      operating.value = false;
    }
  }

  void openChat() {
    final userID = info.value?.userID;
    if (userID == null) return;
    final title = info.value?.remark?.isNotEmpty == true
        ? info.value!.remark!
        : info.value?.nickname ?? userID;
    Get.toNamed(
      RouterName.chat,
      arguments: {
        "isGroup": false,
        "recvID": userID,
        "groupID": null,
        "title": title,
      },
    );
  }
}
