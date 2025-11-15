import 'package:get/get.dart';
import 'package:kurban_open_im/pages/contact/contact_logic.dart';
import 'package:kurban_open_im/pages/conversation/conversation_logic.dart';
import 'package:kurban_open_im/pages/main/main_logic.dart';
import 'package:kurban_open_im/pages/mine/mine_logic.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MainLogic());
    Get.put(ConversationLogic());
    Get.put(ContactLogic());
    Get.put(MineLogic());
  }
}
