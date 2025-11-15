import 'package:get/get.dart';
import 'package:kurban_open_im/pages/chat/chat_logic.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatLogic());
  }
}
