import 'package:get/get.dart';
import 'friend_add_logic.dart';

class FriendAddBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FriendAddLogic());
  }
}