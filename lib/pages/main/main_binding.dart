import 'package:get/get.dart';
import 'package:kurban_open_im/pages/contact/contact_logic.dart';
import 'package:kurban_open_im/pages/conversation/conversation_logic.dart';
import 'package:kurban_open_im/pages/main/main_logic.dart';
import 'package:kurban_open_im/pages/mine/mine_logic.dart';
import 'package:kurban_open_im/repository/friend_repository.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<FriendRepository>()) {
      Get.put(FriendRepository(), permanent: true);
    }
    Get.put(MainLogic());
    Get.put(ConversationLogic());
    Get.put(ContactLogic());
    Get.put(MineLogic());
  }
}
