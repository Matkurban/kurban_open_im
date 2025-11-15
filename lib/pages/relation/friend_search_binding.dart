import 'package:get/get.dart';
import 'friend_search_logic.dart';

class FriendSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FriendSearchLogic());
  }
}