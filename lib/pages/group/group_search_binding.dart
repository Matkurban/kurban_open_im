import 'package:get/get.dart';
import 'group_search_logic.dart';

class GroupSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GroupSearchLogic());
  }
}