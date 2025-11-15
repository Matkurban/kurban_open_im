import 'package:get/get.dart';
import 'group_applications_logic.dart';

class GroupApplicationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GroupApplicationsLogic());
  }
}