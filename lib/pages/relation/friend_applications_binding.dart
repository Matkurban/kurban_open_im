import 'package:get/get.dart';
import 'friend_applications_logic.dart';

class FriendApplicationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FriendApplicationsLogic());
  }
}