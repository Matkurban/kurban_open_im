import 'package:get/get.dart';
import 'package:kurban_open_im/pages/contact/friend/friend_search_logic.dart';

class FriendSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FriendSearchLogic());
  }
}
