import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class MainLogic extends GetxController {
  ///控制页面的切换
  late PageController mainPageController;

  ///当前选中的索引
  final RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    mainPageController = PageController();
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
}
