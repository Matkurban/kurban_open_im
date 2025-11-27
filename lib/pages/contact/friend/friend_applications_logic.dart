import 'dart:async';

import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/constant/constants.dart';
import 'package:kurban_open_im/repository/friend_repository.dart';
import 'package:kurban_open_im/services/app_global_event.dart';

class FriendApplicationsLogic extends GetxController {
  FriendApplicationsLogic() : _friendRepository = Get.find<FriendRepository>();

  final FriendRepository _friendRepository;

  final RxList<FriendApplicationInfo> incoming = <FriendApplicationInfo>[].obs;
  final RxList<FriendApplicationInfo> outgoing = <FriendApplicationInfo>[].obs;
  final RxBool loading = false.obs;
  final RxBool processing = false.obs;

  late final StreamSubscription<FriendApplicationInfo> _appChangedSub;

  @override
  void onInit() {
    super.onInit();
    _appChangedSub = AppGlobalEvent.onFriendApplicationChanged.listen(
      (_) => loadApplications(),
    );
  }

  @override
  void onReady() {
    super.onReady();
    loadApplications();
  }

  @override
  void onClose() {
    _appChangedSub.cancel();
    super.onClose();
  }

  Future<void> loadApplications() async {
    loading.value = true;
    try {
      final results = await Future.wait([
        _friendRepository.getIncomingApplications(
          handleResults: const [0],
          offset: 0,
          count: 100,
        ),
        _friendRepository.getOutgoingApplications(offset: 0, count: 100),
      ]);
      incoming.assignAll(results[0]);
      outgoing.assignAll(results[1]);
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
    } finally {
      loading.value = false;
    }
  }

  Future<void> accept(FriendApplicationInfo info) async {
    if (info.fromUserID == null) return;
    processing.value = true;
    try {
      await _friendRepository.acceptFriendApplication(userID: info.fromUserID!);
      await loadApplications();
      Get.snackbar("提示", "已同意好友请求");
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
      Get.snackbar("提示", "操作失败");
    } finally {
      processing.value = false;
    }
  }

  Future<void> refuse(FriendApplicationInfo info) async {
    if (info.fromUserID == null) return;
    processing.value = true;
    try {
      await _friendRepository.refuseFriendApplication(userID: info.fromUserID!);
      await loadApplications();
      Get.snackbar("提示", "已拒绝好友请求");
    } catch (e, s) {
      error(e.toString(), stackTrace: s);
      Get.snackbar("提示", "操作失败");
    } finally {
      processing.value = false;
    }
  }
}
