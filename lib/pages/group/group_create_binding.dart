import 'package:get/get.dart';
import 'group_create_logic.dart';

class GroupCreateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GroupCreateLogic());
  }
}