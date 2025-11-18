import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:kurban_open_im/constant/constants.dart';
import 'package:kurban_open_im/services/app_callback.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';

class MainLogic extends GetxController with AppCallback {
  ///控制页面的切换
  late PageController mainPageController;

  ///当前选中的索引
  final RxInt currentIndex = 0.obs;

  final RxInt totalUnread = 0.obs;

  @override
  void onInit() {
    super.onInit();
    mainPageController = PageController();
    onTotalUnreadChanged.listen((v) {
      info("未读消息数量:$v");
      totalUnread.value = v;
    });
    _loadTotalUnread();
  }

  ///点击bottomNavBar
  void onBottomNavTap(int index) {
    currentIndex.value = index;
    mainPageController.animateToPage(
      index,
      duration: Duration(milliseconds: 250),
      curve: Curves.linear,
    );
  }

  @override
  void onClose() {
    mainPageController.dispose();
    super.onClose();
  }

  Future<void> _loadTotalUnread() async {
    try {
      final count = await OpenIM.iMManager.conversationManager.getTotalUnreadMsgCount();
      totalUnread.value = count;
    } catch (_) {}
  }
}
