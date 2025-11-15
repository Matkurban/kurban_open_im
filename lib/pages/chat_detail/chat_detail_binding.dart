import 'package:get/get.dart';
import 'package:kurban_open_im/pages/chat_detail/chat_detail_logic.dart';

class ChatDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatDetailLogic());
  }
}