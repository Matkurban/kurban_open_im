import 'dart:async';

import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/constant/constants.dart';
import 'package:kurban_open_im/repository/friend_repository.dart';
import 'package:kurban_open_im/services/app_global_event.dart';

class FriendBlacklistLogic extends GetxController {
  FriendBlacklistLogic() : _repository = Get.find<FriendRepository>();

  final FriendRepository _repository;

  final RxList<BlacklistInfo> blacklist = <BlacklistInfo>[].obs;
  final RxBool loading = false.obs;

  late final StreamSubscription<BlacklistInfo> _addSub;
  late final StreamSubscription<BlacklistInfo> _removeSub;

  @override
  void onInit() {
    super.onInit();
    _addSub = AppGlobalEvent.onBlacklistAdded.listen((_) => loadBlacklist());
    _removeSub = AppGlobalEvent.onBlacklistDeleted.listen((_) => loadBlacklist());
  }

  @override
  void onReady() {
    super.onReady();
    loadBlacklist();
  }

  @override
  void onClose() {
    _addSub.cancel();
    _removeSub.cancel();
    super.onClose();
  }

  Future<void> loadBlacklist() async {
    loading.value = true;
    try {
      final list = await _repository.getBlacklist();
      blacklist.assignAll(list);
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    } finally {
      loading.value = false;
    }
  }

  Future<void> remove(BlacklistInfo info) async {
    final userID = info.blockUserID ?? info.userID;
    if (userID == null) return;
    try {
      await _repository.removeBlacklist(userID: userID);
      await loadBlacklist();
      Get.snackbar("提示", "已移出黑名单");
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
      Get.snackbar("提示", "操作失败");
    }
  }
}
